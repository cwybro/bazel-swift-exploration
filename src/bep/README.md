# Build Event Protocol Exploration

- [Build Event Protocol](https://bazel.build/remote/bep) Parsing via Protocol Buffers
    - [BEPParser](BEPCore/Sources/BEPParser.swift)
- [Build Event Service](https://bazel.build/remote/bep#build-event-service) via [built-in Bazel gRPC service](https://github.com/googleapis/googleapis/blob/master/google/devtools/build/v1/publish_build_event.proto)
    - [BESServer](BESServer/Sources/PublishBuildEventServer.swift)
    - [BuildEventServerInterceptor](BESServer/Sources/Interceptors/BuildEventServerInterceptor.swift): Capture `BuildEventStream_BuildEvent` from `Google_Devtools_Build_V1_PublishBuildToolEventStreamRequest` and store in `UserInfo` for use in future interceptors.
    - [FlakyTestTargetServerInterceptor](BESServer/Sources/Interceptors/FlakyTestTargetServerInterceptor.swift): Consume `UserInfo`-stored `BuildEventStream_BuildEvent` to detect flaky tests in streamed builds.
