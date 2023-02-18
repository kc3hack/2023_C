import XCTest
@testable import CalculatorCore

public final class CalculatorServiceTest: XCTestCase {
    func testCalculate() throws {
        let arguments: [(String, String)] = [
            ("1+1*(6/2)", "4"),
            ("(3+1/3)*2", "20/3"),
            ("12/10+13/10", "5/2"),
            ("1.2+1.3", "5/2"),
        ]
        
        do {
            for arg in arguments {
                try calculate(expected: arg.1, rawExpression: arg.0)
            }
        }
    }

    func calculate(expected: String, rawExpression: String) throws {
        let calculator = CalculatorService()
        let result = calculator.calculate(rawExpression: rawExpression)

        XCTAssertEqual(result.toDisplayString(), expected)
    }
}