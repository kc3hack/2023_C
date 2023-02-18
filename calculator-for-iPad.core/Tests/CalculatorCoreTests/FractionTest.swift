import XCTest
@testable import CalculatorCore

public final class FractionTest: XCTestCase {
    public func testLcm() throws {
        let arguments: [(Int?, Int, Int, Int, Int)] = [
            (2, 1, 1, 2, 2),
        ]

        do {
            for arg in arguments {
                try lcm(expectedLcm: arg.0, expectedXMultiply: arg.1, expectedYMultiply: arg.2, x: arg.3, y: arg.4)
            }
        }
    }

    public func lcm(expectedLcm: Int?, expectedXMultiply: Int, expectedYMultiply: Int, x: Int, y: Int) throws {
        let franction = Fraction(numerator: 1, denominator: 1)!
        let (lcm, xMultiply, yMultiply) = franction.lcm(x: x, y: y)

        XCTAssertEqual(lcm, expectedLcm)
        XCTAssertEqual(xMultiply, expectedXMultiply)
        XCTAssertEqual(yMultiply, expectedYMultiply)
    }

    public func testDivide() throws {
        let arguments: [(Number, Fraction, Fraction)] = [
            (NanValue(), Fraction(numerator: 1, denominator: 1)!, Fraction(numerator: 0, denominator: 1)!)
        ]

        do {
            for arg in arguments {
                try divide(expected: arg.0, left: arg.1, right: arg.2)
            }
        }
    }
    
    public func divide(expected: Number, left: Fraction, right: Fraction) throws {
        let result = right.divide(left: left)

        XCTAssertEqual(result.toDisplayString(), expected.toDisplayString())
    }

    public func testParse() throws {
        let arguments: [(String?, String)] = [
            ("3", "3"),
            ("1/2", "0.5"),
            ("6/5", "1.2")
        ]

        do {
            for arg in arguments {
                try parse(expected: arg.0, source: arg.1)
            }
        }
    }

    public func parse(expected: String?, source: String) throws {
        let result = Fraction.parse(source)

        XCTAssertEqual(result?.toDisplayString(), expected)
    }
}