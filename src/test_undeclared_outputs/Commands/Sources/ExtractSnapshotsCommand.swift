import ArgumentParser
import BEPCore
import PathKit

internal struct ExtractSnapshotsCommand: ParsableCommand {

    internal enum Error: Swift.Error, CustomStringConvertible {
        case missingTestOutputs
        case missingAssertSnapshot(path: String)
        case missingPathComponent(path: String, expectedComponent: String)

        internal var description: String {
            switch self {
            case .missingTestOutputs:
                return "Missing 'test.outputs' directory in BEP file"
            case let .missingAssertSnapshot(path: path):
                return "Missing 'assert_snapshot' child directory in path: \(path)"
            case let .missingPathComponent(path: path, expectedComponent: expectedComponent):
                return """
                    Missing component in path:
                    - path: \(path)
                    - expected component: \(expectedComponent)
                    """
            }
        }
    }

    internal static let configuration: CommandConfiguration = .init(
        commandName: "extract-snapshots",
        abstract: "A tool for extracting recorded snapshot artifacts from 'TEST_UNDECLARED_OUTPUTS_DIR' found in a Bazel BEP binary file.")

    @Option(help: "Path to BEP file.")
    internal var bepPath: String

    @Option(help: "Path to local workspace to extract snapshots.")
    internal var workspacePath: String

    internal func run() throws {
        let parser: BEPParserImp = .init()
        let buildEvents = try parser.readEvents(bepPath: bepPath)
        let testOutputsPaths: [Path] = buildEvents
            .map(\.testResult)
            .flatMap(\.testActionOutput)
            .filter {
                $0.name == "test.outputs"
            }
            .map {
                parseURI(uri: $0.uri)
            }
        guard !testOutputsPaths.isEmpty else {
            throw Error.missingTestOutputs
        }
        let firstTestOutputPath: Path = testOutputsPaths[0]
        let assertSnapshotPath: Path = firstTestOutputPath + "assert_snapshot"
        guard assertSnapshotPath.exists else {
            throw Error.missingAssertSnapshot(path: firstTestOutputPath.string)
        }
        try assertSnapshotPath.recursiveChildren()
            .filter {
                $0.isFile
            }
            .forEach { path in
                let destinationPath: Path = try Path(workspacePath) + makeRelativePath(path: path)
                try destinationPath.parent().mkpath()
                if destinationPath.exists {
                    try destinationPath.delete()
                }
                try path.copy(destinationPath)
        }
    }

    private func parseURI(uri: String) -> Path {
        let prefix: String = "file://"
        if uri.hasPrefix(prefix) {
            return Path(String(uri.dropFirst(prefix.count)))
        } else {
            return Path(uri)
        }
    }

    private func makeRelativePath(path: Path) throws -> Path {
        let assertSnapshotComponent: String = "assert_snapshot"
        guard let assertSnapshotIndex: Int = path.components.firstIndex(where: {
            $0 == assertSnapshotComponent
        }) else {
            throw Error.missingPathComponent(
                path: path.string,
                expectedComponent: assertSnapshotComponent)
        }
        return Path(components: path.components[assertSnapshotIndex + 1..<path.components.count])
    }
}
