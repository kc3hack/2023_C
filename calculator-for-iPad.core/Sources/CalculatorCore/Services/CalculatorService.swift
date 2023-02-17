public class CalculatorService: PCalculatorService {
    public func calculate(rawExpression: String) -> Number {
        var e = parse(rawExpression: rawExpression)
        return e.execute()
    }

    public func parse(rawExpression: String) -> Expression {
        return Expression(rawExpression: ["[String]"], tokens: [NanValue()])
    }

    private func parseString(rawExpression: String) -> [Token]? {
        var token: String = ""
        var tokenList: [String] = []
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
            }else {
                // state 1 => 数字に変換 失敗 nil
                // 受け取った文字列 => 演算子に変換できるか  => 変換できたらstate 0 tokenを""
                // state2 => tokenと合わせて変換
                // 変換できなかったらtokenに入れてstate2にする
                if(state == 1) { //トークンに数字が入っていたらここで吐き出し
                    guard (Double(token)!.truncatingRemainder(dividingBy: 1) >= 0) else { //数値であるか調べる
                        return nil
                    }
                    tokenList.append(token)
                    token = ""
                    state = 0
                }

                if(c == "+" && c == "-" && c == "*" && c == "/" && c == "^" && c == "√"/* && c == "(" && c == ")"*/) { //単項演算子(と括弧)用
                    tokenList.append(token)
                    token = ""
                    state = 0
                }
            }
        }
        if(token != "") { //末尾のトークンを吐き出し
            tokenList.append(token)
            token = ""
            state = 0
        }
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