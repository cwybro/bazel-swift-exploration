load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

def _maybe(repo_rule, name, **kwargs):
    """Executes the given repository rule if it hasn't been executed already.

    Args:
    repo_rule: The repository rule to be executed (e.g., `http_archive`.)
    name: The name of the repository to be defined by the rule.
    **kwargs: Additional arguments passed directly to the repository rule.
    """
    if not native.existing_rule(name):
        repo_rule(name = name, **kwargs)

def toolchain_dependencies():
    _maybe(
        http_archive,
        name = "com_github_stencilproject_stencil",
        build_file = "//external/stencil:BUILD",
        sha256 = "7e1d7b72cd07af0b31d8db6671540c357005d18f30c077f2dff0f84030995010",
        strip_prefix = "Stencil-0.15.1",
        url = "https://github.com/stencilproject/Stencil/archive/refs/tags/0.15.1.tar.gz",
    )
    _maybe(
        http_archive,
        name = "com_github_pointfreeco_swift_snapshot_testing",
        build_file = "//external/swift-snapshot-testing:BUILD",
        sha256 = "1958ec401eab4fd9c9e659f85641fa29a1d38d2fd6d5cc733e411fabf5324cfa",
        strip_prefix = "swift-snapshot-testing-1.11.0",
        url = "https://github.com/pointfreeco/swift-snapshot-testing/archive/refs/tags/1.11.0.tar.gz",
    )
    _maybe(
        http_archive,
        name = "com_github_bazel_swift_private_repository",
        strip_prefix = "bazel-swift-private-repository-9f5f94a816618498c4f5bdae56b6ef2ce754ed61",
        url = "https://github.com/cwybro/bazel-swift-private-repository/archive/9f5f94a816618498c4f5bdae56b6ef2ce754ed61.zip",
    )
