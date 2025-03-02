internal struct TestFileContent: Codable {

    internal struct Import: Codable {
        internal let value: String
        internal let testable: Bool
    }

    internal struct TestClass: Codable {

        internal struct Property: Codable {
            internal let name: String
            internal let `type`: String
            internal let `var`: Bool
        }

        internal struct Function: Codable {

            internal struct Signature: Codable {

                internal struct Input: Codable {
                    internal let name: String
                    internal let `type`: String
                    internal let defaultValue: String?
                }

                internal let name: String
                internal let visibility: String?
                internal let `override`: Bool
                internal let `throws`: Bool
                internal let returnType: String?
                internal let inputs: [Input]
            }

            internal let signature: Signature
            internal let body: String
        }

        internal let name: String
        internal let subclass: String
        internal let properties: [Property]
        internal let functions: [Function]
    }

    internal let header: String?
    internal let imports: [Import]
    internal let testClass: TestClass
}
