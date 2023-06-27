import GRPC
import NIO

public enum PublishBuildEventServer {

    public static func startServer() async throws {
        // [CW] 2/20/23 - Based on:
        // https://github.com/grpc/grpc-swift/blob/main/Sources/Examples/Echo/Runtime/Echo.swift#L120
        let builder: Server.Builder = Server.insecure(group: MultiThreadedEventLoopGroup(numberOfThreads: 1))
        let server = try await builder.withServiceProviders([
            PublishBuildEventProviderImp(),
            HealthProviderImp()
        ])
        .bind(host: "localhost", port: 9000)
        .get()
        print("Started BES server: \(server.channel.localAddress!)")
        try await server.onClose.get()
    }
}
