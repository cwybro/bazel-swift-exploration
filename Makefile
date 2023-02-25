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
