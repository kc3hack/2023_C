public protocol Number{
    var isInteger: Bool { get }

    func toReal() -> NumberReal
    func add(left: Number ,isExponents: Bool) -> Number
    func substract(left: Number ,isExponents: Bool) -> Number
    func multiply(left: Number ,isExponents: Bool) -> Number
    func divide(left: Number ,isExponents: Bool) -> Number
    func modulus(left: Number ,isExponents: Bool) -> Number
    func pow(left: Number ,isExponents: Bool) -> Number
    func negate(isExponents: Bool) -> Number
    func abs(isExponents: Bool) -> Number
    func sqrt(isExponents: Bool) -> Number
    func sin(isExponents: Bool) -> Number
    func cos(isExponents: Bool) -> Number
    func tan(isExponents: Bool) -> Number
    func arcsin(isExponents: Bool) -> Number
    func arccos(isExponents: Bool) -> Number
    func arctan(isExponents: Bool) -> Number
    func log(isExponents: Bool) -> Number
    func ln(isExponents: Bool) -> Number
}