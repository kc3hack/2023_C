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
        XCTAssertEqual(opr.identifier, "%")

        opr = NativeBinaryOperator.pow
        XCTAssertEqual(opr.identifier, "^")
    }

    func testExecute() throws {
        let arguments: [(String, NativeBinaryOperator, Bool)] = [
            ("left add right isExponents:true", .add, true),
            ("left add right isExponents:false", .add, false),
            ("left substract right isExponents:true", .substract, true),
            ("left substract right isExponents:false", .substract, false),
            ("left multiply right isExponents:true", .multiply, true),
            ("left multiply right isExponents:false", .multiply, false),
            ("left divide right isExponents:true", .divide, true),
            ("left divide right isExponents:false", .divide, false),
            ("left modulus right isExponents:true", .modulus, true),
            ("left modulus right isExponents:false", .modulus, false),
            ("left pow right isExponents:true", .pow, true),
            ("left pow right isExponents:false", .pow, false),
        ]

        for arg in arguments {
            do {
                try execute(expectedString: arg.0, opr: arg.1, isExponents: arg.2)
            }
        }
    }

    func execute(expectedString: String, opr: NativeBinaryOperator, isExponents: Bool) throws {
        let right = NumberMock(info: "right")
        let left = NumberMock(info: "left")
        let expectedType = String(describing: type(of: right))

        let result = opr.execute(left: left, right: right, isExponents: isExponents)
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

        token = NativeBinaryOperator.parse("%")
        XCTAssertNotNil(token)
        if let opr = token! as? NativeBinaryOperator {
            XCTAssertEqual(opr.identifier, "%")
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
