load(
    "@build_bazel_rules_swift//proto:swift_proto_library.bzl",
    "swift_proto_library",
)
load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_library",
)
load(
    "@rules_proto//proto:defs.bzl",
    "proto_library",
)

swift_proto_library(
    name = "build_proto_swift",
    protos = [
        "@googleapis//google/devtools/build/v1:build_proto",
    ],
    visibility = ["//visibility:public"],
)

swift_proto_library(
    name = "publish_build_event_server_services_swift",
    compilers = [
        "@build_bazel_rules_swift//proto/compilers:swift_proto",
        "@build_bazel_rules_swift//proto/compilers:swift_server_proto",
    ],
    protos = ["@googleapis//google/devtools/build/v1:build_proto"],
    deps = [":build_proto_swift"],
)

proto_library(
    name = "health_proto",
    srcs = ["Health/health.proto"],
)

swift_proto_library(
    name = "health_proto_swift",
    protos = [
        ":health_proto",
    ],
    visibility = ["//visibility:public"],
)

swift_proto_library(
    name = "health_server_services_swift",
    compilers = [
        "@build_bazel_rules_swift//proto/compilers:swift_proto",
        "@build_bazel_rules_swift//proto/compilers:swift_server_proto",
    ],
    protos = [":health_proto"],
    deps = [":health_proto_swift"],
)

swift_proto_library(
    name = "health_client_services_swift",
    compilers = [
        "@build_bazel_rules_swift//proto/compilers:swift_client_proto",
        "@build_bazel_rules_swift//proto/compilers:swift_proto",
    ],
    protos = [":health_proto"],
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
        "//src/bep/BEPCore:BuildEventStreamProtoSwift",
    ],
)

swift_binary(
    name = "publish_build_event_server",
    srcs = ["Server/main.swift"],
    deps = [
        ":BESServer",
    ],
)

swift_binary(
    name = "sandbox",
    srcs = ["Sandbox/main.swift"],
    deps = [
        ":health_client_services_swift",
    ],
)
