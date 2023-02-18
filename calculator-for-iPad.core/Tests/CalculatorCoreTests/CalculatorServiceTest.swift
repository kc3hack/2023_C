import XCTest
@testable import CalculatorCore

public final class CalculatorServiceTest: XCTestCase {
    func testCalculate() {
        let calculator = CalculatorService()
        var result = calculator.calculate(rawExpression: "1+1*(6/2)")
        XCTAssertEqual(result.toDisplayString(), "4")

        result = calculator.calculate(rawExpression: "(3+1/3)*2")
        XCTAssertEqual(result.toDisplayString(), "20/3")

        result = calculator.calculate(rawExpression: "12/10+13/10")
        XCTAssertEqual(result.toDisplayString(), "5/2")

        result = calculator.calculate(rawExpression: "1.2+1.3")
        XCTAssertEqual(result.toDisplayString(), "5/2")
    }
}