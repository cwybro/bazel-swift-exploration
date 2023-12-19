load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

http_archive(
    name = "rules_xcodeproj",
    sha256 = "f5c1f4bea9f00732ef9d54d333d9819d574de7020dbd9d081074232b93c10b2c",
    url = "https://github.com/MobileNativeFoundation/rules_xcodeproj/releases/download/1.13.0/release.tar.gz",
)

load(
    "@rules_xcodeproj//xcodeproj:repositories.bzl",
    "xcodeproj_rules_dependencies",
)

xcodeproj_rules_dependencies()

load("@bazel_features//:deps.bzl", "bazel_features_deps")

bazel_features_deps()

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
