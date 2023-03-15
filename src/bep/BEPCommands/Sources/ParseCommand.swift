import ArgumentParser
import BEPCore

internal struct ParseCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        commandName: "parse",
        abstract: "A tool for parsing Bazel Build Event Protocol binary files.")

    @Option(help: "Path to BEP file.")
    internal var bepPath: String

    internal func run() throws {
        let parser: BEPParserImp = .init()
        let buildEvents = try parser.readEvents(bepPath: bepPath)
        buildEvents.forEach { event in
            event.namedSetOfFiles.files.forEach { file in
                print("- \(file)")
            }
        }
    }
}
