func makeSourceFileManifest() -> SourceFileManifest {
    .init(
        primarySourceTypeName: "ExampleImp",
        primarySourceTestName: "ExampleTests",
        testableMethods: [
            SourceFileManifest.TestableMethod(
                name: "executeA",
                parameters: [
                    SourceFileManifest.TestableMethod.Parameter(
                        name: "inputA",
                        type: "String"
                    ),
                    SourceFileManifest.TestableMethod.Parameter(
                        name: "inputB",
                        type: "Int"
                    )
                ],
                throws: true,
                returnType: nil,
                dependencyInvocations: [
                    SourceFileManifest.TestableMethod.DependencyInvocation(
                        dependencyName: "dependencyA",
                        dependencyMethodName: "executeOne",
                        dependencyMethodParameterCount: 0,
                        dependencyMethodThrows: true
                    ),
                    SourceFileManifest.TestableMethod.DependencyInvocation(
                        dependencyName: "dependencyA",
                        dependencyMethodName: "executeTwo",
                        dependencyMethodParameterCount: 2,
                        dependencyMethodThrows: true
                    )
                ]
            ),
            SourceFileManifest.TestableMethod(
                name: "executeB",
                parameters: [
                    SourceFileManifest.TestableMethod.Parameter(
                        name: "inputB",
                        type: "Int"
                    )
                ],
                throws: false,
                returnType: "String",
                dependencyInvocations: []
            )
        ],
        dependencies: [
            SourceFileManifest.Dependency(
                name: "dependencyA",
                typeName: "DependencyA",
                methods: [
                    SourceFileManifest.Dependency.Method(
                        name: "executeOne",
                        parameterCount: 0,
                        throws: true,
                        returnType: nil
                    ),
                    SourceFileManifest.Dependency.Method(
                        name: "executeTwo",
                        parameterCount: 2,
                        throws: true,
                        returnType: nil
                    )
                ]
            ),
            SourceFileManifest.Dependency(
                name: "dependencyB",
                typeName: "DependencyB",
                methods: [
                    SourceFileManifest.Dependency.Method(
                        name: "executeThree",
                        parameterCount: 1,
                        throws: true,
                        returnType: "String"
                    ),
                    SourceFileManifest.Dependency.Method(
                        name: "executeFour",
                        parameterCount: 2,
                        throws: false,
                        returnType: nil
                    )
                ]
            )
        ]
    )
}

