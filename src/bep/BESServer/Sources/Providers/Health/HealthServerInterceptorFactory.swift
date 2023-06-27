import GRPC
import src_bep_BESServer_health_proto
import src_bep_BESServer_health_server_services_swift
import SwiftProtobuf

class HealthServerInterceptorFactory: Grpc_Health_V1_HealthServerInterceptorFactoryProtocol {
    func makeCheckInterceptors() -> [ServerInterceptor<Grpc_Health_V1_HealthCheckRequest, Grpc_Health_V1_HealthCheckResponse>] {
        []
    }
}
