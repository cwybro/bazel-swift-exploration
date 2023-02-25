import BEPCore
import GRPC
import google_devtools_build_v1_publish_build_event_proto
import src_main_java_com_google_devtools_build_lib_buildeventstream_proto_build_event_stream_proto

class FlakyTestTargetServerInterceptor: ServerInterceptor
<
    Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest,
    Google_Devtools_Build_V1_PublishBuildToolEventStreamResponse
> {

    override func receive(
        _ part: GRPCServerRequestPart<Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest>,
        context: ServerInterceptorContext<Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest, Google_Devtools_Build_V1_PublishBuildToolEventStreamResponse>
    ) {
        if let buildEvents: [BuildEventStream_BuildEvent] = context.userInfo[BuildEventsKey.self], !buildEvents.isEmpty {
            detectFlakyTests(buildEvents: buildEvents)
        }
        context.receive(part)
    }

    private func detectFlakyTests(buildEvents: [BuildEventStream_BuildEvent]) {
       let flakyTestTargetMap: FlakyTestTargetMapImp = .init()
       let flakyTargets: [FlakyTestTarget] = flakyTestTargetMap.map(events: buildEvents)
       print("✅ Found \(flakyTargets.count) flaky test targets:")
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
