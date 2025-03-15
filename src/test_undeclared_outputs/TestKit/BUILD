load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)

swift_library(
    name = "TestKit",
    testonly = True,
    srcs = glob(
        [
            "Sources/**/*.swift",
        ],
        allow_empty = False,
    ),
    module_name = "TestKit",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_pointfreeco_swift_snapshot_testing//:SnapshotTesting",
        "@pathkit//:PathKit",
    ],
)
