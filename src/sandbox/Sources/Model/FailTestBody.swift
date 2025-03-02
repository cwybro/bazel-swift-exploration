internal struct FailTestBody: Codable {

    internal struct FailingDependency: Codable {
        internal let name: String
        internal let methodName: String
        internal let methodParameterCount: Int
    }

    internal let failingDependency: FailingDependency
    internal let testBodySubject: TestBodySubject
}
