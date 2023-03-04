import Foundation

internal struct FormatDescription: Codable {

    internal struct Version: Codable {
        let major: Int
        let minor: Int
    }

    internal struct FormatType: Codable {

        internal struct `Type`: Codable {
            let name: String
            let supertype: String?
        }

        internal struct Property: Codable {
            let isOptional: Bool
            let isInternal: Bool
            let wrappedType: String?
            let name: String
            let type: String
        }

        internal enum Kind: String, Codable {
            case object, value, array
        }

        let type: Type
        let kind: Kind
        let properties: [Property]?
    }

    let name: String
    let version: Version
    let types: [FormatType]
}
