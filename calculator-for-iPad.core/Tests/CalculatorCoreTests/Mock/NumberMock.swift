@testable import CalculatorCore

public class NumberMock: Number {
    public let isInteger: Bool = true
    public let tokenType: TokenType = .number
    public let info: String

    public init(info: String = "") {
        self.info = info
    }

    public func add(left: Number) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) add \(info)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func substract(left: Number) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) substract \(info)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func multiply(left: Number) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) multiply \(info)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func divide(left: Number) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) divide \(info)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func modulus(left: Number) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) modulus \(info)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func pow(left: Number) -> Number {
        if let mock = left as? NumberMock {
            return NumberMock(info: "\(mock.info) pow \(info)")
        } else {
            return NumberMock(info: "not supported")
        }
    }
    public func negate() -> Number {
        return NumberMock(info: "negate \(info)")
    }
    public func abs() -> Number {
        return NumberMock(info: "abs \(info)")
    }
    public func sqrt() -> Number {
        return NumberMock(info: "sqrt \(info)")
    }
    public func sin() -> Number {
        return NumberMock(info: "sin \(info)")
    }
    public func cos() -> Number {
        return NumberMock(info: "cos \(info)")
    }
    public func tan() -> Number {
        return NumberMock(info: "tan \(info)")
    }
    public func arcsin() -> Number {
        return NumberMock(info: "arcsin \(info)")
    }
    public func arccos() -> Number {
        return NumberMock(info: "arccos \(info)")
    }
    public func arctan() -> Number {
        return NumberMock(info: "arctan \(info)")
    }
    public func log() -> Number {
        return NumberMock(info: "log \(info)")
    }
    public func ln() -> Number {
        return NumberMock(info: "ln \(info)")
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
