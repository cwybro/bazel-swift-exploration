cc_library(
    name = "cmark-gfm",
    srcs = glob(
        [
            "src/*",
        ],
        [
            "src/scanners.re",
            "src/libcmark-gfm.pc.in",
            "src/config.h.in",
            "src/CMakeLists.txt",
            "src/cmark-gfm_version.h.in",
            # [CW] 2/16/24 - Must be included, despite the configuration here:
            # https://github.com/apple/swift-cmark/blob/0.2.0/Package.swift#L56
            # "src/case_fold_switch.inc",
            # "src/entities.inc",
        ],
        allow_empty = False,
    ),
    hdrs = glob(
        [
            "src/include/*.h",
        ],
        allow_empty = False,
    ),
    includes = [
        "src/include",
    ],
    visibility = [
        "@com_github_apple_swift_markdown//:__pkg__",
    ],
)

cc_library(
    name = "cmark-gfm-extensions",
    srcs = glob(
        [
            "extensions/*",
        ],
        [
            "extensions/CMakeLists.txt",
            "extensions/ext_scanners.re",
        ],
        allow_empty = False,
    ),
    hdrs = glob(
        [
            "extensions/include/*.h",
        ],
        allow_empty = False,
    ),
    includes = [
        "extensions/include",
    ],
    tags = [
        "swift_module=cmark_gfm_extensions",
    ],
    visibility = [
        "@com_github_apple_swift_markdown//:__pkg__",
    ],
    deps = [
        ":cmark-gfm",
    ],
)
