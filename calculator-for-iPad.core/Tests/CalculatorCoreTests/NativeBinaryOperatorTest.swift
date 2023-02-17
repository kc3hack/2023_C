import XCTest
@testable import CalculatorCore

public final class NativeBinaryOperatorTest: XCTestCase {
    func testIdentifier() throws {
        var opr = NativeBinaryOperator.add
        XCTAssertEqual(opr.identifier, "+")

        opr = NativeBinaryOperator.substract
        XCTAssertEqual(opr.identifier, "-")

        opr = NativeBinaryOperator.multiply
        XCTAssertEqual(opr.identifier, "*")

        opr = NativeBinaryOperator.divide
        XCTAssertEqual(opr.identifier, "/")

        opr = NativeBinaryOperator.modulus
        XCTAssertEqual(opr.identifier, "mod")

        opr = NativeBinaryOperator.pow
        XCTAssertEqual(opr.identifier, "^")
    }

    func testExecute() throws {
        let arguments: [(String, NativeBinaryOperator)] = [
            ("left add right", .add),
            ("left substract right", .substract),
            ("left multiply right", .multiply),
            ("left divide right", .divide),
            ("left modulus right", .modulus),
            ("left pow right", .pow),
        ]

        for arg in arguments {
            do {
                try execute(expectedString: arg.0, opr: arg.1)
            }
        }
    }

    func execute(expectedString: String, opr: NativeBinaryOperator) throws {
        let right = NumberMock(info: "right")
        let left = NumberMock(info: "left")
        let expectedType = String(describing: type(of: right))

        let result = opr.execute(left: left, right: right)
        XCTAssertEqual(String(describing: type(of: result)), expectedType)
        if let mock = result as? NumberMock {
            XCTAssertEqual(mock.info, expectedString)
        }
    }

    func testParse() throws {
        var token: Token? = NativeBinaryOperator.parse("+")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "+")
            XCTAssertEqual(opr, NativeBinaryOperator.add)
        }

        token = NativeBinaryOperator.parse("-")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "-")
            XCTAssertEqual(opr, NativeBinaryOperator.substract)
        }

        token = NativeBinaryOperator.parse("*")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "*")
            XCTAssertEqual(opr, NativeBinaryOperator.multiply)
        }

        token = NativeBinaryOperator.parse("/")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "/")
            XCTAssertEqual(opr, NativeBinaryOperator.divide)
        }

        token = NativeBinaryOperator.parse("mod")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "mod")
            XCTAssertEqual(opr, NativeBinaryOperator.modulus)
        }

        token = NativeBinaryOperator.parse("^")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "^")
            XCTAssertEqual(opr, NativeBinaryOperator.pow)
        }

        token = NativeBinaryOperator.parse("")
        XCTAssertNil(token)

        token = NativeBinaryOperator.parse("sin")
        XCTAssertNil(token)

        token = NativeBinaryOperator.parse("aaa")
        XCTAssertNil(token)
    }
}
