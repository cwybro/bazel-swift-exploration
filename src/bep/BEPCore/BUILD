load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
    "swift_proto_library",
)

# [CW] 2/17/23 - https://github.com/bazelbuild/bazel/blob/master/src/main/java/com/google/devtools/build/lib/buildeventstream/proto/build_event_stream.proto
swift_proto_library(
    name = "BEP_Protos",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_bazelbuild_bazel//src/main/java/com/google/devtools/build/lib/buildeventstream/proto:build_event_stream_proto",
    ],
)

swift_library(
    name = "BEPCore",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "BEPCore",
    visibility = ["//visibility:public"],
    deps = [
        ":BEP_Protos",
    ],
)
