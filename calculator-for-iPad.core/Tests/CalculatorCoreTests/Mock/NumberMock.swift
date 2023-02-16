@testable import CalculatorCore

public class NumberMock: Number {
    public let isInteger: Bool = true
    public let tokenType: TokenType = .number
    public let info: String

    public init(info: String = "") {
        self.info = info
    }

    public func add(left: Number, isExponents: Bool) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) add \(info) isExponents:\(isExponents)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func substract(left: Number, isExponents: Bool) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) substract \(info) isExponents:\(isExponents)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func multiply(left: Number, isExponents: Bool) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) multiply \(info) isExponents:\(isExponents)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func divide(left: Number, isExponents: Bool) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) divide \(info) isExponents:\(isExponents)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func modulus(left: Number, isExponents: Bool) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) modulus \(info) isExponents:\(isExponents)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func pow(left: Number, isExponents: Bool) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) pow \(info) isExponents:\(isExponents)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func negate(isExponents: Bool) -> Number {
        return NumberMock(info: "negate \(info) isExponents:\(isExponents)")
    }
    public func abs(isExponents: Bool) -> Number {
        return NumberMock(info: "abs \(info) isExponents:\(isExponents)")
    }
    public func sqrt(isExponents: Bool) -> Number {
        return NumberMock(info: "sqrt \(info) isExponents:\(isExponents)")
    }
    public func sin(isExponents: Bool) -> Number {
        return NumberMock(info: "sin \(info) isExponents:\(isExponents)")
    }
    public func cos(isExponents: Bool) -> Number {
        return NumberMock(info: "cos \(info) isExponents:\(isExponents)")
    }
    public func tan(isExponents: Bool) -> Number {
        return NumberMock(info: "tan \(info) isExponents:\(isExponents)")
    }
    public func arcsin(isExponents: Bool) -> Number {
        return NumberMock(info: "arcsin \(info) isExponents:\(isExponents)")
    }
    public func arccos(isExponents: Bool) -> Number {
        return NumberMock(info: "arccos \(info) isExponents:\(isExponents)")
    }
    public func arctan(isExponents: Bool) -> Number {
        return NumberMock(info: "arctan \(info) isExponents:\(isExponents)")
    }
    public func log(isExponents: Bool) -> Number {
        return NumberMock(info: "log \(info) isExponents:\(isExponents)")
    }
    public func ln(isExponents: Bool) -> Number {
        return NumberMock(info: "ln \(info) isExponents:\(isExponents)")
    }

    public static func parse(_ source: String) -> Token? {
        return nil
    }

    public static func deserialize(_ source: String) -> Token? {
        return nil
    }

    public func toDisplayString() -> String {
        return ""
    }

    public func serialize() -> String {
        return ""
    }

    public func toReal() -> RealNumber {
        return RealNumber(val: .nan)
    }
}
