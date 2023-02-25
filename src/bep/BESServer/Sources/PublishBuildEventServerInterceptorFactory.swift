import GRPC
import google_devtools_build_v1_publish_build_event_proto
import src_bep_BESServer_publish_build_event_server_services_swift
import SwiftProtobuf

class PublishBuildEventServerInterceptorFactory: Google_Devtools_Build_V1_PublishBuildEventServerInterceptorFactoryProtocol {
    func makePublishLifecycleEventInterceptors() -> [GRPC.ServerInterceptor<google_devtools_build_v1_publish_build_event_proto.Google_Devtools_Build_V1_PublishLifecycleEventRequest, SwiftProtobuf.Google_Protobuf_Empty>] {
        []
    }

    func makePublishBuildToolEventStreamInterceptors() -> [GRPC.ServerInterceptor<google_devtools_build_v1_publish_build_event_proto.Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest, google_devtools_build_v1_publish_build_event_proto.Google_Devtools_Build_V1_PublishBuildToolEventStreamResponse>] {
        [
            BuildEventServerInterceptor(),
            FlakyTestTargetServerInterceptor()
        ]
    }
}
