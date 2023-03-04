load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_library",
)

swift_library(
    name = "BEPCommands",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "BEPCommands",
    visibility = ["//visibility:public"],
    deps = [
        "//src/bep/BEPCore",
        "@com_github_apple_swift_argument_parser//:ArgumentParser",
        "@com_github_kylef_pathkit//:PathKit",
    ],
)

swift_binary(
    name = "bep",
    visibility = ["//visibility:public"],
    deps = [
        ":BEPCommands",
    ],
)
