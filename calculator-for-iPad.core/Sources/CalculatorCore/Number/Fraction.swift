import Foundation

internal struct Fraction: Number {
    public let tokenType: TokenType = .number
    public var isInteger: Bool { return denominator == 1}
    
    private let numerator: Int
    private let denominator: Int
    private var isZero: Bool { return numerator == 0 }
    private static var zero: Fraction { return Fraction(numerator: 0, denominator: 1)! }

    init?(numerator: Int, denominator: Int) {
        guard let t = Fraction.normalize(numerator: numerator, denominator: denominator) else {
            return nil
        }
        (self.numerator, self.denominator) = t
    }

    private static func normalize(numerator: Int, denominator: Int) -> (Int, Int)? {
        if numerator == Int.min || denominator == Int.min {
            return nil
        }
        var numerator = numerator
        var denominator = denominator
        if denominator < 0 {
            numerator = -numerator
            denominator = -denominator
        }
        if numerator == 0 {
            return (0, 1)
        } else if denominator == 0 || denominator == 1 {
            return (numerator, 1)
        }

        var temp = 0
        var tempNum = numerator < 0 ? -numerator: numerator
        var tempDeno = denominator
        while tempDeno != 0 {
            temp = tempDeno
            tempDeno = tempNum % tempDeno
            tempNum = temp
        }

        return (numerator / tempNum, denominator / tempNum)
    }

    private func lcm(x: Int, y: Int) -> (lcm: Int?, xMultiply: Int, yMultiply: Int) {
        if x == Int.min || y == Int.min {
            return (nil, 0, 0)
        }
        let xabs = x < 0 ? -x : x
        let yabs = y < 0 ? -y : y
        
        var temp = 0
        var tempX = xabs
        var tempY = yabs
        while tempY != 0 {
            temp = tempY
            tempY = tempX % tempY
            tempX = temp
        }

        temp = xabs / tempX
        let (lcm,  isOverflow) = temp.multiply(by: tempY)
        if isOverflow {
            return (nil, 0, 0)
        } else {
            return (lcm, yabs / tempX, temp)
        }
    }

    public func toReal() -> Number {
        return NanValue()
    }

    func add(left: Number, isExponents: Bool) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().add(left: left, isExponents: isExponents)
        }

        let (lcm, xMultiply, yMultiply) = lcm(x: denominator, y: leftFrac.denominator)
        guard let lcm else {
            return NanValue()
        }
        var isOverflow: Bool
        let l: Int
        (l, isOverflow) = leftFrac.numerator.multiply(by: xMultiply)
        if isOverflow {
            return NanValue()
        }
        let r: Int
        (r, isOverflow) = numerator.multiply(by: yMultiply)
        if isOverflow {
            return NanValue()
        }
        let n: Int
        (n, isOverflow) = l.add(r)
        if isOverflow {
            return NanValue()
        }
        guard let result = Fraction(numerator: n, denominator: lcm) else {
            return NanValue()
        }
        return result
    }

    func substract(left: Number, isExponents: Bool) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().substract(left: left, isExponents: isExponents)
        }

        let (lcm, xMultiply, yMultiply) = lcm(x: denominator, y: leftFrac.denominator)
        guard let lcm else {
            return NanValue()
        }
        var isOverflow: Bool
        let l: Int
        (l, isOverflow) = leftFrac.numerator.multiply(by: xMultiply)
        if isOverflow {
            return NanValue()
        }
        let r: Int
        (r, isOverflow) = numerator.multiply(by: yMultiply)
        if isOverflow {
            return NanValue()
        }
        let n: Int
        (n, isOverflow) = l.substract(r)
        if isOverflow {
            return NanValue()
        }
        guard let result = Fraction(numerator: n, denominator: lcm) else {
            return NanValue()
        }
        return result
    }

    func multiply(left: Number, isExponents: Bool) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().multiply(left: left, isExponents: isExponents)
        }

        let (result, isOverflow) = multiply(leftFrac)
        return isOverflow ? NanValue() : result
    }

    private func multiply(_ leftFrac: Fraction) -> (Fraction, Bool) {
        var isOverflow: Bool
        let n: Int
        (n, isOverflow) = leftFrac.numerator.multiply(by: numerator)
        if isOverflow {
            return (Fraction.zero, true)
        }
        let d: Int
        (d, isOverflow) = leftFrac.denominator.multiply(by: denominator)
        if isOverflow {
            return (Fraction.zero, true)
        }
        guard let result = Fraction(numerator: n, denominator: lcm) else {
            return NanValue()
        }
        return result
    }

    func divide(left: Number, isExponents: Bool) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().multiply(left: left, isExponents: isExponents)
        }

        var isOverflow: Bool
        let n: Int
        (n, isOverflow) = leftFrac.numerator.multiply(by: denominator)
        if isOverflow {
            return NanValue()
        }
        let d: Int
        (d, isOverflow) = leftFrac.denominator.multiply(by: numerator)
        if isOverflow {
            return NanValue()
        }
        guard let result = Fraction(numerator: n, denominator: lcm) else {
            return NanValue()
        }
        return result
    }

    func modulus(left: Number, isExponents: Bool) -> Number {
        return toReal().modulus(left: left, isExponents: isExponents)
    }

    func pow(left: Number, isExponents: Bool) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().pow(left: left, isExponents: isExponents)
        }

        if numerator == 0 {
            return Fraction(numerator: 1, denominator: 1)!
        } else if isInteger {
            var isOverflow: Bool = false
            var ans: Fraction = Fraction(numerator: 1, denominator: 1)!
            var x = numerator < 0 ? Fraction(numerator: leftFrac.denominator, denominator: leftFrac.numerator)! : leftFrac
            if numerator == Int.min {
                return NanValue()
            }
            var y = numerator < 0 ? -numerator : numerator
            while y > 0 {
                if (y & 1) != 0 {
                    (ans, isOverflow) = ans.multiply(x)
                    if isOverflow {
                        return NanValue()
                    }
                }

                (x, isOverflow) = x.multiply(x)
                if isOverflow {
                    return NanValue()
                }
                y >>= 1
            }
        } else {
            // TODO うまく整数にできるときはする
        }
    }

    func negate(isExponents: Bool) -> Number {
        
    }

    func abs(isExponents: Bool) -> Number {
        
    }

    func sqrt(isExponents: Bool) -> Number {
        
    }

    func sin(isExponents: Bool) -> Number {
        
    }

    func cos(isExponents: Bool) -> Number {
        
    }

    func tan(isExponents: Bool) -> Number {
        
    }

    func arcsin(isExponents: Bool) -> Number {
        
    }

    func arccos(isExponents: Bool) -> Number {
        
    }

    func arctan(isExponents: Bool) -> Number {
        
    }

    func log(isExponents: Bool) -> Number {
        
    }

    func ln(isExponents: Bool) -> Number {
        
    }

    static func parse(_ source: String) -> Token? {
        
    }

    static func deserialize(_ source: String) -> Token? {
        
    }

    func toDisplayString() -> String {
        
    }

    func serialize() -> String {

    }

    
}

fileprivate extension Int {
    func add(_ other: Int) -> (Int, Bool) {
        return self.addingReportingOverflow(other)
    }

    func substract(_ other: Int) -> (Int, Bool) {
        return self.subtractingReportingOverflow(other)
    }

    func multiply(by other: Int) -> (Int, Bool) {
        return self.multipliedReportingOverflow(by: other)
    }

    func divide(by other: Int) -> (Int, Bool) {
        return self.dividedReportingOverflow(by: other)
    }
}