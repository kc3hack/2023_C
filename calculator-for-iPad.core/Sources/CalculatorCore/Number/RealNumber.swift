import Foundation

public struct RealNumber: Number{
    public let tokenType: TokenType = .number
    public let isInteger: Bool
    public var isZero: Bool { return value.isZero }
    public var isOne: Bool { return value == Decimal(1) }
    public var isNegativeOne: Bool { return value == Decimal(-1) }
    private let value: Decimal
    
    init(val: Decimal) {
        self.value = val
        
        let integer = NSDecimalNumber(decimal: val).intValue
        self.isInteger = Decimal(integerLiteral: integer) == val
    }

    public func toReal() -> RealNumber{
        return self
    }

    public func add(left: Number) -> Number {
        if left is NanValue {
            return NanValue()
        } else if isZero {
            return left
        } else if left.isZero {
            return self
        } else {
            return RealNumber(val: left.toReal().value + value )
        }
    }

    public func substract(left: Number) -> Number {
        if left is NanValue {
            return NanValue()
        } else if isZero {
            return left
        } else if left.isZero {
            return self.negate()
        }
        return RealNumber(val: left.toReal().value - value )
    }

    public func multiply(left: Number) -> Number {
        if left is NanValue {
            return NanValue()
        } else if isZero || left.isZero {
            return Fraction.zero
        } else if isOne {
            return left
        } else if left.isOne {
            return self
        } else if let leftConst = left as? Constant {
            return leftConst.multiply(right: self)
        } else {
            return RealNumber(val: mul(x: left.toReal().value, y: value ))
        }
    }

    public func divide(left: Number) -> Number {
        if left is NanValue || isZero {
            return NanValue()
        } else if left.isZero {
            return Fraction.zero
        } else if isOne {
            return left
        } else if let leftConst = left as? Constant {
            return leftConst.divide(right: self)
        } else {
            return RealNumber(val: left.toReal().value / value )
        }
    }

    public func modulus(left: Number) -> Number {
        var dec: Decimal
        
        //商の計算
        dec = left.toReal().value / value 
        //real.valueをIntに変換
        var rounded: Decimal = Decimal()
        NSDecimalRound(&rounded, &dec, 0, .down)
        let temp: Int = (rounded as NSDecimalNumber).intValue
        //余りの計算
        dec = Decimal(temp)
        dec = left.toReal().value - value * dec
        
        return RealNumber(val: dec)
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
        } else if let leftConst = left as? Constant, isInteger {
            return leftConst.pow(right: NSDecimalNumber(decimal: value).intValue)
        }

