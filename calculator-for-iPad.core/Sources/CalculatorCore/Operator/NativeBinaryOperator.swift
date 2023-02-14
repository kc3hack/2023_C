internal struct NativeBinaryOperator: BinaryOperator {
    public let tokenType: TokenType = .binaryOperator
    public let identifier: String
    public let operatorType: BinaryOprType
    public static let identifiers: [String] = ["+", "-", "*", "/", "%", "^"]

    private init(_ identifier: String, _ operatorType: BinaryOprType) {
        self.identifier = identifier
        self.operatorType = operatorType
    }
    public init(_ operatorType: BinaryOprType) {
        self.operatorType = operatorType
        switch operatorType {
            case .add:
                identifier = "+"
            case .substract:
                identifier = "-"
            case .multiply:
                identifier = "*"
            case .divide:
                identifier = "/"
            case .modulus:
                identifier = "%"
            case .pow:
                identifier = "^"
        }
    }

    public func execute(left: Number, right: Number, isExponents: Bool) -> Number {
        switch operatorType {
            case .add:
                return right.add(left: left, isExponents: isExponents)
            case .substract:
                return right.substract(left: left, isExponents: isExponents)
            case .multiply:
                return right.multiply(left: left, isExponents: isExponents)
            case .divide:
                return right.divide(left: left, isExponents: isExponents)
            case .modulus:
                return right.modulus(left: left, isExponents: isExponents)
            case .pow:
                return right.pow(left: left, isExponents: isExponents)
        }
    }

    public static func parse(_ source: String) -> Token? {
        switch source {
            case "+":
                return NativeBinaryOperator("+", .add)
            case "-":
                return NativeBinaryOperator("-", .substract)
            case "*":
                return NativeBinaryOperator("*", .multiply)
            case "/":
                return NativeBinaryOperator("/", .divide)
            case "%":
                return NativeBinaryOperator("%", .modulus)
            case "^":
                return NativeBinaryOperator("^", .pow)
            default:
                return nil
        }
    }

    public func toDisplayString() -> String {
        return identifier
    }

    public func serialize() -> String {
        return identifier
    }

    public static func deserialize(_ source: String) -> Token? {
        return parse(source)
    }
}

internal enum BinaryOprType {
    case add
    case substract
    case multiply
    case divide
    case modulus
    case pow
}