import TestKit
import XCTest

class ExampleTests: XCTestCase {

    func testExample() throws {
        // GIVEN
        let subject: String = "subject"

        // THEN
        assertSnapshot(matching: subject, as: .lines)
    }
}
