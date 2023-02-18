import Foundation

// coefficient * (realNumber ^ exponents) で表される数
public struct Constant: Number{
    public let isInteger: Bool
    public let tokenType: TokenType = .number
    public let identifier: String
    public static let e: Constant = Constant(identifier: "e", realNumber: Decimal(string: "2.71828182845904523536028747135266249776")!)
    public static let pi: Constant = Constant(identifier: "π", realNumber: Decimal.pi)
    
    private let realNumber: Decimal
    // 係数
    private let coefficientNumber: Number
    // 指数
    private let exponents: Int

    init(identifier: String, realNumber: Decimal) {
        self.identifier = identifier
        self.realNumber = realNumber
        // 実際に使うのはeとpiだけだからこの処理のほうが楽
        self.isInteger = false
        coefficientNumber = Fraction(numerator: 1, denominator: 1)!
        exponents = 1
    }

    /// 係数と指数を上書きした定数を作ります
    private init(baseConstant: Constant, coefficientNumber: Number, exponents: Int) {
        self.identifier = baseConstant.identifier
        self.isInteger = baseConstant.isInteger
        self.realNumber = baseConstant.realNumber
        self.coefficientNumber = coefficientNumber
        self.exponents = exponents
    }

    public func toReal() -> RealNumber {
        return coefficientNumber.multiply(left: RealNumber(val: Foundation.pow(realNumber, exponents))).toReal()
    }

    public func add(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        guard let leftConst: Constant = left as? Constant else {
            return toReal().add(left: left)
        }
        let coefTemp: Number = RealNumber(val: Decimal(leftConst.exponents - self.exponents)).pow(left: RealNumber(val: 10)).toReal().multiply(left: leftConst.coefficientNumber)
      
        return RealNumber(val: Decimal(self.exponents)).pow(left: RealNumber(val: 10)).multiply(left: coefTemp.add(left: self.coefficientNumber))
    }

    public func substract(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        guard let leftConst: Constant = left as? Constant else {
            return toReal().add(left: left)
        }
        let coefTemp: Number = RealNumber(val: Decimal(leftConst.exponents - self.exponents)).pow(left: RealNumber(val: 10)).toReal().multiply(left: leftConst.coefficientNumber)  
      
        return RealNumber(val: Decimal(self.exponents)).pow(left: RealNumber(val: 10)).multiply(left: self.coefficientNumber.toReal().substract(left: coefTemp))//coefTemp.substract(left: self.coefficientNumber))
    }

    public func multiply(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        guard let leftConst: Constant = left as? Constant else {
            return toReal().multiply(left: left)
        }
    
        return RealNumber(val: Decimal(leftConst.exponents + self.exponents)).pow(left: RealNumber(val: 10)).multiply(left: leftConst.coefficientNumber.toReal().multiply(left: self.coefficientNumber))
    }

    public func divide(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        guard let leftConst: Constant = left as? Constant else {
            return toReal().add(left: left)
        }
        return RealNumber(val: Decimal(leftConst.exponents - self.exponents)).pow(left: RealNumber(val: 10)).multiply(left: leftConst.coefficientNumber.toReal().multiply(left: self.coefficientNumber))  
    }

    public func modulus(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        
        return toReal().modulus(left: left.toReal())
    }

    public func pow(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }

        return self.toReal().pow(left: left.toReal())
    }

    public func negate() -> Number {
        return toReal().negate()
    }

    public func abs() -> Number {
        return toReal().abs()
    }

    public func sqrt() -> Number {
        return toReal().sqrt()
    }

    public func sin() -> Number {
        return toReal().sin()
    }

    public func cos() -> Number {
        return toReal().sin()
    }

    public func tan() -> Number {
        return toReal().tan()
    }

    public func arcsin() -> Number {
        return toReal().arcsin()
    }

    public func arccos() -> Number {
        return toReal().arccos()
    }

    public func arctan() -> Number {
        return toReal().arctan()
    }

    public func log() -> Number {
        return toReal().log()
    }

    public func ln() -> Number {
        return toReal().ln()
    }

    public static func parse(_ source: String) -> Token? {
        let dec: Decimal? = Decimal(string: source)
        guard let dec: Decimal else {
            return nil
        }
        if dec == Decimal.nan {
            return NanValue()
        }
        
        return RealNumber(val: dec)
    }

    public static func deserialize(_ source: String) -> Token? {
        let dec: Decimal? = Decimal(string: source)
        guard let dec: Decimal else {
            return nil
        }
        if dec == Decimal.nan {
            return NanValue()
        }
        
        return RealNumber(val: dec)
    }

    public func toDisplayString() -> String {
        return name
    }

    public func serialize() -> String {
        return rawText
    }
}