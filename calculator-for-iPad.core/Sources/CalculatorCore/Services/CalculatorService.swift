public class CalculatorService: PCalculatorService {
    public init(){}
    
    public func calculate(rawExpression: String) -> Number {
        var e = parse(rawExpression: rawExpression)
        return e.execute()
    }

    public func parse(rawExpression: String) -> Expression {
        return Expression(rawExpression: ["[String]"], tokens: [NanValue()])
    }

    private func infix2polish(expression: [Token]) -> [Token]? {
        var stack: [Operator] = []
        var result: [Token] = []
        for token in expression {
            switch token.tokenType {
                case .number:
                    result.append(token)
                case .unaryOperator:
                    guard let opr = token as? NativeUnaryOperator else {
                        return nil
                    }

                    stack.append(opr)
                case .binaryOperator:
                    guard let opr = token as? NativeBinaryOperator else {
                        return nil
                    }

                    // その演算子より優先度の高いものをすべて全てresultに積む
                    while !stack.isEmpty {
                        let last = stack.last!

                        if last.priority > opr.priority {
                            result.append(stack.popLast()!)
                            continue
                        } else {
                            break
                        }
                    }

                    stack.append(opr)
                case .bracket:
                    guard let bracket = token as? Bracket else {
                        return nil
                    }
                    
                    if bracket == .left {
                        stack.append(bracket)
                    } else {
                        while !stack.isEmpty {
                            let last = stack.popLast()!
                            if let b = last as? Bracket, b == .left {
                                break
                            } else {
                                result.append(last)
                            }
                        }
                    }
                case .customArgument:
                    return nil
            }
        }

        while !stack.isEmpty {
            let last = stack.popLast()!
            // この時点でbracketが残っているのはおかしい
            if last.tokenType == .bracket {
                return nil
            } else {
                result.append(last)
            }
        }

        return result
    }
}
