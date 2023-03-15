load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_library",
)

swift_library(
    name = "TestUndeclaredOutputsCommands",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "TestUndeclaredOutputsCommands",
    visibility = ["//visibility:public"],
    deps = [
        "//src/bep/BEPCore",
        "@com_github_apple_swift_argument_parser//:ArgumentParser",
        "@com_github_kylef_pathkit//:PathKit",
    ],
)

swift_binary(
    name = "test-undeclared-outputs",
    visibility = ["//visibility:public"],
    deps = [
        ":TestUndeclaredOutputsCommands",
    ],
)
