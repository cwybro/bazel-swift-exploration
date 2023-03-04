import ArgumentParser
import Foundation
import PathKit
import XCResultTypes_Generated

@main
internal struct RootCommand: ParsableCommand {

    internal enum Error: Swift.Error, CustomStringConvertible {
        case processFailed(outputString: String, errorString: String, terminationStatus: Int32)

        internal var description: String {
            switch self {
                case let .processFailed(outputString: outputString, errorString: errorString, terminationStatus: terminationStatus):
                    return """
                        Process failed:
                        - termination status: \(terminationStatus)
                        - output: \(outputString)
                        - error: \(errorString)
                        """
            }
        }
    }

    internal static let configuration: CommandConfiguration = .init(
        commandName: "xcresultparser",
        abstract: "A tool for parsing XCResult files.")

    @Option(name: .long, help: "Path to '.xcresult' file.")
    internal var xcresultPath: String

    internal func run() throws {
        let root: XCResultTypes.ActionsInvocationRecord = try parseXCResult()
        try logTestResults(actionsInvocationRecord: root)
    }

    private func parseXCResult<T: Codable>(id: String? = nil) throws -> T {
        let process: Process = .init()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        var arguments: [String] = [
            "xcresulttool",
            "get",
            "--format=json",
            "--path=\(xcresultPath)"
        ]
        if let id = id {
            arguments.append("--id=\(id)")
        }
        process.arguments = arguments
        let outputPipe: Pipe = .init()
        let errorPipe: Pipe = .init()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        try process.run()
        process.waitUntilExit()
        let outputData: Data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData: Data = errorPipe.fileHandleForReading.readDataToEndOfFile()
        guard process.terminationStatus == 0 else {
            throw Error.processFailed(
                outputString: String(decoding: outputData, as: UTF8.self),
                errorString: String(decoding: errorData, as: UTF8.self),
                terminationStatus: process.terminationStatus)
        }
        return try JSONDecoder().decode(T.self, from: outputData)
    }

    private func logTestResults(actionsInvocationRecord: XCResultTypes.ActionsInvocationRecord) throws {
        guard
            let actionRecords: [XCResultTypes.ActionRecord] = actionsInvocationRecord.actions?.values,
            !actionRecords.isEmpty
        else {
            print("Missing action records")
            return
        }
        let actionTestPlanRunSummaries: [XCResultTypes.ActionTestPlanRunSummaries] = try actionRecords
            .compactMap { actionRecord in
                actionRecord.actionResult?.testsRef?.id?.value
            }
            .map { testRefID in
                try parseXCResult(id: testRefID)
            }
        let actionTestableSummaries: [XCResultTypes.ActionTestableSummary] = actionTestPlanRunSummaries
            .flatMap {
                $0.summaries?.values ?? []
            }
            .flatMap {
                $0.testableSummaries?.values ?? []
            }
        actionTestableSummaries.forEach { testableSummary in
            let tests: String = (testableSummary.tests?.values ?? []).map {
                makeTestString(test: $0, iteration: 1)
            }.joined(separator: "\n")
            print("""
            - target: \(testableSummary.targetName?.value ?? "missing")
              tests:
            \(tests)
            """)
        }
    }

    private func makeTestString(test: XCResultTypes.ActionTestSummaryGroup, iteration: Int) -> String {
        let subtests: [XCResultTypes.ActionTestSummaryGroup] = test.subtests?.values ?? []
        let spacePrefix: String = (0..<iteration).map { _ in "\t" }.joined()
        while !subtests.isEmpty {
            let subtests: String = subtests.map {
                makeTestString(test: $0, iteration: iteration + 1)
            }.joined(separator: "\n")
            return """
                \(spacePrefix)- identifier: \(test.identifier?.value ?? "missing")
                \(spacePrefix)  duration: \(test.duration?.value ?? -1)
                \(spacePrefix)  subtests:
                \(subtests)
                """
        }
        return """
            \(spacePrefix)- identifier: \(test.identifier?.value ?? "missing")
            \(spacePrefix)  duration: \(test.duration?.value ?? -1)
            """
    }
}
