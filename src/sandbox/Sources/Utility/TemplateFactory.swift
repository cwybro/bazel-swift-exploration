internal protocol TemplateFactory {

    func makeTestFileTemplate() -> String
    func makeAssertMocksBodyTemplate() -> String
    func makeTestInitBodyTemplate() -> String
    func makeSetUpBodyTemplate() -> String
    func makeTearDownBodyTemplate() -> String
    func makeFailTestBodyTemplate() -> String
    func makeSuccessTestBodyTemplate() -> String
}

internal final class TemplateFactoryImp: TemplateFactory {

    internal func makeTestFileTemplate() -> String {
        """
        {%if header%}{{ header }}{% endif %}
        {% for import in imports %}
        {% if import.testable %}@testable {% endif %}import {{ import.value }}{% endfor %}

        internal final class {{ testClass.name }}: {{ testClass.subclass }} {
            {% for property in testClass.properties %}
            {% if property.var %}var{% else %}let{% endif%} {{ property.name }}: {{ property.type }}{% endfor %}
            {% for function in testClass.functions %}
            {% if function.signature.visibility %}{{ function.signature.visibility }} {% endif %}{% if function.signature.override %}override {% endif %}func {{ function.signature.name }}({% if function.signature.inputs %}{% function_loop: for input in function.signature.inputs %}
                {{ input.name }}: {{ input.type }}{% if input.defaultValue %} = {{ input.defaultValue}}{% endif %}{% if not forloop.function_loop.last %},{% endif %}{% endfor %}
            ){% else %}){% endif %}{% if function.signature.throws %} throws{% endif %}{% if function.signature.returnType %} -> {{ function.signature.returnType }}{% endif %} {
                {{ function.body|indent:8," ",false }}
            }
            {% endfor %}
        }
        """
    }

    internal func makeAssertMocksBodyTemplate() -> String {
        """
        {% for dependencyName in dependencyNames %}assertSnapshot(
            matching: {{ dependencyName }},
            as: .dump,
            testName: testName
        )
        {% endfor %}
        """
    }

    internal func makeTestInitBodyTemplate() -> String {
        """
        {% for initializer in initializers %}XCTAssertNotNil(
            {{ initializer.typeName }}({% if initializer.parameters %}{% parameter_loop: for parameter in initializer.parameters %}
                {{ parameter.name}}: {{ parameter.value }}{% if not forloop.parameter_loop.last %},{% endif%}{% endfor %}
            ){% else %}){% endif %}
        )
        {% endfor %}
        """
    }

    internal func makeSetUpBodyTemplate() -> String {
        """
        super.setup(){% for property in properties %}
        {{ property.name }} = .init({% if property.initializerParameters %}{% for initializerParameter in property.initializerParameters %}
            {{ initializerParameter.name }}: {{ initializerParameter.value }}{% if not forloop.last %},{% endif %}{% endfor %}
        ){% else %}){% endif %}{% endfor %}
        """
    }

    internal func makeTearDownBodyTemplate() -> String {
        """
        {% for property in properties %}{{ property.name }} = nil
        {% endfor %}super.tearDown()
        """
    }

    internal func makeFailTestBodyTemplate() -> String {
        """
        // GIVEN
        struct Error: Swift.Error {}
        {{ failingDependency.name }}.{{ failingDependency.methodName }} = { {% if failingDependency.methodParameterCount > 0 %}{% for i in 1...failingDependency.methodParameterCount %}_{% if forloop.last %} in{% else %}, {% endif %}{% endfor %}{% endif %}
            throw Error()
        }

        // WHEN
        XCTAssertThrowsError(
            {% if testBodySubject.throws %}try {% endif %}{{ testBodySubject.name }}.{{ testBodySubject.methodName }}({% if not testBodySubject.parameters %}){% else %}{% for parameter in testBodySubject.parameters %}
                {{ parameter.name }}: {{ parameter.value }}{% if not forloop.last %},{% endif %}{% endfor %}
            ){% endif %}
        ) {
            XCTAssertTrue($0 is Error, "Invalid error: \\($0)")
        }

        // THEN
        assertMocks()
        """
    }

    internal func makeSuccessTestBodyTemplate() -> String {
        """
        // WHEN
        {% if throws %}try {% endif %}{{ name }}.{{ methodName }}({% if not parameters %}){% else %}{% for parameter in parameters %}
            {{ parameter.name }}: {{ parameter.value }}{% if not forloop.last %},{% endif %}{% endfor %}
        ){% endif %}

        // THEN
        assertMocks()
        """
    }
}
