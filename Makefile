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

# [CW] 3/14/23 - This demo can also be invoked with the 'ExampleTests_ios_unit_test' target:
# e.g. 'make test_undeclared_outputs_demo target=ExampleTests_ios_unit_test'
.PHONY test_undeclared_outputs_demo:
test_undeclared_outputs_demo: target ?= ExampleTests_swift_test
test_undeclared_outputs_demo:
	bazelisk test //src/test_undeclared_outputs/Example:$(target) -t- --config=test_undeclared_outputs && \
	git apply src/test_undeclared_outputs/Patches/ExampleTests_isRecording.patch && \
	bazelisk test //src/test_undeclared_outputs/Example:$(target) -t- --config=test_undeclared_outputs || true && \
	bazelisk run //src/test_undeclared_outputs/Commands:test-undeclared-outputs -- extract-snapshots --bep-path=/tmp/bazel/bep --workspace-path=$$(pwd)

# [CW] 9/10/23 - This demo requires a GitHub Private Repository and GitHub Access Token to function as expected.
.PHONY credential_helper_demo:
credential_helper_demo: github_access_token ?= placeholder
credential_helper_demo:
	rm -rf demo && \
	mkdir -p demo && \
	bazelisk build //src/credential_helper/CredentialHelperCommands:credential-helper && \
	cp bazel-bin/src/credential_helper/CredentialHelperCommands/credential-helper demo && \
	bazelisk sync --only=com_github_bazel_swift_private_repository --config=credential_helper || true && \
	echo $(github_access_token) > demo/credentials.txt && \
	bazelisk sync --only=com_github_bazel_swift_private_repository --config=credential_helper && \
	rm -rf demo
