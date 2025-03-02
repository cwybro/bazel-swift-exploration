internal struct TestInitBody: Codable {

    internal struct Initializer: Codable {

        internal struct Parameter: Codable {
            internal let name: String
            internal let value: String
        }

        internal let typeName: String
        internal let parameters: [Parameter]
    }

    internal let initializers: [Initializer]
}
