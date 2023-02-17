import XCTest
@testable import CalculatorCore

public final class NativeUnaryOperatorTest: XCTestCase {
    func testIdentifier() throws {
        var opr: NativeUnaryOperator = .negate
        XCTAssertEqual(opr.identifier, "-")

        opr = .abs
        XCTAssertEqual(opr.identifier, "abs")

        opr = .sqrt
        XCTAssertEqual(opr.identifier, "√")

        opr = .sin
        XCTAssertEqual(opr.identifier, "sin")

        opr = .cos
        XCTAssertEqual(opr.identifier, "cos")

        opr = .tan
        XCTAssertEqual(opr.identifier, "tan")

        opr = .arcsin
        XCTAssertEqual(opr.identifier, "arcsin")

        opr = .arccos
        XCTAssertEqual(opr.identifier, "arccos")

        opr = .arctan
        XCTAssertEqual(opr.identifier, "arctan")

        opr = .log
        XCTAssertEqual(opr.identifier, "log")

        opr = .ln
        XCTAssertEqual(opr.identifier, "ln")
    }

    func testExecute() throws {
        let arguments: [(String, NativeUnaryOperator)] = [
            ("negate value", .negate),
            ("abs value", .abs),
            ("sqrt value", .sqrt),
            ("sin value", .sin),
            ("cos value", .cos),
            ("tan value", .tan),
            ("arcsin value", .arcsin),
            ("arccos value", .arccos),
            ("arctan value", .arctan),
            ("log value", .log),
            ("ln value", .ln),
        ]
        
        for arg in arguments {
            do {
                try execute(expectedString: arg.0, opr: arg.1)
            }
        }
    }

    func execute(expectedString: String, opr: NativeUnaryOperator) throws {
        let value = NumberMock(info: "value")
        let expectedType = String(describing: type(of: value))

        let result = opr.execute(value: value)
        XCTAssertEqual(String(describing: type(of: result)), expectedType)
        if let mock = result as? NumberMock {
            XCTAssertEqual(mock.info, expectedString)
        }
    }

    func testparse() throws {
        let arguments: [(String?, NativeUnaryOperator, String)] = [
            (nil, .negate, "-"),
            ("abs", .abs, "abs"),
            ("√", .sqrt, "√"),
            (nil, .sqrt, "sqrt"),
            ("sin", .sin, "sin"),
            ("cos", .cos, "cos"),
            ("tan", .tan, "tan"),
            ("arcsin", .arcsin, "arcsin"),
            ("arccos", .arccos, "arccos"),
            ("arctan", .arctan, "arctan"),
            ("log", .log, "log"),
            ("ln", .ln, "ln"),
            (nil, .negate, "*"),
            (nil, .negate, "+"),
        ]

        for arg in arguments {
            do {
                try parse(expectedIdentifier: arg.0, expectedOpr: arg.1, source: arg.2)
            }
        }
    }

    func parse(expectedIdentifier: String?, expectedOpr: NativeUnaryOperator, source: String) throws {
        let token: Token? = NativeUnaryOperator.parse(source)
        if let expectedIdentifier {
            XCTAssertNotNil(token)
            if let opr = token! as? NativeUnaryOperator {
                XCTAssertEqual(opr.identifier, expectedIdentifier)
                XCTAssertEqual(opr, expectedOpr)
            }
        } else {
            XCTAssertNil(token)
        }
    }

    func testDeserialize() throws {
        let arguments: [(String?, NativeUnaryOperator, String)] = [
            (nil, .negate, "-"),
            ("abs", .abs, "abs"),
            (nil, .sqrt, "√"),
            ("√", .sqrt, "sqrt"),
            ("sin", .sin, "sin"),
            ("cos", .cos, "cos"),
            ("tan", .tan, "tan"),
            ("arcsin", .arcsin, "arcsin"),
            ("arccos", .arccos, "arccos"),
            ("arctan", .arctan, "arctan"),
            ("log", .log, "log"),
            ("ln", .ln, "ln"),
            (nil, .negate, "*"),
            (nil, .negate, "+"),
        ]

        for arg in arguments {
            do {
                try deserialize(expectedIdentifier: arg.0, expectedOpr: arg.1, source: arg.2)
            }
        }
    }

    func deserialize(expectedIdentifier: String?, expectedOpr: NativeUnaryOperator, source: String) throws {
        let token: Token? = NativeUnaryOperator.deserialize(source)
        if let expectedIdentifier {
            XCTAssertNotNil(token)
            if let opr = token! as? NativeUnaryOperator {
                XCTAssertEqual(opr.identifier, expectedIdentifier)
                XCTAssertEqual(opr, expectedOpr)
            }
        } else {
            XCTAssertNil(token)
        }
    }
}
