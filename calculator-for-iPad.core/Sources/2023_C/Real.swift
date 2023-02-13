import Foundation

public struct NumberReal: Number{

    public var isInteger: Bool
    var value: Decimal


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
        real.value = self.value - left.toReal().value
        return real
    }

    public func multiply(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.value = self.value * left.toReal().value
        return real
    }

    public func divide(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.value = self.value / left.toReal().value
        return real
    }

    public func modulus(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()

        //商の計算
        real.value = self.value / left.toReal().value
        var rounded: Decimal = Decimal()
        NSDecimalRound(&rounded, &real.value, 0, .down)
        let tem: Int = (rounded as NSDecimalNumber).intValue
        //余りの計算
        real.value = Decimal(tem)
        real.value = self.value - real.value * left.toReal().value
        
        return real
    }

    public func pow(left: Number, isExponents: Bool) -> Number {
        var real: NumberReal = NumberReal()
        real.value = self.value + left.toReal().value
        return real
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
}

// func pow(left: Number, isExponents: Bool) -> Number {
//         var real: Real = Real()
//         real.value = self.value + left.toReal().value
//         return real
//     }

//     func negate(isExponents: Bool) -> Number {
//        return self
//     }

//     func abs(isExponents: Bool) -> Number {
//         return self
//     }

//     func sqrt(isExponents: Bool) -> Number {
//         return self
//     }

//     func sin(isExponents: Bool) -> Number {
//         return self
//     }

//     func cos(isExponents: Bool) -> Number {
//         return self
//     }

//     func tan(isExponents: Bool) -> Number {
//         return self
//     }

//     func arcsin(isExponents: Bool) -> Number {
//         return self
//     }

//     func arccos(isExponents: Bool) -> Number {
//         return self
//     }

//     func arctan(isExponents: Bool) -> Number {
//         return self
//     }

//     func log(isExponents: Bool) -> Number {
//         return self
//     }

//     func ln(isExponents: Bool) -> Number {
//         return self
//     }