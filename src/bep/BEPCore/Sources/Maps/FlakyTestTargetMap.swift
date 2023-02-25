import src_main_java_com_google_devtools_build_lib_buildeventstream_proto_build_event_stream_proto

public protocol FlakyTestTargetMap {

    func map(events: [BuildEventStream_BuildEvent]) -> [FlakyTestTarget]
}

public final class FlakyTestTargetMapImp: FlakyTestTargetMap {

    public init() {}

    public func map(events: [BuildEventStream_BuildEvent]) -> [FlakyTestTarget] {
        let failedArtifactPathsByTarget: [String: [String]] = makeFailedArtifactPathsByTarget(events: events)
        return events
            .filter {
                $0.testSummary.overallStatus == .flaky
            }
            .map {
                makeFlakyTestTarget(
                    event: $0,
                    failedArtifactPathsByTarget: failedArtifactPathsByTarget)
            }
    }

    private func makeFlakyTestTarget(
        event: BuildEventStream_BuildEvent,
        failedArtifactPathsByTarget: [String: [String]]
    ) -> FlakyTestTarget {
        .init(
            label: event.id.testSummary.label,
            runsPerTest: Int(event.testSummary.runCount),
            totalRunCount: Int(event.testSummary.totalRunCount),
            passedCount: event.testSummary.passed.count,
            failedCount: event.testSummary.failed.count,
            wallTimeDurationMillis: event.testSummary.lastStopTimeMillis - event.testSummary.firstStartTimeMillis,
            systemTimeDurationMillis: event.testSummary.totalRunDurationMillis,
            failedRunArtifactPaths: failedArtifactPathsByTarget[event.id.testSummary.label] ?? [])
    }

    private func makeFailedArtifactPathsByTarget(
        events: [BuildEventStream_BuildEvent]
    ) -> [String: [String]] {
        events.filter {
            $0.testResult.status == .failed
        }.reduce(into: [String: [String]]()) { partialResult, value in
            let targetLabel: String = value.id.testResult.label
            var existing: [String] = partialResult[targetLabel] ?? []
            existing.append(contentsOf: value.testResult.testActionOutput.map(\.uri).map(parseURI))
            partialResult[targetLabel] = existing
        }
    }

    private func parseURI(_ uri: String) -> String {
        let prefix: String = "file://"
        guard uri.hasPrefix(prefix) else {
            return uri
        }
        return String(uri.dropFirst(prefix.count))
    }
}
