internal protocol BinaryOperator: Operator {
    var identifier: String { get }

    func execute(left: Number, right: Number) -> Number
}
