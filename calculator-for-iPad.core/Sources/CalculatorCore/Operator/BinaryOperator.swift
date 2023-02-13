internal protocol BinaryOperator: Token {
    var identifier: String { get }

    func execute(left: Number, right: Number, isExponents: Bool) -> Number
}
