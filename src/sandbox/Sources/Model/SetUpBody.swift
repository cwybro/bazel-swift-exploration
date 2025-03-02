internal struct SetUpBody: Codable {

    internal struct Property: Codable {

        internal struct initializerParameter: Codable {
            internal let name: String
            internal let value: String
        }

        internal let name: String
        internal let initializerParameters: [initializerParameter]
    }

    internal let properties: [Property]
}
