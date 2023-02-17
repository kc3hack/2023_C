public struct Expression {
    public let rawExpression: [String]
    private var tokens: [Token]
    private var result: Number?

    /// 式を作成します
    /// - Parameter tokens: 1+2*3 は [1 2 3 * +] のように並べてください
    public init(rawExpression: [String], tokens: [Token]) {
        self.rawExpression = rawExpression
        self.tokens = tokens
        result = nil
    }

    public mutating func execute() -> Number {
        if let result {
            return result
        }

        var tempNumbers: [Number] = []
        while !tokens.isEmpty {
            let first: Token? = tokens.removeFirst()
            
            guard let first else {
                result = NanValue()
                return result!
            }

            switch first.tokenType {
                case .number:
                    guard let num = first as? Number else {
                        result = NanValue()
                        return result!
                    }
                    tempNumbers.append(num)
                case .unaryOperator:
                    let value = tempNumbers.popLast()
                    guard let opr = first as? UnaryOperator, let value else {
                        result = NanValue()
                        return result!
                    }
                    tempNumbers.append(opr.execute(value: value))
                case .binaryOperator:
                    let left = tempNumbers.popLast()
                    let right = tempNumbers.popLast()
                    guard let opr = first as? BinaryOperator, let right, let left else {
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
}