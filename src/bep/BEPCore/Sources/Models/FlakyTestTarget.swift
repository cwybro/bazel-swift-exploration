public struct FlakyTestTarget {
    public let label: String
    public let runsPerTest: Int
    public let totalRunCount: Int
    public let passedCount: Int
    public let failedCount: Int
    public let wallTimeDurationMillis: Int64
    public let systemTimeDurationMillis: Int64
    public let failedRunArtifactPaths: [String]
}
