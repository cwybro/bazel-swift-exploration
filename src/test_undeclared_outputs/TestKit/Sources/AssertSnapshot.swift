import Foundation
import PathKit
import SnapshotTesting
import XCTest

public var isRecording: Bool {
    get {
        SnapshotTesting.isRecording
    }
    set {
        SnapshotTesting.isRecording = newValue
    }
}

private enum AssertSnapshotError: Error, CustomStringConvertible {
    case missingEnvironmentKey(key: String)
    case missingPathComponent(path: String, expectedComponent: String)

    var description: String {
        switch self {
        case let .missingEnvironmentKey(key: key):
            return "Missing key in environment: '\(key)'"
        case let .missingPathComponent(path: path, expectedComponent: expectedComponent):
            return """
                Missing component in path:
                - path: \(path)
                - expected component: \(expectedComponent)
                """
        }
    }
}

public func assertSnapshot<Value, Format>(
    matching value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    do {
        let snapshotDirectory: Path = try makeSnapshotDirectory(
            file: file,
            recording: recording || SnapshotTesting.isRecording)
        let failure = verifySnapshot(
            matching: try value(),
            as: snapshotting,
            named: name,
            record: recording,
            snapshotDirectory: snapshotDirectory.string,
            timeout: timeout,
            file: file,
            testName: testName)
        guard let message = failure else { return }
        XCTFail(message, file: file, line: line)
    } catch {
        XCTFail("\(error)", file: file, line: line)
    }
 }

private func makeSnapshotDirectory(
    file: StaticString,
    recording: Bool
) throws -> Path {
    if recording {
        return try makeRecordingDirectory(file: file)
    } else {
        return try makeNonRecordingDirectory(file: file)
    }
}

 private func makeRecordingDirectory(file: StaticString) throws -> Path {
    let testUndeclaredOutputsDir: String = try environmentValue(key: "TEST_UNDECLARED_OUTPUTS_DIR")
    let assertSnapshotPath: Path = Path(testUndeclaredOutputsDir) + "assert_snapshot"
    let filePath: Path = Path("\(file)")
    let snapshotResourcePath: Path = try makePrefixPath(
        path: filePath,
        delimiterComponent: "Tests")
    let finalPath: Path = assertSnapshotPath
        + snapshotResourcePath
        + "__Snapshots__"
        + filePath.lastComponentWithoutExtension
    try finalPath.mkpath()
    return finalPath
}

private func makeNonRecordingDirectory(file: StaticString) throws -> Path {
    let runfilesDir: String = try environmentValue(key: "RUNFILES_DIR")
    let runfilesDirPath: Path = Path(runfilesDir)
    let filePath: Path = Path("\(file)")
    let snapshotResourcePath: Path = try makePrefixPath(
        path: filePath,
        delimiterComponent: "Tests")
    return runfilesDirPath
        + "__main__"
        + snapshotResourcePath
        + "__Snapshots__"
        + filePath.lastComponentWithoutExtension
}

private func makePrefixPath(path: Path, delimiterComponent: String) throws -> Path {
    guard let componentIndex: Int = path.components.firstIndex(where: {
        $0 == delimiterComponent
    }) else {
        throw AssertSnapshotError.missingPathComponent(
            path: path.string,
            expectedComponent: delimiterComponent)
    }
    return Path(components: path.components[0..<componentIndex])
}

private func environmentValue(key: String) throws -> String {
    guard let value: String = ProcessInfo.processInfo.environment[key] else {
        throw AssertSnapshotError.missingEnvironmentKey(key: key)
    }
    return value
}
