import XCTest
@testable import CalculatorCore

struct aaa{
    var a: Int
    var aa: Int
}


final class _023_CTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var temp = _023_C();
        XCTAssertEqual(temp.text, "Hello, World!")
    }
}
