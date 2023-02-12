internal struct NativeBinaryOperator : BinaryOperator {
    public let tokenType: TokenType = .BinaryOperator
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
            case .power:
                identifier = "^"
        }
    }

    public func execute(left: Number, right: Number, isExponents: Bool) -> Number {
        return right.add(left: left, isExponents: isExponents)
    }

    public static func Parse(_ source: String) -> Token? {
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
                return NativeBinaryOperator("^", .power)
            default:
                return nil
        }
    }

    public func ToDisplayString() -> String {
        return identifier
    }

    public func Serialize() -> String {
        return identifier
    }

    public static func Deserialize(_ source: String) -> Token? {
        return Parse(source)
    }
}