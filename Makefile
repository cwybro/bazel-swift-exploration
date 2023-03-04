.PHONY project_bep:
project_bep:
	bazelisk run //src/bep:project && open src/bep/project.xcodeproj

.PHONY bes_server:
bes_server:
	bazelisk run //src/bep/BESServer:publish_build_event_server

.PHONY build_bes:
build_bes: target ?= placeholder
build_bes:
	bazelisk build $(target) --config=bes_server

.PHONY xcresultparser_demo:
xcresultparser_demo:
	bazelisk test //src/bep/Fixtures:ExampleTests --config=bep_fixture && \
	XCRESULT_PATH=$$(bazelisk run //src/bep/BEPCommands:bep -- extract-xcresult --bep-path=/tmp/bazel/bep) && \
	bazelisk run //src/xcresult/XCResultParser:xcresultparser -- --xcresult-path=$$XCRESULT_PATH
