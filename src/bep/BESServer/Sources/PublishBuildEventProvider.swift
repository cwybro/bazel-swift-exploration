import GRPC
import google_devtools_build_v1_publish_build_event_proto
import NIO
import src_bep_BESServer_publish_build_event_server_services_swift
import SwiftProtobuf

class PublishBuildEventProviderImp: Google_Devtools_Build_V1_PublishBuildEventProvider {

    private var sequenceNumber: Int64 = 1
    var interceptors: Google_Devtools_Build_V1_PublishBuildEventServerInterceptorFactoryProtocol? = PublishBuildEventServerInterceptorFactory()

    func publishLifecycleEvent(
        request: Google_Devtools_Build_V1_PublishLifecycleEventRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<SwiftProtobuf.Google_Protobuf_Empty> {
        context.eventLoop.makeSucceededFuture(.init())
    }

    func publishBuildToolEventStream(
        context: StreamingResponseCallContext<Google_Devtools_Build_V1_PublishBuildToolEventStreamResponse>
    ) -> EventLoopFuture<(StreamEvent<Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest>) -> Void> {
        context.eventLoop.makeSucceededFuture({ [weak self] event in
            guard let self = self else { return }
            switch event {
            case .message(_):
                let response: Google_Devtools_Build_V1_PublishBuildToolEventStreamResponse = .with {
                    $0.sequenceNumber = self.sequenceNumber
                }
                self.sequenceNumber += 1
                context.sendResponse(response, promise: nil)
            case .end:
                self.sequenceNumber = 1
                context.statusPromise.succeed(.ok)
            }
        })
    }
}
