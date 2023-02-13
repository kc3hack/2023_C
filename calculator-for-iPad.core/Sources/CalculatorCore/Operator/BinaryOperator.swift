internal protocol BinaryOperator: Token {
    var identifier: String { get }

    func execute(left: Number, right: Number, isExponents: Bool) -> Number
}

internal enum BinaryOprType {
    case add
    case substract
    case multiply
    case divide
    case modulus
    case pow
}
