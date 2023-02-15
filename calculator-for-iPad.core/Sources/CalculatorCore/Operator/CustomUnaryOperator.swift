internal struct CustomUnaryOperator: UnaryOperator {
    public let tokenType: TokenType = .unaryOperator
    public let identifier: String
    private let function: [Token]
    
    init(identifier: String, function: [Token]) {
        self.identifier = identifier
        self.function = function
    }

    public func execute(value: Number, isExponents: Bool) -> Number {
        guard function.count > 0 else {
            return nil
        }
        var tempNumbers: [Number] = []
        var exponentsRank = 0
        for i in 0...function.count {
            let first: Token = function[i]

            switch first.tokenType {
                case .number:
                    guard let num = first as? Number else {
                        return nil
                    }
                    tempNumbers.append(num)
                case .unaryOperator:
                    let value = tempNumbers.popLast()
                    guard let opr = first as? UnaryOperator, let value else {
                        return nil
                    }
                    tempNumbers.append(opr.execute(value: value, isExponents: exponentsRank != 0))
                case .binaryOperator:
                    let left = tempNumbers.popLast()
                    let right = tempNumbers.popLast()
                    guard let opr = first as? BinaryOperator, let right, let left else {
                        return nil
                    }
                    if let nopr = opr as? NativeBinaryOperator, nopr.operatorType == .pow {
                        tempNumbers.append(nopr.execute(left: left, right: right.toReal(), isExponents: false))
                    }else {
                        tempNumbers.append(opr.execute(left: left, right: right, isExponents: false))
                    }
                case .customArgument:
                    tempNumbers.append(value)
            }
        }

        if tempNumbers.count == 1 {
            return tempNumbers[0]
        } else {
            return nil
        }
    }
    
    static func parse(_ source: String) -> Token? {
        return nil
    }

    static func deserialize(_ source: String) -> Token? {
        return nil
    }

    func toDisplayString() -> String {
        return identifier
    }

    func serialize() -> String {
        return identifier
    }
}