load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_library",
)

swift_library(
    name = "CredentialHelperCommands",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "CredentialHelperCommands",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_apple_swift_argument_parser//:ArgumentParser",
        "@com_github_kylef_pathkit//:PathKit",
    ],
)

swift_binary(
    name = "credential-helper",
    visibility = ["//visibility:public"],
    deps = [
        ":CredentialHelperCommands",
    ],
)
