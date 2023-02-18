import XCTest
@testable import CalculatorCore

public final class CalculatorServiceTest: XCTestCase {
    func test() {
      let calc = CalculatorService()
      calc.parseString(rawExpression: "1.1+√2+sin+arcsin-mod")
    }
}