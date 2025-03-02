internal struct SourceFileManifest: Codable {

    internal struct TestableMethod: Codable {

        internal struct Parameter: Codable {
            internal let name: String
            internal let `type`: String
        }

        internal struct DependencyInvocation: Codable {
            internal let dependencyName: String
            internal let dependencyMethodName: String
            internal let dependencyMethodParameterCount: Int
            internal let dependencyMethodThrows: Bool
        }

        internal let name: String
        internal let parameters: [Parameter]
        internal let `throws`: Bool
        internal let returnType: String?
        internal let dependencyInvocations: [DependencyInvocation]
    }

    internal struct Dependency: Codable {

        internal struct Method: Codable {
            internal let name: String
            internal let parameterCount: Int
            internal let `throws`: Bool
            internal let returnType: String?
        }

        internal let name: String
        internal let typeName: String
        internal let methods: [Method]
    }

    internal let primarySourceTypeName: String
    internal let primarySourceTestName: String
    internal let testableMethods: [TestableMethod]
    internal let dependencies: [Dependency]
}
