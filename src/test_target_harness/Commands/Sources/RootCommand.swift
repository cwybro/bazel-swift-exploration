import ArgumentParser

@main
internal struct RootCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        commandName: "test-target-harness",
        abstract: "A tool for Test Target Harness utilities.",
        subcommands: [
            GenerateTestTargetCommand.self
        ]
    )
}
