load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_grpc_library",
    "swift_library",
    "swift_proto_library",
)
load(
    "@com_github_buildbuddy_io_rules_xcodeproj//xcodeproj:defs.bzl",
    "xcodeproj",
)

swift_proto_library(
    name = "publish_build_event_proto_swift",
    visibility = ["//visibility:public"],
    deps = [
        "@com_google_googleapis//google/devtools/build/v1:publish_build_event_proto",
    ],
)

swift_grpc_library(
    name = "publish_build_event_server_services_swift",
    srcs = ["@com_google_googleapis//google/devtools/build/v1:publish_build_event_proto"],
    flavor = "server",
    deps = [":publish_build_event_proto_swift"],
)

proto_library(
    name = "health_proto",
    srcs = ["Health/health.proto"],
)

swift_proto_library(
    name = "health_proto_swift",
    visibility = ["//visibility:public"],
    deps = [
        ":health_proto",
    ],
)

swift_grpc_library(
    name = "health_server_services_swift",
    srcs = [":health_proto"],
    flavor = "server",
    deps = [":health_proto_swift"],
)

swift_grpc_library(
    name = "health_client_services_swift",
    srcs = [":health_proto"],
    flavor = "client",
    deps = [":health_proto_swift"],
)

swift_library(
    name = "BESServer",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "BESServer",
    deps = [
        ":health_server_services_swift",
        ":publish_build_event_server_services_swift",
        "//src/bep/BEPCore",
        "//src/bep/BEPCore:BEP_Protos",
    ],
)

swift_binary(
    name = "publish_build_event_server",
    srcs = ["Server/main.swift"],
    deps = [
        ":BESServer",
    ],
)

xcodeproj(
    name = "project",
    bazel_path = "/usr/local/bin/bazelisk",
    project_name = "project",
    tags = ["manual"],
    top_level_targets = [
        ":publish_build_event_server",
        ":sandbox",
    ],
)

swift_binary(
    name = "sandbox",
    srcs = ["Sandbox/main.swift"],
    deps = [
        ":health_client_services_swift",
    ],
)
