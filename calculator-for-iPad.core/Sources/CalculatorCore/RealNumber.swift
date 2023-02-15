import Foundation

// また、nanを表すpublicなstaticプロパティ用意してnanを返す時はそれを利用するようにしてください。

public struct RealNumber: Number{
    public var tokenType: TokenType
    public var isInteger: Bool
    private let value: Decimal
    
    init(val: Decimal) {
        self.value = val
        self.tokenType = TokenType.number

        let dbl: Double = (val as NSNumber).doubleValue
        let int: Double = Double(Int(dbl))
        self.isInteger = dbl == int
    }

    public func toReal() -> RealNumber{
        return self
    }

    public func add(left: Number, isExponents: Bool) -> Number {
        let real: RealNumber = RealNumber(val: left.toReal().value + self.value )
       
        return real
    }

    public func substract(left: Number, isExponents: Bool) -> Number {
        let real: RealNumber = RealNumber(val: left.toReal().value - self.value )
      
        return real
    }

    public func multiply(left: Number, isExponents: Bool) -> Number {
        let real: RealNumber = RealNumber(val: mul(decimal: left.toReal().value, y: self.value ))

        return real
    }

    public func divide(left: Number, isExponents: Bool) -> Number {
        let real: RealNumber = RealNumber(val: left.toReal().value / self.value )

        return real
    }

    public func modulus(left: Number, isExponents: Bool) -> Number {
        var dec: Decimal
        
        //商の計算
        dec = left.toReal().value / self.value 
        //real.valueをIntに変換
        var rounded: Decimal = Decimal()
        NSDecimalRound(&rounded, &dec, 0, .down)
        let temp: Int = (rounded as NSDecimalNumber).intValue
        //余りの計算
        dec = Decimal(temp)
        dec = left.toReal().value - self.value * dec
        
        let real: RealNumber = RealNumber(val: dec )

        return real
    }

    public func pow(left: Number, isExponents: Bool) -> Number {
        var dec: Decimal
        dec = left.toReal().value

        let exp: Decimal = self.value

        if dec.isNaN || exp.isNaN { return Decimal.nan as! Number }
        else if exp == 0 { 
            dec = 1

            let real: RealNumber = RealNumber(val: dec )
            return  real
        }
        else if exp < 0 { 
            
            dec = 1 / left.pow(left: RealNumber(val: exp * -1), isExponents: true).toReal().value
            
            let real: RealNumber = RealNumber(val: dec )
            return real
        }

        // Separate Integer and Decimal
        let integer: Decimal = floor(decimal: exp)
        let decimal: Decimal = exp - integer

        // Calculate Integer Part
        let intX: Int = (integer as NSNumber).intValue
        if !integer.isZero && intX == 0 { return Decimal.nan as! Number }
        let intRes: Decimal = Foundation.pow(dec, intX)

        // Calculate Decimal Part
        let temp: Decimal = ln(isExponents: isExponents).toReal().value
        let decRes: Decimal = myexp(decimal: (decimal * temp))

        // Merge
        dec = intRes * decRes

        let real: RealNumber = RealNumber(val: dec )
        return real
    }

    public func negate(isExponents: Bool) -> Number {
        var dec: Decimal
        
        dec = self.value * -1

        let real: RealNumber = RealNumber(val: dec )
        return real
    }

    public func abs(isExponents: Bool) -> Number {
        var dec: Decimal
 
        dec = self.value
        dec = dec < 0 ? -dec : dec

        let real: RealNumber = RealNumber(val: dec )
     
        return real
    }

    public func sqrt(isExponents: Bool) -> Number {
        var dec: Decimal     
        dec = self.value

        if dec.isNaN || dec < 0 { return RealNumber(val: Decimal.nan) }
        let dbl: Double = (dec as NSNumber).doubleValue
        if dbl.isNaN { return RealNumber(val: Decimal.nan) }

        let temp: Decimal = Decimal(Foundation.sqrt(dbl))
        dec = newton(f_df: {($0 * $0 - dec) / (2 * $0)}, estimate: temp)

        let real: RealNumber = RealNumber(val: dec )
      
        return real
    }

