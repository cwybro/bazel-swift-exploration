import Foundation

public enum XCResultTypes {

    public struct NestedValue: Codable {

        private enum CodingKeys: Swift.String, CodingKey {
            case name = "_name"
        }

        public let name: String
    }

    public struct ValueType<T: Codable>: Codable {

        private enum CodingKeys: Swift.String, CodingKey {
            case type = "_type"
            case value = "_value"
        }

        public let type: NestedValue
        public let value: T

        private static func castIfPossible<T, U>(value: () -> T?) throws -> U {
            guard
                let value: T = value(),
                let castedValue: U = value as? U
            else {
                let context = DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Deserialized \(Swift.type(of: T.self)) is not convertible to \(Swift.type(of: U.self))")
                throw DecodingError.typeMismatch(Swift.type(of: T.self), context)
            }
            return castedValue
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type = try container.decode(NestedValue.self, forKey: .type)
            let stringValue: Swift.String = try container.decode(Swift.String.self, forKey: .value)
            switch T.self {
                case is Swift.String.Type:
                    self.value = stringValue as! T
                case is Swift.Bool.Type:
                    self.value = try ValueType.castIfPossible {
                        Swift.Bool(stringValue)
                    }
                case is Swift.Double.Type:
                    self.value = try ValueType.castIfPossible {
                        Swift.Double(stringValue)
                    }
                case is Swift.Int.Type:
                    self.value = try ValueType.castIfPossible {
                        Swift.Int(stringValue)
                    }
                case is Foundation.Date.Type:
                    self.value = try ValueType.castIfPossible {
                        let dateFormatter: ISO8601DateFormatter = .init()
                        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                        return dateFormatter.date(from: stringValue)
                    }
                default:
                    fatalError("Unexpected value type: \(Swift.type(of: T.self))")
            }
        }
    }

    public struct ResultType: Codable {

        public let name: String
    }

    public struct SchemaSerializable: Codable {

        public let type: ResultType
        public let value: String
    }

    public class Array<T: Codable>: Codable {

        private enum CodingKeys: Swift.String, CodingKey {
            case values = "_values"
        }

        public let values: [T]

        required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.values = try container.decode([T].self, forKey: .values)
        }
    }
}
