public struct NanValue: Number {
    public let tokenType: TokenType = .number
    public var isInteger: Bool = false

    public func toReal() -> Number {
        return self
    }

    public func add(left: Number, isExponents: Bool) -> Number {
        return self
    }

    public func substract(left: Number, isExponents: Bool) -> Number {
        return self
    }

    public func multiply(left: Number, isExponents: Bool) -> Number {
        return self
    }

    public func divide(left: Number, isExponents: Bool) -> Number {
        return self
    }

    public func modulus(left: Number, isExponents: Bool) -> Number {
        return self
    }

    public func pow(left: Number, isExponents: Bool) -> Number {
        return self
    }

    public func negate(isExponents: Bool) -> Number {
        return self
    }

    public func abs(isExponents: Bool) -> Number {
        return self
    }

    public func sqrt(isExponents: Bool) -> Number {
        return self
    }

    public func sin(isExponents: Bool) -> Number {
        return self
    }

    public func cos(isExponents: Bool) -> Number {
        return self
    }

    public func tan(isExponents: Bool) -> Number {
        return self
    }

    public func arcsin(isExponents: Bool) -> Number {
        return self
    }

    public func arccos(isExponents: Bool) -> Number {
        return self
    }

    public func arctan(isExponents: Bool) -> Number {
        return self
    }

    public func log(isExponents: Bool) -> Number {
        return self
    }

    public func ln(isExponents: Bool) -> Number {
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