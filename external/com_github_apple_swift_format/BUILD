load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_binary",
    "swift_library",
)

swift_library(
    name = "SwiftFormat",
    srcs = glob(
        [
            "Sources/SwiftFormat/**/*.swift",
        ],
        allow_empty = False,
    ),
    module_name = "SwiftFormat",
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "@com_github_apple_swift_markdown//:Markdown",
        "@com_github_apple_swift_syntax//:SwiftOperators",
        "@com_github_apple_swift_syntax//:SwiftParser",
        "@com_github_apple_swift_syntax//:SwiftParserDiagnostics",
        "@com_github_apple_swift_syntax//:SwiftSyntax",
    ],
)

swift_binary(
    name = "swift-format",
    srcs = glob(
        [
            "Sources/swift-format/**/*.swift",
        ],
        allow_empty = False,
    ),
    visibility = [
        "//visibility:public",
    ],
    deps = [
        ":SwiftFormat",
        "@com_github_apple_swift_argument_parser//:ArgumentParser",
        "@com_github_apple_swift_syntax//:SwiftParser",
        "@com_github_apple_swift_syntax//:SwiftSyntax",
    ],
)
