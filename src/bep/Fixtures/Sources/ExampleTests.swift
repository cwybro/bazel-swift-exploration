import XCTest

class ExampleTests: XCTestCase {

    func testFlaky() throws {
        if try XCTUnwrap([false, true].randomElement()) == true {
            XCTAssertTrue(true)
        } else {
            XCTFail("Flaky")
        }
    }
}
