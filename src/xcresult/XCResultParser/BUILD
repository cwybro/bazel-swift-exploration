load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_library",
)

swift_library(
    name = "XCResultParser",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "XCResultParser",
    deps = [
        "//src/xcresult/XCResultCommands:XCResultTypes_Generated",
        "@pathkit//:PathKit",
        "@swift_argument_parser//:ArgumentParser",
    ],
)

swift_binary(
    name = "xcresultparser",
    deps = [
        ":XCResultParser",
    ],
)
