import ArgumentParser
import BEPCore

internal struct ParseCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        commandName: "parse",
        abstract: "A tool for parsing Bazel Build Event Protocol binary files.")

    internal func run() throws {
        print("ParseCommand")
        let bepPath: String = "/Users/connorwybranowski/Downloads/ExampleTests_flaky_bep"
        let parser: BEPParserImp = .init()
        let flakyTestTargetMap: FlakyTestTargetMapImp = .init()
        let flakyTargets: [FlakyTestTarget] = flakyTestTargetMap.map(
            events: try parser.readEvents(bepPath: bepPath))
        print("Found \(flakyTargets.count) flaky test targets:")
        flakyTargets.forEach {
            print("""
            - label: \($0.label)
              runsPerTest: \($0.runsPerTest)
              totalRunCount: \($0.totalRunCount)
              passedCount: \($0.passedCount)
              failedCount: \($0.failedCount)
              wallTimeDurationMillis: \($0.wallTimeDurationMillis)
              systemTimeDurationMillis: \($0.systemTimeDurationMillis)
              failedRunArtifactPaths:
            \($0.failedRunArtifactPaths.map { "\t- \($0)" }.joined(separator: "\n"))
            """)
        }
    }
}
