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
        let arguments: [(String, NativeUnaryOperator, Bool)] = [
            ("negate value isExponents:true", .negate, true),
            ("negate value isExponents:false", .negate, false),
            ("abs value isExponents:true", .abs, true),
            ("abs value isExponents:false", .abs, false),
            ("sqrt value isExponents:true", .sqrt, true),
            ("sqrt value isExponents:false", .sqrt, false),
            ("sin value isExponents:true", .sin, true),
            ("sin value isExponents:false", .sin, false),
            ("cos value isExponents:true", .cos, true),
            ("cos value isExponents:false", .cos, false),
            ("tan value isExponents:true", .tan, true),
            ("tan value isExponents:false", .tan, false),
            ("arcsin value isExponents:true", .arcsin, true),
            ("arcsin value isExponents:false", .arcsin, false),
            ("arccos value isExponents:true", .arccos, true),
            ("arccos value isExponents:false", .arccos, false),
            ("arctan value isExponents:true", .arctan, true),
            ("arctan value isExponents:false", .arctan, false),
            ("log value isExponents:true", .log, true),
            ("log value isExponents:false", .log, false),
            ("ln value isExponents:true", .ln, true),
            ("ln value isExponents:false", .ln, false),
        ]
        
        for arg in arguments {
            do {
                try execute(expectedString: arg.0, opr: arg.1, isExponents: arg.2)
            }
        }
    }

    func execute(expectedString: String, opr: NativeUnaryOperator, isExponents: Bool) throws {
        let value = NumberMock(info: "value")
        let expectedType = String(describing: type(of: value))

        let result = opr.execute(value: value, isExponents: isExponents)
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
