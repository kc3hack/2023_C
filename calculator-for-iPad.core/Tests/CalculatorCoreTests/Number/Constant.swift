import XCTest
@testable import CalculatorCore

public final class ConstantTest: XCTestCase {
    public func testAdd() throws {
        var result = Constant.e.add(left: Constant.e)
        
        XCTAssertEqual(result.toDisplayString(), "2e")
    }
    
    public func testAdd() throws {
        var result = Constant.e.add(left: Constant.e)
        
        XCTAssertEqual(result.toDisplayString(), "2e")
    }
}