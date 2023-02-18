import Foundation

// coefficient * (realNumber ^ exponents) で表される数
public struct Constant: Number{
    public let isInteger: Bool
    public let tokenType: TokenType = .number
    public let identifier: String
    public var isZero: Bool { return coefficient.isZero }
    public var isOne: Bool { return exponents == 0 && coefficient.isOne }
    public var isNegativeOne: Bool { return exponents == 0 && coefficient.isNegativeOne }
    public static let e: Constant = Constant(identifier: "e", realNumber: Decimal(string: "2.71828182845904523536028747135266249776")!)
    public static let pi: Constant = Constant(identifier: "π", realNumber: Decimal.pi)
    
    private let realNumber: Decimal
    // 係数
    private let coefficient: Number
    // 指数
    private let exponents: Int

    init(identifier: String, realNumber: Decimal) {
        self.identifier = identifier
        self.realNumber = realNumber
        // 実際に使うのはeとpiだけだからこの処理のほうが楽
        self.isInteger = false
        coefficient = Fraction(numerator: 1, denominator: 1)!
        exponents = 1
    }

    /// 係数と指数を上書きした定数を作ります
    private init(base baseConstant: Constant, _ coefficient: Number, _ exponents: Int) {
        self.identifier = baseConstant.identifier
        self.isInteger = baseConstant.isInteger
        self.realNumber = baseConstant.realNumber
        self.coefficient = coefficient
        self.exponents = exponents
    }

    public func toReal() -> RealNumber {
        return coefficient.multiply(left: RealNumber(val: Foundation.pow(realNumber, exponents))).toReal()
    }

    private func toNumber() -> Number {
        if exponents == 0 {
            return coefficient
        } else {
            return toReal()
        }
    }

    public func add(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        } else if isZero {
            return left
        } else if left.isZero {
            return self
        }
        guard let leftConst: Constant = left as? Constant else {
            return toNumber().add(left: left)
        }

