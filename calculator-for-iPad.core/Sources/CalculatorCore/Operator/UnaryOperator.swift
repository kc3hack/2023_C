internal protocol UnaryOperator: Operator {
    var identifier: String { get }
    
    func execute(value: Number, isExponents: Bool) -> Number
}
