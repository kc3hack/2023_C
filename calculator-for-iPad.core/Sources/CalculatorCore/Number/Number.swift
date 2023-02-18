public protocol Number: Token{
    var isInteger: Bool { get }
    var isZero: Bool { get }
    var isOne: Bool { get }
    var isNegativeOne: Bool { get }

    func toReal() -> RealNumber
    func add(left: Number) -> Number
    func substract(left: Number) -> Number
    func multiply(left: Number) -> Number
    func divide(left: Number) -> Number
    func modulus(left: Number) -> Number
    func pow(left: Number) -> Number
    func negate() -> Number
    func abs() -> Number
    func sqrt() -> Number
    func sin() -> Number
    func cos() -> Number
    func tan() -> Number
    func arcsin() -> Number
    func arccos() -> Number
    func arctan() -> Number
    func log() -> Number
    func ln() -> Number
}