        if leftConst.exponents == exponents && leftConst.identifier == identifier {
            return Constant(base: self, coefficient.add(left: leftConst.coefficient), exponents)
        } else {    
            return toNumber().add(left: leftConst.toNumber())
        }
    }

    public func substract(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        } else if isZero {
            return left
        } else if left.isZero {
            return self.negate()
        }
        guard let leftConst: Constant = left as? Constant else {
            return toNumber().substract(left: left)
        }

        if leftConst.exponents == exponents && leftConst.identifier == identifier {
            return Constant(base: self, coefficient.substract(left: leftConst), exponents)
        } else {
            return toNumber().substract(left: leftConst.toNumber())
        }
    }

    public func multiply(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        } else if isZero || left.isZero {
            return Fraction.zero
        } else if isOne {
            return left
        } else if left.isOne {
            return self
        }
        guard let leftConst: Constant = left as? Constant else {
            return Constant(base: self, coefficient.multiply(left: left), exponents)
        }

        if leftConst.identifier == identifier {
            return Constant(base: self, coefficient.multiply(left: leftConst.coefficient), exponents + leftConst.exponents)
        } else {
            return toNumber().multiply(left: leftConst.toNumber())
        }
    }

    public func multiply(right: Number) -> Number {
        if right is NanValue{
            return NanValue()
        } else if isZero || right.isZero {
            return Fraction.zero
        } else if isOne {
            return right
        } else if right.isOne {
            return self
        }
        guard let rightConst: Constant = right as? Constant else {
            return Constant(base: self, right.multiply(left: coefficient), exponents)
        }

        if rightConst.identifier == identifier {
            return Constant(base: self, coefficient.multiply(left: rightConst.coefficient), exponents + rightConst.exponents)
        } else {
            return toNumber().multiply(left: rightConst.toNumber())
        }
    }

    public func divide(left: Number) -> Number {
        if left is NanValue || isZero {
            return NanValue()
        } else if left.isZero {
            return Fraction.zero
        } else if isOne {
            return left
        }
        guard let leftConst: Constant = left as? Constant else {
            return Constant(base: self, coefficient.divide(left: left), exponents)
        }

        if leftConst.identifier == identifier {
            return Constant(base: self, coefficient.divide(left: leftConst.coefficient), leftConst.exponents - exponents)
        } else {
            return toNumber().divide(left: leftConst.toNumber())
        }
    }

    public func divide(right: Number) -> Number {
        if right is NanValue || right.isZero {
            return NanValue()
        } else if isZero {
            return Fraction.zero
        } else if right.isOne {
            return self
        }
        guard let rightConst: Constant = right as? Constant else {
            return Constant(base: self, right.divide(left: coefficient), exponents)
        }

        if rightConst.identifier == identifier {
            return Constant(base: self, coefficient.divide(left: rightConst.coefficient), exponents - rightConst.exponents)
        } else {
            return toNumber().divide(left: rightConst.toNumber())
        }
    }

    public func modulus(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        
        if let leftConst = left as? Constant {
            return toNumber().modulus(left: leftConst.toNumber())
        } else {
            return toNumber().modulus(left: left)
        }
    }

    public func pow(left: Number) -> Number {
        if left is NanValue {
            return NanValue()
        } else if isZero || left.isOne {
            return Fraction(numerator: 1, denominator: 1)!
        } else if left.isZero {
            return Fraction.zero
        } else if isOne {
            return left
        }

        return toNumber().pow(left: left)
    }

    public func pow(right: Int) -> Number {
        if right == 0 || isOne {
            return Fraction(numerator: 1, denominator: 1)!
        } else if isZero {
            return Fraction.zero
        } else if right == 1 {
            return self
        }
        let rightFrac = Fraction(numerator: right, denominator: 1)
        let coef: Number
        if let rightFrac {
            coef = rightFrac.pow(left: coefficient)
        } else {
            return NanValue()
        }
        return Constant(base: self, coef, exponents + right)
    }

    public func negate() -> Number {
        return Constant(base: self, coefficient.negate(), exponents)
    }

    public func abs() -> Number {
        return Constant(base: self, coefficient.abs(), exponents)
    }

    public func sqrt() -> Number {
        if isOne {
            return Fraction(numerator: 1, denominator: 1)!
        } else if isZero {
            return Fraction.zero
        } else if exponents % 2 == 0 {
            return Constant(base: self, coefficient.sqrt(), exponents / 2)
        } else {
            return toNumber().sqrt()
        }
    }

    public func sin() -> Number {
        if isZero {
            return Fraction.zero
        } else if identifier == "π" {
            if exponents == 1 && coefficient.isInteger {
                return Fraction.zero
            }
        }
        return toNumber().sin()
    }

    public func cos() -> Number {
        return toNumber().sin()
    }

    public func tan() -> Number {
        return toNumber().tan()
    }

    public func arcsin() -> Number {
        return toNumber().arcsin()
    }

    public func arccos() -> Number {
        return toNumber().arccos()
    }

    public func arctan() -> Number {
        return toNumber().arctan()
    }

    public func log() -> Number {
        return toNumber().log()
    }

    public func ln() -> Number {
        if identifier == "e" {
            return coefficient.ln().add(Fraction(numerator: exponents, denominator: 1) ?? NanValue())
        }
        return toNumber().ln()
    }

    public static func parse(_ source: String) -> Token? {
        if source == "π" {
            return Constant.pi
        } else if source == "e" {
            return Constant.e
        } else {
            return nil
        }
    }

    public static func deserialize(_ source: String) -> Token? {
        return parse(source)
    }

    public func toDisplayString() -> String {
        if coefficient.toDisplayString() == "" {
            return ""
        } else if exponents == 0 {
            return coefficient.toDisplayString()
        } else if exponents == 1 {
            return "\(coefficient.toDisplayString()) \(identifier)"
        } else {
            return "\(coefficient.toDisplayString()) \(identifier)^\(exponents)"
        }
    }

    public func serialize() -> String {
        return toDisplayString()
    }
}