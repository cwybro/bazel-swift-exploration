import ArgumentParser

@main
internal struct RootCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        abstract: "A tool for 'TEST_UNDECLARED_OUTPUTS_DIR' utilities.",
        subcommands: [
            ExtractSnapshotsCommand.self
        ])
}