    public func sin(isExponents: Bool) -> Number {
        let two_pi: Decimal = Decimal.pi * 2
        let pi_two: Decimal = Decimal.pi / 2
        var dec: Decimal     
        dec = self.value

        var angle: Decimal = nomalizeRadian(decimal: dec)
        var sign: Decimal = 1
        if pi_two < angle && angle <= .pi { angle = Decimal.pi - angle }
        else if Decimal.pi < angle && angle <= pi_two * 3 { angle -= Decimal.pi; sign = -1 }
        else if pi_two * 3 < angle { angle = two_pi - angle; sign = -1 }

        let square: Decimal = mul(decimal: angle,y: angle)
        var coef: Decimal = angle
        var coefs: [Decimal] = [coef]
        for i: Int in 1...19 {
            coef = mul(decimal: coef,y: -square / Decimal(2 * i * (2 * i + 1)))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let res: Decimal = coefs.reversed().reduce(0, { $0 + $1 })
        dec =  res * sign

        let real: RealNumber = RealNumber(val: dec)
        return real
    }

    public func cos(isExponents: Bool) -> Number {
        let pi_two: Decimal = Decimal.pi / 2
        let two_pi: Decimal = Decimal.pi * 2
        var dec: Decimal     
        dec = self.value

        var angle: Decimal = nomalizeRadian(decimal: dec)
        var sign: Decimal = 1
        if pi_two < angle && angle <= Decimal.pi { angle = Decimal.pi - angle; sign = -1 }
        else if Decimal.pi < angle && angle <= pi_two * 3 { angle -= Decimal.pi; sign = -1 }
        else if pi_two * 3 < angle { angle = two_pi - angle}

        let square: Decimal = mul(decimal: angle,y: angle)
        var coef: Decimal = 1
        var coefs: [Decimal] = [coef]
        for i: Int in 1...19 {
            coef = mul(decimal: coef,y: -square / Decimal((2 * i - 1) * 2 * i))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let res: Decimal = coefs.reversed().reduce(0, { $0 + $1 })
        dec =  res * sign

        let real: RealNumber = RealNumber(val: dec)
        return real
    }

    public func tan(isExponents: Bool) -> Number {
        var real: RealNumber = RealNumber(val: self.value)
        var dec: Decimal

        dec = real.sin(isExponents: isExponents).toReal().value / real.cos(isExponents: isExponents).toReal().value

        real = RealNumber(val: dec)
  
        return real
    }

    public func arcsin(isExponents: Bool) -> Number {
        let dbl: Double = (self.value as NSNumber).doubleValue
        let real: RealNumber = RealNumber( val: Decimal(Foundation.asin(dbl)))
      
        return real
    }

    public func arccos(isExponents: Bool) -> Number {
        let dbl: Double = (self.value as NSNumber).doubleValue
        let real: RealNumber = RealNumber( val: Decimal(Foundation.acos(dbl)))
   
        return real
    }

    public func arctan(isExponents: Bool) -> Number {
        let dbl: Double = (self.value as NSNumber).doubleValue
        let real: RealNumber = RealNumber( val: Decimal(Foundation.atan(dbl)))
 
        return real
    }
 
    public func log(isExponents: Bool) -> Number {
        let real: RealNumber = RealNumber(val: mylog(base: 10, decimal: self.value))
   
        return real
    }

    public func ln(isExponents: Bool) -> Number {
        let e: Decimal = Decimal(string: "2.71828182845904523536028747135266249776")!

        let real: RealNumber = RealNumber(val: mylog(base: e, decimal: self.value))
       
        return real
    }

    public static func parse(_ source: String) -> Token? {
        let myDouble: Double = (source as NSString).doubleValue
        if Double(source) == nil{
            return nil
        }
        
        return RealNumber(val: Decimal( myDouble))
    }

    public static func deserialize(_ source: String) -> Token? {
        let myDouble: Double = (source as NSString).doubleValue
        if Double(source) == nil{
            return nil
        }
        
        return RealNumber(val: Decimal( myDouble))
    }

    public func toDisplayString() -> String {
        let dbl: Double = (self.value as NSNumber).doubleValue
        let str: String = String(dbl)
        return str
    }

    public func serialize() -> String {
        let dbl: Double = (self.value as NSNumber).doubleValue
        let str: String = String(dbl)
        return str
    }

    private func abso(decimal: Decimal)-> Decimal{
        return decimal < 0 ? -decimal : decimal
    }

    private func mul(decimal: Decimal, y: Decimal) -> Decimal {
        let r: Decimal = decimal * y
        if abso(decimal: decimal) < 1 && abso(decimal: y) < 1 && abso(decimal: r) >= 1 {
            return .nan
        }

        return r
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
            coef = mul(decimal: coef,y: decimal / Decimal(i))
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
                number = mul(decimal: number, y: number)
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
