internal protocol UnaryOperator: Token {
    var identifier: String { get }
    
    func execute(value: Number, isExponents: Bool) -> Number
}
