public struct NanValue: Number {
    
    public let tokenType: TokenType = .number
    public var isInteger: Bool = false

    public func toReal() -> RealNumber {
        return RealNumber(val: .nan)
    }

    public func add(left: Number) -> Number {
        return self
    }

    public func substract(left: Number) -> Number {
        return self
    }

    public func multiply(left: Number) -> Number {
        return self
    }

    public func divide(left: Number) -> Number {
        return self
    }

    public func modulus(left: Number) -> Number {
        return self
    }

    public func pow(left: Number) -> Number {
        return self
    }

    public func negate() -> Number {
        return self
    }

    public func abs() -> Number {
        return self
    }

    public func sqrt() -> Number {
        return self
    }

    public func sin() -> Number {
        return self
    }

    public func cos() -> Number {
        return self
    }

    public func tan() -> Number {
        return self
    }

    public func arcsin() -> Number {
        return self
    }

    public func arccos() -> Number {
        return self
    }

    public func arctan() -> Number {
        return self
    }

    public func log() -> Number {
        return self
    }

    public func ln() -> Number {
        return self
    }

    public static func parse(_ source: String) -> Token? {
        return nil
    }

    public static func deserialize(_ source: String) -> Token? {
        return nil
    }

    public func toDisplayString() -> String {
        ""
    }

    public func serialize() -> String {
        ""
    }
}