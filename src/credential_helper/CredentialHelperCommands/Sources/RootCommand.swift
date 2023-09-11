import ArgumentParser

@main
internal struct RootCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        abstract: "A tool for Bazel Credential Helper utilities.",
        subcommands: [
            GetCommand.self
        ])
}
