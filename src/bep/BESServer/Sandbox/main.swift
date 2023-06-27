import GRPC
import src_bep_BESServer_health_client_services_swift
import src_bep_BESServer_health_proto

let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
defer {
    try? group.syncShutdownGracefully()
}

let channel = try GRPCChannelPool.with(
    target: .host("localhost", port: 9000),
    transportSecurity: .plaintext,
    eventLoopGroup: group)

let health = Grpc_Health_V1_HealthClient(channel: channel)
let request: Grpc_Health_V1_HealthCheckRequest = .init()
let response = health.check(
    request,
    callOptions: .init(timeLimit: .timeout(.milliseconds(100))))
let output = try response.response.wait()
print("output: \(output.status) (\(output.pid))")
