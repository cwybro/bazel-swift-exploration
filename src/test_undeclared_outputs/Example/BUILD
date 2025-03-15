load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_unit_test",
)
load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
    "swift_test",
)

filegroup(
    name = "ExampleTests_Snapshots",
    srcs = glob(
        [
            "__Snapshots__/**/*",
        ],
        allow_empty = False,
    ),
)

# [CW] 3/13/23 - 'swift_test' automatically propagates 'TEST_UNDECLARED_OUTPUTS_DIR' and 'env.RUNFILES_DIR' to the
# process environment, without explicitly setting the 'env' (see the 'ios_unit_test' target below).
swift_test(
    name = "ExampleTests_swift_test",
    testonly = True,
    srcs = ["Tests/ExampleTests.swift"],
    data = [":ExampleTests_Snapshots"],
    deps = [
        "//src/test_undeclared_outputs/TestKit",
    ],
)

swift_library(
    name = "ExampleTestsLib",
    testonly = True,
    srcs = ["Tests/ExampleTests.swift"],
    deps = [
        "//src/test_undeclared_outputs/TestKit",
    ],
)

# [CW] 3/13/23 - Unlike the 'swift_test' target, 'env.TEST_UNDECLARED_OUTPUTS_DIR' and 'env.RUNFILES_DIR' must be
# explicitly defined to propagate to the process environment.
ios_unit_test(
    name = "ExampleTests_ios_unit_test",
    data = [":ExampleTests_Snapshots"],
    env = {
        "TEST_UNDECLARED_OUTPUTS_DIR": "$$TEST_UNDECLARED_OUTPUTS_DIR",
        "RUNFILES_DIR": "$$RUNFILES_DIR",
    },
    minimum_os_version = "16.0",
    runner = "@build_bazel_rules_apple//apple/testing/default_runner:ios_xctestrun_ordered_runner",
    deps = [
        ":ExampleTestsLib",
    ],
)
