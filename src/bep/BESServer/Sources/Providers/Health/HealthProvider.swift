import Foundation
import GRPC
import NIO
import src_bep_BESServer_health_proto
import src_bep_BESServer_health_server_services_swift
import SwiftProtobuf

class HealthProviderImp: Grpc_Health_V1_HealthProvider {

    var interceptors: Grpc_Health_V1_HealthServerInterceptorFactoryProtocol? = HealthServerInterceptorFactory()

    func check(
        request: Grpc_Health_V1_HealthCheckRequest,
        context: StatusOnlyCallContext
    ) -> EventLoopFuture<Grpc_Health_V1_HealthCheckResponse> {
        context.eventLoop.makeSucceededFuture(.with {
            $0.status = .serving
            $0.pid = "\(ProcessInfo.processInfo.processIdentifier)"
        })
    }
}
