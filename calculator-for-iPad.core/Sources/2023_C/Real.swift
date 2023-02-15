import Foundation

public struct NumberReal: Number{

    public var isInteger: Bool
    var value: Decimal
    private static let e: Decimal = Decimal(string: "2.71828182845904523536028747135266249776")!
    private static let two_pi: Decimal = Decimal.pi * 2
    private static let pi_two: Decimal = Decimal.pi / 2

    init() {
        self.isInteger = false
        self.value = 0
    }


    init(isExponents: Bool, val: Decimal) {
        self.isInteger = isExponents
        self.value = val
    }


    public func toReal() -> NumberReal{
        return self
    }


    public func add(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents

        real.value = self.value + left.toReal().value
        return real
    }

    public func substract(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents

        real.value = self.value - left.toReal().value
        return real
    }

    public func multiply(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents

        real.value =  mul(decimal: self.value, y: left.toReal().value)
        return real
    }

    public func divide(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents

        real.value = self.value / left.toReal().value
        return real
    }

    public func modulus(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents

        //商の計算
        real.value = self.value / left.toReal().value
        //real.valueをIntに変換
        var rounded: Decimal = Decimal()
        NSDecimalRound(&rounded, &real.value, 0, .down)
        let temp: Int = (rounded as NSDecimalNumber).intValue
        //余りの計算
        real.value = Decimal(temp)
        real.value = self.value - real.value * left.toReal().value
        
        return real
    }

    public func pow(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.value = self.value
        real.isInteger = isExponents
        let exp: Decimal = left.toReal().value

        if real.value.isNaN || exp.isNaN { return Decimal.nan as! Number }
        else if exp == 0 { 
            real.value = 1
            return  real
        }
        else if exp < 0 { 
            
            let temp: Decimal = 1 / self.pow(left: NumberReal(isExponents: true, val: exp * -1), isExponents: true).toReal().value
            real.value = temp
            return real
        }

        // Separate Integer and Decimal
        let integer: Decimal = floor(decimal: exp)
        let decimal: Decimal = exp - integer

        // Calculate Integer Part
        let intX: Int = (integer as NSNumber).intValue
        if !integer.isZero && intX == 0 { return Decimal.nan as! Number }
        let intRes: Decimal = Foundation.pow(real.value, intX)

        // Calculate Decimal Part
        let temp: Decimal = ln(isExponents: isExponents).toReal().value
        let decRes: Decimal = myexp(decimal: (decimal * temp))

        // Merge
        real.value = intRes * decRes
        return real
    }

    public func negate(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents

        real.value = self.value * -1
        
        return real
    }

    public func abs(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents

        real.value = self.value
        real.value = real.value < 0 ? -real.value : real.value

        return real
    }

    public func sqrt(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        if real.value.isNaN || real.value < 0 { return Decimal.nan as! Number }

        let dbl: Double = (real.value as NSNumber).doubleValue
        if dbl.isNaN { return Decimal.nan as! Number }

        let temp: Decimal = Decimal(Foundation.sqrt(dbl))
        real.value = newton(f_df: {($0 * $0 - real.value) / (2 * $0)}, estimate: temp)
        return real
    }

    public func sin(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        var angle: Decimal = nomalizeRadian(decimal: real.value)
        var sign: Decimal = 1
        if NumberReal.pi_two < angle && angle <= .pi { angle = Decimal.pi - angle }
        else if Decimal.pi < angle && angle <= NumberReal.pi_two * 3 { angle -= Decimal.pi; sign = -1 }
        else if NumberReal.pi_two * 3 < angle { angle = NumberReal.two_pi - angle; sign = -1 }

        let square: Decimal = mul(decimal: angle,y: angle)
        var coef: Decimal = angle
        var coefs: [Decimal] = [coef]
        for i: Int in 1...19 {
            coef = mul(decimal: coef,y: -square / Decimal(2 * i * (2 * i + 1)))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let res: Decimal = coefs.reversed().reduce(0, { $0 + $1 })
        real.value =  res * sign
        return real
    }

    public func cos(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        var angle: Decimal = nomalizeRadian(decimal: real.value)
        var sign: Decimal = 1
        if NumberReal.pi_two < angle && angle <= Decimal.pi { angle = Decimal.pi - angle; sign = -1 }
        else if Decimal.pi < angle && angle <= NumberReal.pi_two * 3 { angle -= Decimal.pi; sign = -1 }
        else if NumberReal.pi_two * 3 < angle { angle = NumberReal.two_pi - angle}

        let square: Decimal = mul(decimal: angle,y: angle)
        var coef: Decimal = 1
        var coefs: [Decimal] = [coef]
        for i: Int in 1...19 {
            coef = mul(decimal: coef,y: -square / Decimal((2 * i - 1) * 2 * i))
            if coef.isNaN { break }
            coefs.append(coef)
        }
        let res: Decimal = coefs.reversed().reduce(0, { $0 + $1 })
        real.value =  res * sign
        return real
    }

    public func tan(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        real.value = real.sin(isExponents: isExponents).toReal().value / real.cos(isExponents: isExponents).toReal().value

        return real
    }

    public func arcsin(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        let dbl: Double = (self.value as NSNumber).doubleValue
        real.value = Decimal(Foundation.asin(dbl))
        return real
    }

    public func arccos(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        let dbl: Double = (real.value as NSNumber).doubleValue
        real.value = Decimal(Foundation.acos(dbl))
        return real
    }

    public func arctan(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        let dbl: Double = (self.value as NSNumber).doubleValue
        real.value = Decimal(Foundation.atan(dbl))
        return real
    }
 
    public func log(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        real.value = mylog(base: 10, decimal: self.value)
        return real
    }

    public func ln(isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.isInteger = isExponents
        real.value = self.value

        real.value = mylog(base: NumberReal.e, decimal: self.value)
        return real
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
        if decimal.isNaN { return Decimal.nan }
        else if decimal == 0 { return 1 }
        else if decimal < 0 { return 1 / myexp(decimal: -decimal) }

        // Separate Integer and Decimal
        let integer: Decimal = floor(decimal: decimal)
        let decimal: Decimal = decimal - integer

        // Calculate Integer Part
        let intX: Int = (integer as NSNumber).intValue
        if !integer.isZero && intX == 0 { return Decimal.nan }
        let intRes: Decimal = Foundation.pow(NumberReal.e, intX)

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
