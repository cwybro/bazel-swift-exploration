load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_library",
)

swift_library(
    name = "TestTargetHarnessCommands",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "TestTargetHarnessCommands",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_apple_swift_argument_parser//:ArgumentParser",
        "@com_github_stencilproject_stencil//:Stencil",
    ],
)

swift_binary(
    name = "test-target-harness",
    visibility = ["//visibility:public"],
    deps = [
        ":TestTargetHarnessCommands",
    ],
)
