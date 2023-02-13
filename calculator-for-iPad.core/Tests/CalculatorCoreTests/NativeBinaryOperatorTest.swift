import XCTest
@testable import CalculatorCore

public final class NativeBinaryOperatorTest: XCTestCase {
    func testInit() throws {
        var opr = NativeBinaryOperator(.add)
        XCTAssertEqual(opr.identifier, "+")

        opr = NativeBinaryOperator(.substract)
        XCTAssertEqual(opr.identifier, "-")

        opr = NativeBinaryOperator(.multiply)
        XCTAssertEqual(opr.identifier, "*")

        opr = NativeBinaryOperator(.divide)
        XCTAssertEqual(opr.identifier, "/")

        opr = NativeBinaryOperator(.modulus)
        XCTAssertEqual(opr.identifier, "%")

        opr = NativeBinaryOperator(.power)
        XCTAssertEqual(opr.identifier, "^")
    }

    func testExecute() throws {
    }

    func testParse() throws {
        var token: Token? = NativeBinaryOperator.Parse("+")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "+")
            XCTAssertEqual(opr.operatorType, .add)
        }

        token = NativeBinaryOperator.Parse("-")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "-")
            XCTAssertEqual(opr.operatorType, .substract)
        }

        token = NativeBinaryOperator.Parse("*")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "*")
            XCTAssertEqual(opr.operatorType, .multiply)
        }

        token = NativeBinaryOperator.Parse("/")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "/")
            XCTAssertEqual(opr.operatorType, .divide)
        }

        token = NativeBinaryOperator.Parse("%")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "%")
            XCTAssertEqual(opr.operatorType, .modulus)
        }

        token = NativeBinaryOperator.Parse("^")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "^")
            XCTAssertEqual(opr.operatorType, .power)
        }

        token = NativeBinaryOperator.Parse("")
        XCTAssertNil(token)

        token = NativeBinaryOperator.Parse("sin")
        XCTAssertNil(token)

        token = NativeBinaryOperator.Parse("aaa")
        XCTAssertNil(token)
    }
}