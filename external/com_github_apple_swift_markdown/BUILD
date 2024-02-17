load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)

swift_library(
    name = "Markdown",
    srcs = glob(
        [
            "Sources/Markdown/**/*.swift",
        ],
        allow_empty = False,
    ),
    module_name = "Markdown",
    visibility = [
        "@com_github_apple_swift_format//:__pkg__",
    ],
    deps = [
        ":CAtomic",
        "@com_github_apple_swift_cmark//:cmark-gfm",
        "@com_github_apple_swift_cmark//:cmark-gfm-extensions",
    ],
)

cc_library(
    name = "CAtomic",
    srcs = glob(
        [
            "Sources/CAtomic/*",
        ],
        allow_empty = False,
    ),
    hdrs = glob(
        [
            "Sources/CAtomic/include/*.h",
        ],
        allow_empty = False,
    ),
    includes = [
        "Sources/CAtomic/include",
    ],
    tags = [
        "swift_module=CAtomic",
    ],
)
