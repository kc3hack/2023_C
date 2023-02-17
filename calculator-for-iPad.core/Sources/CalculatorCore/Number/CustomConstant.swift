import Foundation
public struct CustomConstant: Number{
    public var isInteger: Bool
    public var tokenType: TokenType
    let name: String
    let rawText: String
    static let e: CustomConstant = CustomConstant(nameString: "e", rawString: "e", coefficientVal: RealNumber(val: Decimal(string: "2.71828182845904523536028747135266249776")!), exponentsVal: 0)
    static let pi: CustomConstant = CustomConstant(nameString: "pi", rawString: "pi", coefficientVal: RealNumber(val: Decimal.pi), exponentsVal: 0)
    
    // 係数
    let coefficientNumber: Number
    // 指数
    let exponents: Int

    init(nameString: String, rawString: String, coefficientVal: Number, exponentsVal: Int){
        name = nameString
        rawText = rawString
        coefficientNumber = coefficientVal
        exponents = exponentsVal
        isInteger = false
        tokenType = TokenType.number
    }

    public func toReal() -> RealNumber {
        return RealNumber(val:Decimal(exponents)).pow(left: RealNumber(val: Decimal(10))).multiply(left: coefficientNumber.toReal()).toReal()
    }

    public func add(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        guard let leftConst: CustomConstant = left as? CustomConstant else {
            return toReal().add(left: left)
        }
        let coefTemp: Number = RealNumber(val: Decimal(leftConst.exponents - self.exponents)).pow(left: RealNumber(val: 10)).toReal().multiply(left: leftConst.coefficientNumber)
      
        return RealNumber(val: Decimal(self.exponents)).pow(left: RealNumber(val: 10)).multiply(left: coefTemp.add(left: self.coefficientNumber))
    }

    public func substract(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        guard let leftConst: CustomConstant = left as? CustomConstant else {
            return toReal().add(left: left)
        }
        let coefTemp: Number = RealNumber(val: Decimal(leftConst.exponents - self.exponents)).pow(left: RealNumber(val: 10)).toReal().multiply(left: leftConst.coefficientNumber)  
      
        return RealNumber(val: Decimal(self.exponents)).pow(left: RealNumber(val: 10)).multiply(left: self.coefficientNumber.toReal().substract(left: coefTemp))//coefTemp.substract(left: self.coefficientNumber))
    }

    public func multiply(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        guard let leftConst: CustomConstant = left as? CustomConstant else {
            return toReal().multiply(left: left)
        }
    
        return RealNumber(val: Decimal(leftConst.exponents + self.exponents)).pow(left: RealNumber(val: 10)).multiply(left: leftConst.coefficientNumber.toReal().multiply(left: self.coefficientNumber))
    }

    public func divide(left: Number) -> Number {
        if left is NanValue{
            return NanValue()
        }
        guard let leftConst: CustomConstant = left as? CustomConstant else {
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