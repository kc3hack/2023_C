internal enum NativeBinaryOperator: BinaryOperator {
    case add
    case substract
    case multiply
    case divide
    case modulus
    case pow

    public var tokenType: TokenType { return .binaryOperator }
    public static let identifiers: [String] = ["+", "-", "*", "/", "mod", "^"]
    public var identifier: String {
        switch self {
            case .add:
                return "+"
            case .substract:
                return "-"
            case .multiply:
                return "*"
            case .divide:
                return "/"
            case .modulus:
                return "mod"
            case .pow:
                return "^"
        }
    }
    public var priority: Int {
        switch self {
            case .add:
                return 0
            case .substract:
                return 0
            case .multiply:
                return 1
            case .divide:
                return 1
            case .modulus:
                return 1
            case .pow:
                return 2
        }
    }
    
    public func execute(left: Number, right: Number, isExponents: Bool) -> Number {
        switch self {
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
                return NativeBinaryOperator.add
            case "-":
                return NativeBinaryOperator.substract
            case "*":
                return NativeBinaryOperator.multiply
            case "/":
                return NativeBinaryOperator.divide
            case "mod":
                return NativeBinaryOperator.modulus
            case "^":
                return NativeBinaryOperator.pow
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