        var dec: Decimal
        dec = left.toReal().value
            if dec  <= 0{
            let exp: Decimal = value

            if dec.isNaN || exp.isNaN { return NanValue() }
            else if exp == 0 { 
                dec = 1

                let real: RealNumber = RealNumber(val: dec)
                return  real
            }
            else if exp < 0 { 

                dec = 1 / left.pow(left: RealNumber(val: exp * -1)).toReal().value

                let real: RealNumber = RealNumber(val: dec)
                return real
            }

            // Separate Integer and Decimal
            let integer: Decimal = floor(decimal: exp)
            let decimal: Decimal = exp - integer

            // Calculate Integer Part
            let intX: Int = (integer as NSNumber).intValue
            if !integer.isZero && intX == 0 { return NanValue() }
            let intRes: Decimal = Foundation.pow(dec, intX)

            // Calculate Decimal Part
            let temp: Decimal = ln().toReal().value
            let decRes: Decimal = myexp(decimal: (decimal * temp))

            // Merge
            dec = intRes * decRes

            return RealNumber(val: dec)
        }else{
            let dbl: Double = (self.value as NSNumber).doubleValue
            let leftDbl: Double = (dec as NSNumber).doubleValue
            let result: Double = Foundation.pow(leftDbl, dbl)

            return RealNumber(val: Decimal(result))
        }
    }

    public func negate() -> Number {
        return RealNumber(val: -value)
    }

    public func abs() -> Number {
        return RealNumber(val: value < 0 ? -value : value)
    }

    public func sqrt() -> Number {
        if isOne {
            return Fraction(numerator: 1, denominator: 1)!
        } else if isZero {
            return Fraction.zero
        }
        var dec: Decimal     
        dec = self.value

        if dec.isNaN || dec < 0 { return NanValue() }
        let dbl: Double = (dec as NSNumber).doubleValue
        if dbl.isNaN { return NanValue() }

        let temp: Decimal = Decimal(Foundation.sqrt(dbl))
        dec = newton(f_df: {($0 * $0 - dec) / (2 * $0)}, estimate: temp)

        return RealNumber(val: dec)
    }

    public func sin() -> Number {
        let two_pi: Decimal = Decimal.pi * 2
        let pi_two: Decimal = Decimal.pi / 2
        var dec: Decimal = value

        var angle: Decimal = nomalizeRadian(decimal: dec)
        var sign: Decimal = 1
        if pi_two < angle && angle <= Decimal.pi { angle = Decimal.pi - angle }
        else if Decimal.pi < angle && angle <= pi_two * 3 { angle -= Decimal.pi; sign = -1 }
        else if pi_two * 3 < angle { angle = two_pi - angle; sign = -1 }

        let square: Decimal = mul(x: angle,y: angle)
        var coef: Decimal = angle
        var coefs: [Decimal] = [coef]
        for i: Int in 1...19 {
            coef = mul(x: coef, y: -square / Decimal(2 * i * (2 * i + 1)))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let res: Decimal = coefs.reversed().reduce(0, { $0 + $1 })
        dec =  res * sign

        let real: RealNumber = RealNumber(val: dec)
        return real
    }

    public func cos() -> Number {
        let pi_two: Decimal = Decimal.pi / 2
        let two_pi: Decimal = Decimal.pi * 2
        var dec: Decimal     
        dec = self.value

        var angle: Decimal = nomalizeRadian(decimal: dec)
        var sign: Decimal = 1
        if pi_two < angle && angle <= Decimal.pi { angle = Decimal.pi - angle; sign = -1 }
        else if Decimal.pi < angle && angle <= pi_two * 3 { angle -= Decimal.pi; sign = -1 }
        else if pi_two * 3 < angle { angle = two_pi - angle}

        let square: Decimal = mul(x: angle,y: angle)
        var coef: Decimal = 1
        var coefs: [Decimal] = [coef]
        for i: Int in 1...19 {
            coef = mul(x: coef,y: -square / Decimal((2 * i - 1) * 2 * i))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let res: Decimal = coefs.reversed().reduce(0, { $0 + $1 })
        dec =  res * sign

        let real: RealNumber = RealNumber(val: dec)
        return real
    }

    public func tan() -> Number {
        let result = sin().toReal().value / cos().toReal().value

        return RealNumber(val: result)
    }

    public func arcsin() -> Number {
        let dbl: Double = (self.value as NSNumber).doubleValue
        return RealNumber(val: Decimal(Foundation.asin(dbl)))
    }

    public func arccos() -> Number {
        let dbl: Double = (self.value as NSNumber).doubleValue
        return RealNumber(val: Decimal(Foundation.acos(dbl)))
    }

    public func arctan() -> Number {
        let dbl: Double = (self.value as NSNumber).doubleValue
        return RealNumber(val: Decimal(Foundation.atan(dbl)))
    }

    public func log() -> Number {
        return RealNumber(val: mylog(base: 10, decimal: value))
    }

    public func ln() -> Number {
        let e: Decimal = Decimal(string: "2.71828182845904523536028747135266249776")!

        return RealNumber(val: mylog(base: e, decimal: value))
    }

    public static func parse(_ source: String) -> Token? {
        let dec: Decimal? = Decimal(string: source)
        guard let dec else {
            return nil
        }
        if dec == Decimal.nan {
            return NanValue()
        }
        
        return RealNumber(val: dec)
    }

    public static func deserialize(_ source: String) -> Token? {
        let dec: Decimal? = Decimal(string: source)
        guard let dec else {
            return nil
        }
        if dec == Decimal.nan {
            return NanValue()
        }
        
        return RealNumber(val: dec)
    }

    public func toDisplayString() -> String {
        if value.isNaN {
            return ""
        } else {
            return "\(value)"
        }
    }

    public func serialize() -> String {
        return "\(value)"
    }

    private func abso(decimal: Decimal)-> Decimal{
        return decimal < 0 ? -decimal : decimal
    }

    private func mul(x: Decimal, y: Decimal) -> Decimal {
        let r: Decimal = x * y
        if abso(decimal: x) < 1 && abso(decimal: y) < 1 && abso(decimal: r) >= 1 {
            return .nan
        } else {
            return r
        }
    }

    private func floor(decimal: Decimal) -> Decimal{
        let behavior: NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return (decimal as NSDecimalNumber).rounding(accordingToBehavior: behavior) as Decimal
    }

    private func nomalizeRadian(decimal: Decimal) -> Decimal {
        var t: Decimal = (decimal / (Decimal.pi * 2))
        t = floor(decimal: t)
        return decimal - (t * (.pi * 2))
    }

    private func myexp(decimal: Decimal) -> Decimal{
        let e: Decimal = Decimal(string: "2.71828182845904523536028747135266249776")!

        if decimal.isNaN { return Decimal.nan }
        else if decimal == 0 { return 1 }
        else if decimal < 0 { return 1 / myexp(decimal: -decimal) }

        // Separate Integer and Decimal
        let integer: Decimal = floor(decimal: decimal)
        let decimal: Decimal = decimal - integer

        // Calculate Integer Part
        let intX: Int = (integer as NSNumber).intValue
        if !integer.isZero && intX == 0 { return Decimal.nan }
        let intRes: Decimal = Foundation.pow(e, intX)

        // Calculate Decimal Part
        var coef: Decimal = decimal
        var coefs: [Decimal] = [Decimal]()
        for i: Int in 2...34 {
            coef = mul(x: coef,y: decimal / Decimal(i))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let decRes: Decimal = coefs.reversed().reduce(0, { $0 + $1 }) + decimal + 1

        // Merge
        return intRes * decRes
    }

    private func mylog(base: Decimal, decimal: Decimal) -> Decimal{
        if decimal <= 0 || base <= 0 || decimal.isNaN || base.isNaN { return Decimal.nan }
        else if decimal == 1 { return 0 }
        else if base == 1 { return .nan }
        else if decimal < 1 { return mylog(base: base, decimal: 1 / decimal) * -1 }
        else if base < 1 { return mylog(base: 1 / base, decimal: decimal) * -1 }
        else if decimal < base { return 1 / mylog(base: decimal, decimal: base) }

        var number: Decimal = decimal
        var coef: Decimal = 1
        var result: Decimal = 0, next: Decimal = 0
        while true {
            if number == base {
                result += coef
                break
            } else if number == 1 {
                break
            } else if number > base {
                next += coef
                number /= base
                if next.isNaN || next == result {
                    break
                }
                result = next
            } else {
                coef /= 2
                number = mul(x: number, y: number)
            }
        }
        return result
    }

    private func newton(f_df: (Decimal) -> Decimal, estimate: Decimal) -> Decimal {
        var result: Decimal = estimate, minDiff: Decimal = Decimal.greatestFiniteMagnitude
        var next: Decimal = estimate - f_df(result)
        if next.isNaN { return Decimal.nan }
        result = next
        var lambda: Decimal = 1
        while true {
            let step: Decimal = f_df(result)
            let diff: Decimal = abso(decimal: step)
            while diff * lambda >= minDiff {
                lambda /= 2
            }
            minDiff = diff * lambda
            next -= step * lambda
            if next.isNaN || next == result {
                return result
            } else if diff * lambda <= Decimal.leastNonzeroMagnitude {
                return next
            }
            result = next
        }
    }
}
