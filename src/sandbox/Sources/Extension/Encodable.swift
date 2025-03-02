import Foundation

extension Encodable {

    // [CW] 2/25/23 - Adapted from: https://stackoverflow.com/a/52924356
    func toDictionary() throws -> [String: Any] {
        let data: Data = try JSONEncoder().encode(self)
        let object: Any = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(
                codingPath: [],
                debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
