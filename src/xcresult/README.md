# XCResult Exploration

- [WIP] [Generated `.xcresult` parsing models](XCResultCommands/Sources/GenerateCommand.swift)
    - [x] Generate models from `xcrun xcresulttool formatDescription` & vend to consumers via `XCResultTypes_Generated` `swift_library`.
    - [x] Consume `XCResultTypes_Generated` to [decode partial `.xcresult` contents](XCResultParser/Sources/RootCommand.swift).
    - [x] Add [`TypeOverrides`](XCResultCommands/Sources/Models/TypeOverrides.swift) to override `xcrun xcresulttool formationDescription get` types, allowing specific subclasses to be used over the lowest-level base classes.
    - [ ] Resolve heterogeneous decoding of types (e.g. `ActionTestSummaryGroup` > `ActionTestMetadata`) -- currently the superclass is used (e.g. `ActionTestSummaryIdentifiableObject`)
        - Strategy 1: Custom switch-based decoders for types that utilize super/subclassing
        - Strategy 2: Create a middleware type system to convert XCResult into, to make the API nicer to work with (and more like a standard decoding setup) (e.g. `XCResult as JSON > Middleware Type > XCResult as Swift`)
            - Heterogeneous arrays in the `XCResult as JSON` layer could be flattened into homogeneous arrays in the `Middleware Type`, then a specific subclass can easily be used for decoding to transition into the `XCResult as Swift` layer
                - e.g. `tests: ActionTestSummaryIdentifiableObject` could be flattened to:
                    - `action_test_summary_groups: ActionTestSummaryGroup` (with a reference to the parent `ActionTestSummaryGroup` / `ActionTestableSummary`)
                    - `action_test_metadatas: ActionTestMetadata` (with a reference to the parent `ActionTestSummaryGroup`)
