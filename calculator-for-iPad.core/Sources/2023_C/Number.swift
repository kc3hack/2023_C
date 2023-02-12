protocol Number{
    var IsInteger: Bool { get }

    func ToReal() -> Real
    func Add(left: Number ,isExponents: Bool) -> Number
    func Substract(left: Number ,isExponents: Bool) -> Number
    func Multiply(left: Number ,isExponents: Bool) -> Number
    func Divide(left: Number ,isExponents: Bool) -> Number
    func Modulus(left: Number ,isExponents: Bool) -> Number
    func Pow(left: Number ,isExponents: Bool) -> Number
    func Negate(isExponents: Bool) -> Number
    func Abs(isExponents: Bool) -> Number
    func Sqrt(isExponents: Bool) -> Number
    func Sin(isExponents: Bool) -> Number
    func Cos(isExponents: Bool) -> Number
    func Tan(isExponents: Bool) -> Number
    func Arcsin(isExponents: Bool) -> Number
    func Arccos(isExponents: Bool) -> Number
    func Arctan(isExponents: Bool) -> Number
    func Log(isExponents: Bool) -> Number
    func Ln(isExponents: Bool) -> Number
}