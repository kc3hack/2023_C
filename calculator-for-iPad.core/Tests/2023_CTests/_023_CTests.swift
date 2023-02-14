import XCTest
@testable import _023_C

struct aaa{
    var a: Int
    var aa: Int
}


final class _023_CTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(_023_C().text, "Hello, World!")

        var num0: Number
        let num1: NumberReal = NumberReal(isExponents: true, val: 0.2)
        let num2: NumberReal = NumberReal(isExponents: true, val: 25)

        
        
        print("========================================")
        
        
        print(num1.arcsin(isExponents: true))
        print(num1.arccos(isExponents: true))
        print(num1.arctan(isExponents: true))

        
        print("========================================")
    }
}
