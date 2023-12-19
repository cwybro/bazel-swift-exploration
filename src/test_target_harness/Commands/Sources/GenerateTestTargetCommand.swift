import ArgumentParser
import Foundation
import Stencil

internal struct GenerateTestTargetCommand: ParsableCommand {

    internal static let configuration: CommandConfiguration = .init(
        commandName: "generate-test-target",
        abstract: "A tool for generating Swift test target source code.")

    @Option(name: .long, help: "Name of the test class to generate.")
    internal var testClassName: String

    @Option(name: .long, help: "Number of test cases to generate.")
    internal var testCaseCount: Int

    internal func run() throws {
        let rendered: String = try render(
            context: [
                "test_class_name": testClassName,
                "test_method_iterations": Array(0..<testCaseCount)
            ]
        )
        print(rendered)
    }

    private func render(context: [String: Any]) throws -> String {
        let template: String = """
            // GENERATED FILE - DO NOT EDIT

            import XCTest

            class {{ test_class_name }}: XCTestCase {

                {% for index in test_method_iterations %}
                func test_{{ index }}() {
                    XCTAssertTrue(true)
                }
                {% endfor %}
            }
            """
        return try Environment().renderTemplate(
            string: template,
            context :context)
    }
}
