internal struct NativeUnaryOperator: UnaryOperator {
    public let tokenType: TokenType = .unaryOperator
    public let identifier: String
    public let operatorType: UnaryOprType
    public static let identifiers: [String] = ["abs", "√", "sin", "cos", "tan", "arcsin", "arccos", "arctan", "log", "ln"]

    private init(identifier: String, operatorType: UnaryOprType) {
        self.identifier = identifier
        self.operatorType = operatorType
    }

    internal init(operatorType: UnaryOprType) {
        self.operatorType = operatorType
        switch operatorType {
            case .negate:
                identifier = "-"
            case .abs:
                identifier = "abs"
            case .sqrt:
                identifier = "√"
            case .sin:
                identifier = "sin"
            case .cos:
                identifier = "cos"
            case .tan:
                identifier = "tan"
            case .arcsin:
                identifier = "arcsin"
            case .arccos:
                identifier = "arccos"
            case .arctan:
                identifier = "arctan"
            case .log:
                identifier = "log"
            case .ln:
                identifier = "ln"
        }
    }

    public static func parse(_ source: String) -> Token? {
        switch source {
            case "abs":
                return NativeUnaryOperator(identifier: "abs", operatorType: .abs)
            case "√":
                return NativeUnaryOperator(identifier: "√", operatorType: .sqrt)
            case "sin":
                return NativeUnaryOperator(identifier: "sin", operatorType: .sin)
            case "cos":
                return NativeUnaryOperator(identifier: "cos", operatorType: .cos)
            case "tan":
                return NativeUnaryOperator(identifier: "tan", operatorType: .tan)
            case "arcsin":
                return NativeUnaryOperator(identifier: "arcsin", operatorType: .arcsin)
            case "arccos":
                return NativeUnaryOperator(identifier: "arccos", operatorType: .arccos)
            case "arctan":
                return NativeUnaryOperator(identifier: "arctan", operatorType: .arctan)
            case "log":
                return NativeUnaryOperator(identifier: "log", operatorType: .log)
            case "ln":
                return NativeUnaryOperator(identifier: "ln", operatorType: .ln)
            default:
                return nil
        }
    }

    public func toDisplayString() -> String {
        return identifier
    }

    public static func deserialize(_ source: String) -> Token? {
        switch source {
            case "abs":
                return NativeUnaryOperator(identifier: "abs", operatorType: .abs)
            case "sqrt":
                return NativeUnaryOperator(identifier: "√", operatorType: .sqrt)
            case "sin":
                return NativeUnaryOperator(identifier: "sin", operatorType: .sin)
            case "cos":
                return NativeUnaryOperator(identifier: "cos", operatorType: .cos)
            case "tan":
                return NativeUnaryOperator(identifier: "tan", operatorType: .tan)
            case "arcsin":
                return NativeUnaryOperator(identifier: "arcsin", operatorType: .arcsin)
            case "arccos":
                return NativeUnaryOperator(identifier: "arccos", operatorType: .arccos)
            case "arctan":
                return NativeUnaryOperator(identifier: "arctan", operatorType: .arctan)
            case "log":
                return NativeUnaryOperator(identifier: "log", operatorType: .log)
            case "ln":
                return NativeUnaryOperator(identifier: "ln", operatorType: .ln)
            default:
                return nil
        }
    }

    public func serialize() -> String {
        if operatorType == .sqrt {
            return "sqrt"
        }
        return identifier
    }
}

internal enum UnaryOprType {
    case negate
    case abs
    case sqrt
    case sin
    case cos
    case tan
    case arcsin
    case arccos
    case arctan
    case log
    case ln
}
