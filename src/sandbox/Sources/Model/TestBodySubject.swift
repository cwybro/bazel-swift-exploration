internal struct TestBodySubject: Codable {

    internal struct Parameter: Codable {
        internal let name: String
        internal let value: String
    }

    internal let name: String
    internal let methodName: String
    internal let `throws`: Bool
    internal let parameters: [Parameter]
}
