load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)
load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_unit_test",
)

swift_library(
    name = "ExampleTestsLib",
    testonly = True,
    srcs = ["Sources/ExampleTests.swift"],
)

ios_unit_test(
    name = "ExampleTests",
    minimum_os_version = "16.0",
    runner = "@build_bazel_rules_apple//apple/testing/default_runner:ios_xctestrun_ordered_runner",
    deps = [
        ":ExampleTestsLib",
    ],
)
