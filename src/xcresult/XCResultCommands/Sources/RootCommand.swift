import ArgumentParser

@main
internal struct RootCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        commandName: "xcresult",
        abstract: "A tool for XCResult utilities.",
        subcommands: [GenerateCommand.self])
}
