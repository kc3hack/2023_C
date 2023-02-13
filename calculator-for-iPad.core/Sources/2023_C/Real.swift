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
        real.isInteger = isExponents

        //real.valueをIntに変換
        var rounded: Decimal = Decimal()
        var lefttemp: Decimal = left.toReal().value
        NSDecimalRound(&rounded, &lefttemp, 0, .down)
        let temp: Int = (rounded as NSDecimalNumber).intValue

        real = self
        for _ in 1...temp - 1{
            real.value *= self.value
        }
        
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
        return self
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
}
