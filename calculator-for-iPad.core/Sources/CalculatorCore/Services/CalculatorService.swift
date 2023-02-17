public class CalculatorService: PCalculatorService {
    public func calculate(rawExpression: String) -> Number {
        var e = parse(rawExpression: rawExpression)
        return e.execute()
    }

    public func parse(rawExpression: String) -> Expression {
        return Expression(rawExpression: "[String]", tokens: [NanValue()])
    }

    private func parseString(rawExpression: String) -> [Token]? {
        var token: String = ""
        var tokenList: [Token] = []
        // 0: 受付中
        // 1: 数字を認識中
        // 2: 演算子を認識中
        var state = 0
        for c: Character in rawExpression {
            if c.isNumber || c == "." {
                // state 2 ならパース失敗
                // それ以外ならtokenに突っ込む
                // stateを1にする
                if(state == 2) {
                    return nil
                }else {
                    token += String(c)
                    state = 1
                }
            }else { //数字と小数点以外が来たら
                // state 1 => 数字に変換 失敗 nil
                // 受け取った文字列 => 演算子に変換できるか  => 変換できたらstate 0 tokenを""
                // state2 => tokenと合わせて変換
                // 変換できなかったらtokenに入れてstate2にする
                if(state == 1) { //トークンに数字が入っていたらここで吐き出し
                    let number = Fraction.parse(token) ?? RealNumber.parse(token)
                    if let number {
                        tokenList.append(number)
                        token = ""
                        state = 0
                    }else {
                        return nil
                    }
                }else if(state == 0) {
                    token += String(c)
                    let operatorChara = NativeBinaryOperator.parse(token) ?? NativeUnaryOperator.parse(token)
                    if let operatorChara {
                        tokenList.append(operatorChara)
                        token = ""
                        state = 0
                    }else {
                        token += String(c)
                        state = 2
                    }
                }else if(state == 2) {
                    token += String(c)
                    let operatorWord = NativeBinaryOperator.parse(token) ?? NativeUnaryOperator.parse(token)
                    if let operatorWord {
                        tokenList.append(operatorWord)
                        token = ""
                        state = 0
                    }else {
                        //
                    }
                }
            }
        }
        if(token != "") { //末尾のトークンを吐き出し
            let temp = NativeBinaryOperator.parse(token)
                ?? NativeUnaryOperator.parse(token)
                ?? Bracket.parse(token)
            guard let temp else {
                return nil
            }
            tokenList.append(temp)
        }
        return tokenList
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