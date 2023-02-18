import XCTest
@testable import CalculatorCore

public final class CalculatorServiceTest: XCTestCase {
    func testCalculate() throws {
        let arguments: [(String, String)] = [
            ("1+1*(6/2)", "4"),
            ("(3+1/3)*2", "20/3"),
            ("12/10+13/10", "5/2"),
            ("1.2+1.3", "5/2"),
            ("log10", "1"),
            ("√4", "2"),
            ("abs(4)", "4"),
            ("4mod3", "1"),
            ("3^2", "9"),
            ("e+e", "2e"),
            ("e^2", "e^2"),
            ("e^2+e^2", "2e^2"),
            ("0-4*π", "-4π"),
            ("π*3", "3π"),
            ("π*2-4*π", "-2π"),
            ("(π*2+5*π)/(π*4)", "7/4")
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