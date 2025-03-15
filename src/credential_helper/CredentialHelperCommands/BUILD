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
        "@pathkit//:PathKit",
        "@swift_argument_parser//:ArgumentParser",
    ],
)

swift_binary(
    name = "credential-helper",
    visibility = ["//visibility:public"],
    deps = [
        ":CredentialHelperCommands",
    ],
)
