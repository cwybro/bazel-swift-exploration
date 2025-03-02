load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

http_archive(
    name = "build_bazel_rules_apple",
    sha256 = "7d10bbf8ec7bf5d6542122babbb3464e643e981d01967b4d600af392b868d817",
    url = "https://github.com/bazelbuild/rules_apple/releases/download/3.19.1/rules_apple.3.19.1.tar.gz",
)

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
    name = "com_google_googleapis",
    patches = [
        "//infra/patches:publish_build_event_proto.patch",
    ],
    sha256 = "18a735ec31b7767cabfce0a8f71e7e8e74c11aa18fbd50fbdc0db5b26c2f6278",
    strip_prefix = "googleapis-f9d9c0418f10c2352fbe4515cac9e7072f9924a2",
    url = "https://github.com/googleapis/googleapis/archive/f9d9c0418f10c2352fbe4515cac9e7072f9924a2.tar.gz",
)

load(
    "@com_google_googleapis//:repository_rules.bzl",
    "switched_rules_by_language",
)

switched_rules_by_language(
    name = "com_google_googleapis_imports",
)

http_archive(
    name = "com_github_apple_swift_argument_parser",
    build_file = "swift-argument-parser/BUILD",
    sha256 = "44782ba7180f924f72661b8f457c268929ccd20441eac17301f18eff3b91ce0c",
    strip_prefix = "swift-argument-parser-1.2.2",
    url = "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.2.2.tar.gz",
)

http_archive(
    name = "com_github_kylef_pathkit",
    build_file = "pathkit/BUILD",
    strip_prefix = "pathkit-1.0.1",
    url = "https://github.com/kylef/PathKit/archive/refs/tags/1.0.1.tar.gz",
)

http_archive(
    name = "com_github_stencilproject_stencil",
    build_file = "stencil/BUILD",
    sha256 = "7e1d7b72cd07af0b31d8db6671540c357005d18f30c077f2dff0f84030995010",
    strip_prefix = "Stencil-0.15.1",
    url = "https://github.com/stencilproject/Stencil/archive/refs/tags/0.15.1.tar.gz",
)

http_archive(
    name = "com_github_jpsim_yams",
    sha256 = "16f0d7e4aecdd241c715ba7fa9a669b0655b076c424e05c6b6a7ea2267f9b3dd",
    strip_prefix = "Yams-5.0.5",
    url = "https://github.com/jpsim/Yams/archive/refs/tags/5.0.5.tar.gz",
)

http_archive(
    name = "com_github_pointfreeco_swift_snapshot_testing",
    build_file = "swift-snapshot-testing/BUILD",
    sha256 = "1958ec401eab4fd9c9e659f85641fa29a1d38d2fd6d5cc733e411fabf5324cfa",
    strip_prefix = "swift-snapshot-testing-1.11.0",
    url = "https://github.com/pointfreeco/swift-snapshot-testing/archive/refs/tags/1.11.0.tar.gz",
)

http_archive(
    name = "com_github_bazel_swift_private_repository",
    strip_prefix = "bazel-swift-private-repository-9f5f94a816618498c4f5bdae56b6ef2ce754ed61",
    url = "https://github.com/cwybro/bazel-swift-private-repository/archive/9f5f94a816618498c4f5bdae56b6ef2ce754ed61.zip",
)

http_archive(
    name = "com_github_apple_swift_cmark",
    build_file = "com_github_apple_swift_cmark/BUILD",
    sha256 = "f22968ffca65bf23c888b48a3dffe16d01bd3a4fc7b37832ffa3a9ad729bcc5e",
    strip_prefix = "swift-cmark-0.2.0",
    url = "https://github.com/apple/swift-cmark/archive/refs/tags/0.2.0.tar.gz",
)

http_archive(
    name = "com_github_apple_swift_markdown",
    build_file = "com_github_apple_swift_markdown/BUILD",
    sha256 = "0648c94b8ed5412591d48aee69a22a853062751b219d29426c8c4616b587f1aa",
    strip_prefix = "swift-markdown-0.2.0",
    url = "https://github.com/apple/swift-markdown/archive/refs/tags/0.2.0.tar.gz",
)

http_archive(
    name = "com_github_apple_swift_syntax",
    sha256 = "1cddda9f7d249612e3d75d4caa8fd9534c0621b8a890a7d7524a4689bce644f1",
    strip_prefix = "swift-syntax-509.0.0",
    url = "https://github.com/apple/swift-syntax/archive/refs/tags/509.0.0.tar.gz",
)

http_archive(
    name = "com_github_apple_swift_format",
    build_file = "com_github_apple_swift_format/BUILD",
    sha256 = "3041b470f6de7c156cf5898bc59645073c29def8dea66f9f356681163cae371e",
    strip_prefix = "swift-format-509.0.0",
    url = "https://github.com/apple/swift-format/archive/refs/tags/509.0.0.tar.gz",
)
