load(
    "//:repositories.bzl",
    "toolchain_dependencies",
)

def _non_module_dependencies_impl(_ctx):
    toolchain_dependencies()

non_module_dependencies = module_extension(
    implementation = _non_module_dependencies_impl,
)
