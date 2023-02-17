public struct Expression {
    public let rawExpression: String
    private let tokens: [Token]
    private var result: Number?

    /// 式を作成します
    /// - Parameter tokens: 1+2*3 は [1 2 3 * +] のように並べてください
    public init(rawExpression: String, tokens: [Token]) {
        self.rawExpression = rawExpression
        self.tokens = tokens
        result = nil
    }

    public mutating func execute() -> Number {
        if let result {
            return result
        }

        var tempNumbers: [Number] = []
        for token in tokens {
            switch token.tokenType {
                case .number:
                    guard let num = token as? Number else {
                        result = NanValue()
                        return result!
                    }
                    tempNumbers.append(num)
                case .unaryOperator:
                    let value = tempNumbers.popLast()
                    guard let opr = token as? UnaryOperator, let value else {
                        result = NanValue()
                        return result!
                    }
                    tempNumbers.append(opr.execute(value: value))
                case .binaryOperator:
                    let right = tempNumbers.popLast()
                    let left = tempNumbers.popLast()
                    guard let opr = token as? BinaryOperator, let right, let left else {
                        result = NanValue()
                        return result!
                    }
                    tempNumbers.append(opr.execute(left: left, right: right))
                case .customArgument:
                    result = NanValue()
                    return result!
                case .bracket:
                    result = NanValue()
                    return result!
            }
        }

        if tempNumbers.count == 1 {
            result = tempNumbers[0]
            return result!
        } else {
            result = NanValue()
            return result!
        }
    }

    /// シリアライズする
    /// - Returns: (expression: 式, result: 結果) 計算に失敗していたらnil
    public mutating func serialize() -> (expression: String, result: String)? {
        let result = execute()
        if result.toDisplayString() == "" {
            return nil
        }
        return (expression: rawExpression, result: result.toReal().toDisplayString())
    }
}
