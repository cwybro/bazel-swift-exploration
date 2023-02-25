load(
    "@com_github_buildbuddy_io_rules_xcodeproj//xcodeproj:defs.bzl",
    "xcodeproj",
)

xcodeproj(
    name = "project",
    project_name = "project",
    tags = ["manual"],
    top_level_targets = [
        "//src/bep/BEPCommands:bep",
        "//src/bep/BESServer:bes_server",
    ],
)
