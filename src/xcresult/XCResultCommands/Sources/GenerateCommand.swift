import ArgumentParser
import Foundation
import PathKit
import Stencil
import Yams

internal struct GenerateCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        commandName: "generate",
        abstract: "A tool for generating XCResult parsing types.")

    @Option(name: .long, help: "Path to 'xcrun xcresulttool formatDescription' JSON file.")
    internal var formatDescriptionJSONPath: String

    @Option(name: .long, help: "Path to YAML file containing overrides for generated types.")
    internal var typeOverridesPath: String?

    internal func run() throws {
        let fileData: Data = try Path(formatDescriptionJSONPath).read()
        let formatDescription: FormatDescription = try JSONDecoder().decode(FormatDescription.self, from: fileData)
        let typeOverrides: TypeOverrides = try makeTypeOverrides()
        let renderModel: RenderFormatDescription = .init(
            formatDescription: formatDescription,
            typeOverrides: typeOverrides)
        let rendered: String = try render(context: renderModel.toDictionary())
        print(rendered)
    }

    private func makeTypeOverrides() throws -> TypeOverrides {
        guard let typeOverridesPath: String = typeOverridesPath else {
            return TypeOverrides(overrides: [])
        }
        let fileData: Data = try Path(typeOverridesPath).read()
        return try YAMLDecoder().decode(TypeOverrides.self, from: fileData)
    }

    private func render(context: [String: Any]) throws -> String {
        let template: String = """
            // GENERATED FILE - DO NOT EDIT
            // name = {{ name }}
            // version = {{ version.major }}.{{ version.minor }}

            import Foundation

            extension {{ typeExtension }} {
                {% for type in types %}

                {% if type.isBaseClass %}open {% else %}public {% endif %}class {{ type.type.name }}: {% if type.type.supertype %}{{ type.type.supertype }}{% else %}Codable{% endif %} {
                    {% for property in type.properties %}
                    public let {{ property.propertyName }}: {{ property.finalType }}{% endfor %}
                    {% if type.properties %}
                    enum CodingKeys: Swift.String, CodingKey {
                        {% for property in type.properties %}
                        case {{ property.propertyName }}{% endfor %}
                    }

                    required public init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self){% for property in type.properties %}
                        {{ property.propertyName }} = try container.decode{% if property.isOptional %}IfPresent{% endif %}({{ property.finalTypeNonOptional }}.self, forKey: .{{ property.propertyName }}){% endfor %}{% if type.type.supertype %}
                        try super.init(from: decoder){% endif %}
                    }{% endif %}
                }{% endfor %}
            }
            """
        return try Environment().renderTemplate(
            string: template,
            context :context)
    }
}
