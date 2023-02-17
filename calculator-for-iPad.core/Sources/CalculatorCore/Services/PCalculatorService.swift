public protocol PCalculatorService {
    func calculate(rawExpression: String) -> Number
    func parse(rawExpression: String) -> Expression
}