internal protocol BinaryOperator : Token {
    var identifier: String { get }

    func execute(left: Number, right: Number, isExponents: Bool) -> Number
}

enum BinaryOprType {
    case add
    case substract
    case multiply
    case divide
    case modulus
    case power
}
protocol Number { 
    func add(left: Number, isExponents: Bool) -> Number
}
