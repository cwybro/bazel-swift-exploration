import ArgumentParser
import BEPCore
import PathKit
import src_main_java_com_google_devtools_build_lib_buildeventstream_proto_build_event_stream_proto

internal struct ExtractXCResultCommand: ParsableCommand {

    internal enum Error: Swift.Error, CustomStringConvertible {
        case missingTestOutputs
        case missingXCResults

        internal var description: String {
            switch self {
                case .missingTestOutputs:
                    return "Missing 'test.outputs' directory in BEP file"
                case .missingXCResults:
                    return "Missing 'tests.xcresult' files in BEP file"
            }
        }
    }

    internal static let configuration: CommandConfiguration = .init(
        commandName: "extract-xcresult",
        abstract: "A tool for extracting paths to XCResult files from a Bazel BEP binary file. If multiple XCResult files are found, only the first is returned.")

    @Option(name: .long, help: "Path to Bazel BEP file.")
    internal var bepPath: String

    internal func run() throws {
        let parser: BEPParserImp = .init()
        let events: [BuildEventStream_BuildEvent] = try parser.readEvents(bepPath: bepPath)
        let testOutputsPaths: [BuildEventStream_File] = events
            .flatMap {
                $0.testResult.testActionOutput
            }
            .filter {
                $0.name == "test.outputs"
            }
        guard !testOutputsPaths.isEmpty else {
            throw Error.missingTestOutputs
        }
        let xcresultPaths: [Path] = try testOutputsPaths
            .map {
                parseURI(uri: $0.uri)
            }
            .flatMap { path in
                try path.children().filter {
                    $0.lastComponent == "tests.xcresult"
                }
            }
        guard !xcresultPaths.isEmpty else {
            throw Error.missingXCResults
        }
        print(xcresultPaths[0].string)
    }

    private func parseURI(uri: String) -> Path {
        let prefix: String = "file://"
        if uri.hasPrefix(prefix) {
            return Path(String(uri.dropFirst(prefix.count)))
        } else {
            return Path(uri)
        }
    }
}
