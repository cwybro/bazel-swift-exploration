// [CW] 3/4/23 - Allows the output of 'xcrun xcresulttool formationDescription get' to be overridden. By replacing
// types in 'formationDescription', a type other than the one provided by the tool can be used in code-generated models.
// This is useful for types that are limited by their supertype, which would otherwise prevent them from decoding
// to a more specific subclass.
struct TypeOverrides: Codable {

    struct Override: Codable {

        struct PropertyOverride: Codable {
            let name: String
            let generatedType: String
            let overrideType: String
        }

        let `type`: String
        let properties: [PropertyOverride]

        func propertyOverride(for propertyName: String) -> PropertyOverride? {
            properties.first {
                $0.name == propertyName
            }
        }

        func overrideType(propertyName: String, generatedType: String) -> String? {
            properties.first {
                $0.name == propertyName
                    && $0.generatedType == generatedType
            }?.overrideType
        }
    }

    let overrides: [Override]

    func override(typeName: String) -> Override? {
        overrides.first {
            $0.`type` == typeName
        }
    }
}
