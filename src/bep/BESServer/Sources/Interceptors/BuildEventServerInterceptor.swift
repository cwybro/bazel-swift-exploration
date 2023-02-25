import Foundation
import GRPC
import google_devtools_build_v1_publish_build_event_proto
import src_main_java_com_google_devtools_build_lib_buildeventstream_proto_build_event_stream_proto
import SwiftProtobuf

enum BuildEventsKey: UserInfoKey {
    typealias Value = [BuildEventStream_BuildEvent]
}

// [CW] 2/20/23 - Based on:
// https://github.com/grpc/grpc-swift/blob/main/docs/interceptors-tutorial.md
class BuildEventServerInterceptor: ServerInterceptor
<
    Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest,
    Google_Devtools_Build_V1_PublishBuildToolEventStreamResponse
> {

    private var buildEvents: [BuildEventStream_BuildEvent] = []

    override func receive(
        _ part: GRPCServerRequestPart<Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest>,
        context: ServerInterceptorContext<Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest, Google_Devtools_Build_V1_PublishBuildToolEventStreamResponse>
    ) {
        switch part {
        case .metadata(_):
            break
        case let .message(response):
            appendBuildEventIfNeeded(bazelEvent: response.orderedBuildEvent.event.bazelEvent)
        case .end:
            context.userInfo[BuildEventsKey.self] = buildEvents
            writeBuildEventsLog()
        }
        // Forward the response part to the next interceptor.
        context.receive(part)
    }

    private func appendBuildEventIfNeeded(bazelEvent: Google_Protobuf_Any) {
        do {
            let buildEvent: BuildEventStream_BuildEvent = try BuildEventStream_BuildEvent(
                unpackingAny: bazelEvent)
            buildEvents.append(buildEvent)
        } catch {
            print("❌ Failed to cast to BuildEventStream_BuildEvent: \(bazelEvent.typeURL)")
        }
    }

    private func writeBuildEventsLog() {
        do {
            let paths: [URL] = FileManager.default.urls(
                for: .downloadsDirectory,
                in: .userDomainMask)
            let artifactURL: URL = paths[0]
                .appending(path: "bes-logs")
                .appending(path: "\(UUID().uuidString)__build_events.log")
            let logOutput: String = buildEvents.map { "\($0)" }.joined(separator: "\n\n")
            try logOutput.write(
                to: artifactURL,
                atomically: true,
                encoding: .utf8)
            print("✅ Wrote \(buildEvents.count) build events to path: \(artifactURL.absoluteString)")
        } catch {
            print("❌ Error writing build events log: \(error)")
        }
    }
}
