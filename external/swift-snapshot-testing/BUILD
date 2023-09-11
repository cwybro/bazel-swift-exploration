load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)

swift_library(
    name = "SnapshotTesting",
    testonly = True,
    srcs = glob(
        [
            "Sources/**/*.swift",
        ],
        allow_empty = False,
    ),
    copts = [
        "-suppress-warnings",
    ],
    module_name = "SnapshotTesting",
    visibility = ["//visibility:public"],
)
