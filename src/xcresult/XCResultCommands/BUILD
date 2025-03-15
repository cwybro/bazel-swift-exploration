load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_library",
)

swift_library(
    name = "XCResultCommands",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "XCResultCommands",
    deps = [
        "@com_github_stencilproject_stencil//:Stencil",
        "@pathkit//:PathKit",
        "@swift_argument_parser//:ArgumentParser",
        "@yams//:Yams",
    ],
)

swift_binary(
    name = "xcresult",
    deps = [
        ":XCResultCommands",
    ],
)

genrule(
    name = "xcrun_xcresulttool_format_description",
    outs = ["format_description.json"],
    cmd = "xcrun xcresulttool formatDescription get --format=json --version=3 > \"$@\"",
)

genrule(
    name = "generate_xcresult_types",
    srcs = [
        "format_description.json",
        "Resources/xcrun_xcresulttool_formationDescription_get__overrides_v3.yml",
    ],
    outs = ["GeneratedXCResultTypes.swift"],
    cmd = "./$(location xcresult) generate --format-description-json-path=$(location format_description.json) --type-overrides-path=$(location Resources/xcrun_xcresulttool_formationDescription_get__overrides_v3.yml)  > \"$@\"",
    tools = [":xcresult"],
)

swift_library(
    name = "XCResultTypes_Generated",
    srcs = [
        "GeneratedXCResultTypes.swift",
        "XCResultTypes_Generated/HandwrittenTypes.swift",
    ],
    module_name = "XCResultTypes_Generated",
    visibility = ["//visibility:public"],
)
