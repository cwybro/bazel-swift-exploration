load(
    "@build_bazel_rules_swift//proto:swift_proto_library.bzl",
    "swift_proto_library",
)
load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)

# [CW] 2/17/23 - https://github.com/bazelbuild/bazel/blob/master/src/main/java/com/google/devtools/build/lib/buildeventstream/proto/build_event_stream.proto
swift_proto_library(
    name = "BuildEventStreamProtoSwift",
    protos = [
        "@com_github_bazelbuild_bazel//src/main/java/com/google/devtools/build/lib/buildeventstream/proto:build_event_stream_proto",
        "@com_github_bazelbuild_bazel//src/main/java/com/google/devtools/build/lib/packages/metrics:package_load_metrics_proto",
        "@com_github_bazelbuild_bazel//src/main/protobuf:action_cache_proto",
        "@com_github_bazelbuild_bazel//src/main/protobuf:command_line_proto",
        "@com_github_bazelbuild_bazel//src/main/protobuf:failure_details_proto",
        "@com_github_bazelbuild_bazel//src/main/protobuf:invocation_policy_proto",
        # "@com_google_protobuf//src/google/protobuf:any_proto",
        # "@com_google_protobuf//src/google/protobuf:duration_proto",
        # "@com_google_protobuf//src/google/protobuf:timestamp_proto",
        "@com_google_protobuf//:any_proto",
        "@com_google_protobuf//:duration_proto",
        "@com_google_protobuf//:timestamp_proto",
    ],
    visibility = ["//visibility:public"],
)

swift_library(
    name = "BEPCore",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "BEPCore",
    visibility = ["//visibility:public"],
    deps = [
        ":BuildEventStreamProtoSwift",
    ],
)
