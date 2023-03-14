import Foundation

// [CW] 2/25/23 - Enhanced model of the Codable version ('FormatDescription'), containing extra fields that
// reduce the complexity of the stencil render template.
internal struct RenderFormatDescription: Codable {

    internal struct RenderFormatType: Codable {

        internal struct RenderProperty: Codable {

            let propertyName: String
            let isOptional: Bool
            let finalType: String
            let finalTypeNonOptional: String

            init(
                property: FormatDescription.FormatType.Property,
                optionalOverride: Bool,
                typeExtension: String,
                override: TypeOverrides.Override?
            ) {
                self.propertyName = property.name
                let isOptional: Bool = property.isOptional || optionalOverride
                self.isOptional = isOptional
                let baseType: String = {
                    let propertyType: String = property.wrappedType ?? property.type
                    if let overrideType: String = override?.overrideType(
                        propertyName: property.name,
                        generatedType: propertyType
                    ) {
                        return overrideType
                    } else {
                        return propertyType
                    }
                }()
                let nonPrefixedFinalType: String = {
                    if let wrappedType: String = property.wrappedType {
                        switch property.type {
                            case "Array":
                                return "Array<\(baseType)>"
                            case "Optional":
                                if !property.isOptional {
                                    fatalError("Property type is 'Optional' but 'isOptional' is false: \(property.name)")
                                }
                                return baseType
                            default:
                                fatalError("Unexpected wrappedType: \(wrappedType)")
                        }
                    } else {
                        return baseType
                    }
                }()
                let wrappedNonPrefixedFinalType: String = {
                    guard [
                        "String",
                        "Bool",
                        "Double",
                        "Int",
                        "Date"
                    ].contains(baseType) else {
                        return nonPrefixedFinalType
                    }
                    return "ValueType<\(nonPrefixedFinalType)>"
                }()
                let possiblyOptionalNonPrefixedFinalType: String = {
                    isOptional ? "\(wrappedNonPrefixedFinalType)?" : wrappedNonPrefixedFinalType
                }()
                self.finalType = "\(typeExtension).\(possiblyOptionalNonPrefixedFinalType)"
                self.finalTypeNonOptional = (isOptional && self.finalType.hasSuffix("?"))
                    ? String(self.finalType.dropLast())
                    : self.finalType
            }
        }

        let type: FormatDescription.FormatType.`Type`
        let kind: FormatDescription.FormatType.Kind
        let properties: [RenderProperty]?
        let isBaseClass: Bool

        init(
            formatType: FormatDescription.FormatType,
            isBaseClass: Bool,
            optionalOverride: Bool,
            typeExtension: String,
            typeOverrides: TypeOverrides
        ) {
            self.type = formatType.type
            self.kind = formatType.kind
            self.properties = formatType.properties?.map {
                RenderProperty(
                    property: $0,
                    optionalOverride: optionalOverride,
                    typeExtension: typeExtension,
                    override: typeOverrides.override(typeName: formatType.type.name))
            }
            self.isBaseClass = isBaseClass
        }
    }

    let name: String
    let version: FormatDescription.Version
    let types: [RenderFormatType]
    let typeExtension: String

    // [CW] 2/26/23 - 'optionalOverride' is used to treat properties that are declared non-optional (per the
    // raw 'xcrun xcresulttool formatDescription get' output) as optional. This is required because in practice,
    // some non-optional types may not exist in the XCResult file (e.g. 'ResultIssueSummaries.analyzerWarningSummaries').
    //
    // [CW] 2/26/23 - 'typeExtension' is used to inject the enum type that will contain all models (handwritten and
    // generated). This enum will avoid polluting the global type namespace when a consumer imports the 'XCResultTypes_Generated'
    // module, particularly for conflicting 'Swift.*' / 'Foundation.*' types.
    init(
        formatDescription: FormatDescription,
        optionalOverride: Bool = true,
        typeExtension: String = "XCResultTypes",
        typeOverrides: TypeOverrides
    ) {
        self.name = formatDescription.name
        self.version = formatDescription.version
        let baseClasses: Set<String> = Set(formatDescription.types.map(\.type).compactMap(\.supertype))
        self.types = formatDescription.types
            .filter {
                $0.kind == .object
            }
            .map {
                RenderFormatType(
                    formatType: $0,
                    isBaseClass: baseClasses.contains($0.type.name),
                    optionalOverride: optionalOverride,
                    typeExtension: typeExtension,
                    typeOverrides: typeOverrides)
            }
        self.typeExtension = typeExtension
    }
}
