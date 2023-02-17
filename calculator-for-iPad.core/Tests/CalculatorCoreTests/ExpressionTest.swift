import XCTest
@testable import CalculatorCore

public final class ExpressionTest: XCTestCase {
    public func testExecute() {
        var tokens: [Token] = [
            createFraction(1, 2),
            createFraction(1, 3),
            createFraction(1, 6),
            NativeBinaryOperator.add,
            NativeBinaryOperator.add,
        ]

        var expression = Expression(rawExpression: [""], tokens: tokens)
        var result = expression.execute()

        XCTAssertEqual(result.toDisplayString(), "1")

        tokens =  [
            createFraction(1, 1),
            createFraction(0, 1),
            NativeBinaryOperator.divide
        ]

        expression = Expression(rawExpression: [""], tokens: tokens)
        result = expression.execute()

        XCTAssertEqual(result.toDisplayString(), "")

        tokens =  [
            RealNumber(val: Decimal(1)),
            RealNumber(val: Decimal(0)),
            NativeBinaryOperator.divide
        ]

        expression = Expression(rawExpression: [""], tokens: tokens)
        result = expression.execute()

        XCTAssertEqual(result.toDisplayString(), "")

        tokens = [
            createFraction(4, 9),
            createFraction(1, 2),
            NativeBinaryOperator.pow
        ]
        
        expression = Expression(rawExpression: [""], tokens: tokens)
        result = expression.execute()

        XCTAssertEqual(result.toDisplayString(), "2/3")

        tokens = [
            createFraction(4, 9),
            NativeUnaryOperator.sqrt
        ]
        
        expression = Expression(rawExpression: [""], tokens: tokens)
        result = expression.execute()

        XCTAssertEqual(result.toDisplayString(), "2/3")
    }

    private func createFraction(_ numerator: Int, _ denominator: Int) -> Fraction {
        return Fraction(numerator: numerator, denominator: denominator)!
    }
}
