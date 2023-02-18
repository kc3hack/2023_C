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

    internal func lcm(x: Int, y: Int) -> (lcm: Int?, xMultiply: Int, yMultiply: Int) {
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
        let (lcm,  isOverflow) = temp.multiply(by: yabs)
        if isOverflow {
            return (nil, 0, 0)
        } else {
            return (lcm, yabs / tempX, temp)
        }
    }

    public func toReal() -> RealNumber {
        return RealNumber(val: Decimal(numerator) / Decimal(denominator))
    }

    func add(left: Number) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().add(left: left)
        }

        let (lcm, xMultiply, yMultiply) = lcm(x: leftFrac.denominator, y: denominator)
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

    func substract(left: Number) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().substract(left: left)
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

    func multiply(left: Number) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().multiply(left: left)
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
        guard let result = Fraction(numerator: n, denominator: d) else {
            return (Fraction.zero, true)
        }
        return (result, false)
    }

    func divide(left: Number) -> Number {
        if left is NanValue || isZero {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().multiply(left: left)
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
        guard let result = Fraction(numerator: n, denominator: d) else {
            return NanValue()
        }
        return result
    }

    func modulus(left: Number) -> Number {
        return toReal().modulus(left: left)
    }

    func pow(left: Number) -> Number {
        if left is NanValue {
            return NanValue()
        }
        guard let leftFrac = left as? Fraction else {
            return toReal().pow(left: left)
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
            return ans
        } else {
            var num = Foundation.pow(Double(leftFrac.numerator), Double(1) / Double(denominator))
            var deno = Foundation.pow(Double(leftFrac.denominator), Double(1) / Double(denominator))

            guard Double(Int(num)) == num && Double(Int(deno)) == deno else {
                return toReal().pow(left: left)
            }
            
            let absedNumerator = numerator < 0 ? -numerator: numerator
            num = Foundation.pow(num, Double(absedNumerator))
            deno = Foundation.pow(deno, Double(absedNumerator))
            if let numInteger = Int(exactly: num), let denoInteger = Int(exactly: deno) {
                return numerator < 0 
                    ? Fraction(numerator: denoInteger, denominator: numInteger) ?? toReal().pow(left: left)
                    : Fraction(numerator: numInteger, denominator: denoInteger) ?? toReal().pow(left: left)
            } else {
                return toReal().pow(left: left)
            }
        }
    }

    func negate() -> Number {
        return Fraction(numerator: -numerator, denominator: denominator) ?? NanValue()
    }

    func abs() -> Number {
        return Fraction(numerator: numerator < 0 ? -numerator : numerator, denominator: denominator) ?? NanValue()
    }

    func sqrt() -> Number {
        let num = Foundation.sqrt(Double(numerator))
        let deno = Foundation.sqrt(Double(denominator))
        if Double(Int(num)) == num && Double(Int(deno)) == deno {
            return Fraction(numerator: Int(num), denominator: Int(deno)) ?? NanValue()
        } else {
            return toReal().sqrt()
        }
    }

    func sin() -> Number {
        return toReal().sin()
    }

    func cos() -> Number {
        return toReal().cos()
    }

    func tan() -> Number {
        return toReal().tan()
    }

    func arcsin() -> Number {
        return toReal().arcsin()
    }

    func arccos() -> Number {
        return toReal().arccos()
    }

    func arctan() -> Number {
        return toReal().arctan()
    }

    func log() -> Number {
        return toReal().log()
    }

    func ln() -> Number {
        return toReal().ln()
    }

    static func parse(_ source: String) -> Token? {
        let integer = Int(source)
        if let integer {
            return Fraction(numerator: integer, denominator: 1) ?? NanValue()
        }

        let decimal = Decimal(string: source)
        if let decimal {
            let isNegativeExponent = decimal.exponent < 0
            var exponent = isNegativeExponent ? -decimal.exponent : decimal.exponent

            // 10^exponent の導出
            var ans = 1
            var base = 10
            while exponent > 0 {
                if (exponent & 1) != 0 {
                    let isOverflow: Bool
                    (ans, isOverflow) = ans.multiply(by: base)
                    if isOverflow {
                        return nil
                    }
                }

                let isOverflow: Bool
                (base, isOverflow) = base.multiply(by: base)
                if isOverflow {
                    return nil
                }
                exponent >>= 1
            }

            if isNegativeExponent {
                // decimal.significand / ans
                let numerator = NSDecimalNumber(decimal: decimal < 0 ? -decimal.significand : decimal.significand).intValue
                return Fraction(numerator: numerator, denominator: ans)
            } else {
                let significand = NSDecimalNumber(decimal: decimal.significand).intValue
                let (numerator, isOverflow) = significand.multiply(by: ans)
                if isOverflow {
                    return nil
                }
                return Fraction(numerator: numerator, denominator: 1)
            }
        }

        return nil
    }

    static func deserialize(_ source: String) -> Token? {
        return parse(source)
    }

    func toDisplayString() -> String {
        return isInteger ? "\(numerator)" : "\(numerator)/\(denominator)"
    }

    func serialize() -> String {
        return toDisplayString()
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
