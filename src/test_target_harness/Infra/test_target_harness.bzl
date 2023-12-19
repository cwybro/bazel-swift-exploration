load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_unit_test",
)
load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)

def test_target_harness(
        name,
        test_target_count,
        test_cases_per_target):
    test_targets = []
    for index in range(test_target_count):
        target = _make_ios_unit_test_target(
            name = name,
            index = index,
            test_case_count = test_cases_per_target,
        )
        test_targets.append(":%s" % target)
    native.test_suite(
        name = name,
        tests = test_targets,
    )

def _make_ios_unit_test_target(
        name,
        index,
        test_case_count):
    test_source_name = "%s__TestTargetHarness_GeneratedSource__%s.swift" % (name, index)
    native.genrule(
        name = "%s__TestTargetHarness_GeneratedSource__%s" % (name, index),
        testonly = True,
        outs = [
            test_source_name,
        ],
        cmd = "./$(location //src/test_target_harness/Commands:test-target-harness) generate-test-target --test-class-name=\"%s__TestTargetHarness__GeneratedTestClass__%s\" --test-case-count=%s > \"$@\"" % (name, index, test_case_count),
        tools = ["//src/test_target_harness/Commands:test-target-harness"],
    )
    test_lib_name = "%s__TestTargetHarness_TestLib__%s" % (name, index)
    swift_library(
        name = test_lib_name,
        testonly = True,
        srcs = [test_source_name],
    )
    test_target_name = "%s__TestTargetHarness_TestTarget__%s" % (name, index)
    ios_unit_test(
        name = test_target_name,
        minimum_os_version = "17.0",
        deps = [
            ":%s" % test_lib_name,
        ],
    )
    return test_target_name