func makeTestFileContent(
    sourceFileManifest: SourceFileManifest
) throws -> TestFileContent {
    let setUpBody: SetUpBody = .init(
        properties: sourceFileManifest.dependencies.map { dependency in
            SetUpBody.Property(
                name: dependency.name,
                initializerParameters: []
            )
        } + [
            SetUpBody.Property(
                name: "subject",
                initializerParameters: sourceFileManifest.dependencies.map { dependency in
                    SetUpBody.Property.initializerParameter(
                        name: dependency.name,
                        value: dependency.name
                    )
                }
            )
        ]
    )
    return TestFileContent(
        header: nil,
        imports: [
            TestFileContent.Import(
                value: "XCTest",
                testable: false
            )
        ],
        testClass: TestFileContent.TestClass(
            name: sourceFileManifest.primarySourceTestName,
            subclass: "XCTestCase",
            properties: sourceFileManifest.dependencies.map { dependency in
                TestFileContent.TestClass.Property(
                    name: dependency.name,
                    type: "\(dependency.typeName)Mock!",
                    var: true
                )
            } + [
                TestFileContent.TestClass.Property(
                    name: "subject",
                    type: "\(sourceFileManifest.primarySourceTypeName)!",
                    var: true
                )
            ],
            functions: try [
                TestFileContent.TestClass.Function(
                    signature: TestFileContent.TestClass.Function.Signature(
                        name: "setUp",
                        visibility: nil,
                        override: true,
                        throws: false,
                        returnType: nil,
                        inputs: []
                    ),
                    body: try renderService.render(
                        template: templateFactory.makeSetUpBodyTemplate(),
                        context: try setUpBody.toDictionary()
                    )
                ),
                TestFileContent.TestClass.Function(
                    signature: TestFileContent.TestClass.Function.Signature(
                        name: "tearDown",
                        visibility: nil,
                        override: true,
                        throws: false,
                        returnType: nil,
                        inputs: []
                    ),
                    body: try renderService.render(
                        template: templateFactory.makeTearDownBodyTemplate(),
                        context: try setUpBody.toDictionary()
                    )
                ),
                TestFileContent.TestClass.Function(
                    signature: TestFileContent.TestClass.Function.Signature(
                        name: "assertMocks",
                        visibility: "private",
                        override: false,
                        throws: false,
                        returnType: nil,
                        inputs: [
                            TestFileContent.TestClass.Function.Signature.Input(
                                name: "testName",
                                type: "String",
                                defaultValue: "#method"
                            )
                        ]
                    ),
                    body: try renderService.render(
                        template: templateFactory.makeAssertMocksBodyTemplate(),
                        context: try AssertMocksBody(
                            dependencyNames: sourceFileManifest.dependencies.map(\.name)
                        ).toDictionary()
                    )
                ),
                TestFileContent.TestClass.Function(
                    signature: TestFileContent.TestClass.Function.Signature(
                        name: "test__init",
                        visibility: nil,
                        override: false,
                        throws: false,
                        returnType: nil,
                        inputs: []
                    ),
                    body: try renderService.render(
                        template: templateFactory.makeTestInitBodyTemplate(),
                        context: try TestInitBody(
                            initializers: [
                                TestInitBody.Initializer(
                                    typeName: sourceFileManifest.primarySourceTypeName,
                                    parameters: sourceFileManifest.dependencies.map { dependency in
                                        TestInitBody.Initializer.Parameter(
                                            name: dependency.name,
                                            value: dependency.name
                                        )
                                    }
                                ),
                                TestInitBody.Initializer(
                                    typeName: sourceFileManifest.primarySourceTypeName,
                                    parameters: []
                                )
                            ]
                        ).toDictionary()
                    )
                )
            ] + sourceFileManifest.testableMethods.flatMap { testableMethod in
                let failingTestCases: [TestFileContent.TestClass.Function] = try testableMethod.dependencyInvocations
                    .filter(\.dependencyMethodThrows)
                    .map { dependencyInvocation in
                        TestFileContent.TestClass.Function(
                            signature: TestFileContent.TestClass.Function.Signature(
                                name: "test__\(testableMethod.name)__\(dependencyInvocation.dependencyName)_\(dependencyInvocation.dependencyMethodName)__failed",
                                visibility: nil,
                                override: false,
                                throws: false,
                                returnType: nil,
                                inputs: []
                            ),
                            body: try renderService.render(
                                template: templateFactory.makeFailTestBodyTemplate(),
                                context: try FailTestBody(
                                    failingDependency: FailTestBody.FailingDependency(
                                        name: dependencyInvocation.dependencyName,
                                        methodName: "\(dependencyInvocation.dependencyMethodName)Handler",
                                        methodParameterCount: dependencyInvocation.dependencyMethodParameterCount
                                    ),
                                    testBodySubject: TestBodySubject(
                                        name: "subject",
                                        methodName: testableMethod.name,
                                        throws: testableMethod.throws,
                                        parameters: testableMethod.parameters.map { parameter in
                                            TestBodySubject.Parameter(
                                                name: parameter.name,
                                                value: "\"TODO\""
                                            )
                                        }
                                    )
                                ).toDictionary()
                            )
                        )
                    }
                return failingTestCases + [
                    TestFileContent.TestClass.Function(
                        signature: TestFileContent.TestClass.Function.Signature(
                            name: "test__\(testableMethod.name)__success",
                            visibility: nil,
                            override: false,
                            throws: testableMethod.throws,
                            returnType: nil,
                            inputs: []
                        ),
                        body: try renderService.render(
                            template: templateFactory.makeSuccessTestBodyTemplate(),
                            context: try TestBodySubject(
                                name: "subject",
                                methodName: testableMethod.name,
                                throws: testableMethod.throws,
                                parameters: testableMethod.parameters.map { parameter in
                                    TestBodySubject.Parameter(
                                        name: parameter.name,
                                        value: "\"TODO\""
                                    )
                                }
                            ).toDictionary()
                        )
                    )
                ]
            }
        )
    )
}

let renderService: RenderService = RenderServiceImp()
let templateFactory: TemplateFactory = TemplateFactoryImp()

print(
    try renderService.render(
        template: templateFactory.makeTestFileTemplate(),
        context: try makeTestFileContent(
            sourceFileManifest: makeSourceFileManifest()
        ).toDictionary()
    )
)
