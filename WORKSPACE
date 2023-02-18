load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

http_archive(
    name = "com_github_buildbuddy_io_rules_xcodeproj",
    sha256 = "1e2f40eaee520093343528ac9a4a9180b0500cdd83b1e5e2a95abc8c541686e2",
    url = "https://github.com/buildbuddy-io/rules_xcodeproj/releases/download/1.1.0/release.tar.gz",
)

load(
    "@com_github_buildbuddy_io_rules_xcodeproj//xcodeproj:repositories.bzl",
    "xcodeproj_rules_dependencies",
)

xcodeproj_rules_dependencies()

load(
    "@build_bazel_rules_apple//apple:repositories.bzl",
    "apple_rules_dependencies",
)

apple_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()

load(
    "@build_bazel_apple_support//lib:repositories.bzl",
    "apple_support_dependencies",
)

apple_support_dependencies()

http_archive(
    name = "com_github_bazelbuild_rules_proto",
    sha256 = "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
    strip_prefix = "rules_proto-5.3.0-21.7",
    urls = [
        "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
    ],
)

load(
    "@com_github_bazelbuild_rules_proto//proto:repositories.bzl",
    "rules_proto_dependencies",
    "rules_proto_toolchains",
)

rules_proto_dependencies()

rules_proto_toolchains()

http_archive(
    name = "com_github_bazelbuild_bazel",
    patches = [
        "//infra/patches:build_event_stream_java_proto.patch",
    ],
    sha256 = "06d3dbcba2286d45fc6479a87ccc649055821fc6da0c3c6801e73da780068397",
    strip_prefix = "bazel-6.0.0",
    url = "https://github.com/bazelbuild/bazel/archive/refs/tags/6.0.0.tar.gz",
)

http_archive(
    name = "com_github_apple_swift_argument_parser",
    build_file = "swift-argument-parser/BUILD",
    sha256 = "44782ba7180f924f72661b8f457c268929ccd20441eac17301f18eff3b91ce0c",
    strip_prefix = "swift-argument-parser-1.2.2",
    url = "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.2.2.tar.gz",
)
