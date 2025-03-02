load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
)

swift_binary(
    name = "sandbox",
    srcs = glob(
        [
            "Sources/**/*.swift",
        ],
        allow_empty = False,
    ),
    deps = [
        "@com_github_apple_swift_syntax//:SwiftParser",
        "@com_github_apple_swift_syntax//:SwiftSyntax",
        "@com_github_apple_swift_syntax//:SwiftSyntaxBuilder",
        "@com_github_stencilproject_stencil//:Stencil",
    ],
)
