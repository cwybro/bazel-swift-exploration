# Test Undeclared Outputs Exploration

This project explores the use of `TEST_UNDECLARED_OUTPUTS_DIR` and `RUNFILES_DIR`. Specifically, it demonstrates the utility of these ENV values in building a hermetic snapshot recording / validation workflow.

## Infrastructure

- [AssertSnapshot](TestKit/Sources/AssertSnapshot.swift)
    - Utility for recording / validating snapshot tests using [pointfreeco/swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)
    - [`TEST_UNDECLARED_OUTPUTS_DIR`-based](TestKit/Sources/AssertSnapshot.swift#L68) path building for recording test runs (e.g. developer updates local snapshot)
    - [`RUNFILES_DIR`-based](TestKit/Sources/AssertSnapshot.swift#L70) path building for non-recording test runs (e.g. CI runs snapshot test)
- [ExtractSnapshotsCommand](Commands/Sources/ExtractSnapshotsCommand.swift)
    - Command for extracting recorded snapshot artifacts from `TEST_UNDECLARED_OUTPUTS_DIR` found in a Bazel BEP binary file

## Demo

A codified demonstration of this exploration can be executed via:

```
make test_undeclared_outputs_demo
```

This demonstration performs the following steps:
- Run tests with `isRecording = false` (to validate that they pass with the current snapshot)
- Apply git patch to influence snapshot output
- Run tests with `isRecording = true`
- Invoke `test-undeclared-outputs extract-snapshots` command to find newly recorded snapshot outputs in the BEP, and copy back to local repository
