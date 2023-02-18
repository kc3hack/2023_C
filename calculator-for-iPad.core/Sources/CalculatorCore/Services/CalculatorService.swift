public class CalculatorService: PCalculatorService {
    public init(){}
    
    public func calculate(rawExpression: String) -> Number {
        var e = parse(rawExpression: rawExpression)
        return e.execute()
    }

    public func parse(rawExpression: String) -> Expression {
        let tokens = parseString(rawExpression: rawExpression)
        guard let tokens else {
            return Expression(rawExpression: rawExpression, tokens: [NanValue()])
        }
        let polishedTokens = infix2polish(expression: tokens)
        guard let polishedTokens else {
            return Expression(rawExpression: rawExpression, tokens: [NanValue()])
        }
        return Expression(rawExpression: rawExpression, tokens: polishedTokens)
    }

    public func parseString(rawExpression: String) -> [Token]? {
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
                    token.append(c)
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
                }
                if(state == 0) { //一文字の状態でチェック
                    token.append(c)
                    // eとπは数字として判定されないのでこっちで判定する
                    let operatorChara = Constant.parse(token)
                            ?? NativeBinaryOperator.parse(token)
                            ?? NativeUnaryOperator.parse(token)
                            ?? Bracket.parse(token)
                    if let operatorChara {
                        tokenList.append(operatorChara)
                        token = ""
                        state = 0
                    }else {
                        state = 2
                    }
                }else if(state == 2) { //複数文字の状態でチェック
                    token.append(c)
                    let operatorWord = NativeBinaryOperator.parse(token) ?? NativeUnaryOperator.parse(token)
                    if let operatorWord {
                        tokenList.append(operatorWord)
                        token = ""
                        state = 0
                    }
                }
            }
        }
        if(token != "") { //残っていたら末尾のトークンを吐き出し(出来なかったらnilを返す)
            if(state == 1) { //数字
                let number = Fraction.parse(token) ?? RealNumber.parse(token)
                if let number {
                    tokenList.append(number)
                }else {
                    return nil
                }
            }else { //文字
                let temp = Constant.parse(token)
                    ?? NativeBinaryOperator.parse(token)
                    ?? NativeUnaryOperator.parse(token)
                    ?? Bracket.parse(token)
                guard let temp else { //最後の文字が不正なものならnilを返して終了
                    return nil
                }
                tokenList.append(temp) //正常ならリストに追加
            }
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
