load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)

swift_library(
    name = "Stencil",
    srcs = glob(["Sources/**/*.swift"]),
    module_name = "Stencil",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_kylef_pathkit//:PathKit",
    ],
)
