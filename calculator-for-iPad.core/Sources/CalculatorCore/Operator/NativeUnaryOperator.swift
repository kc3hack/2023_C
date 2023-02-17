internal enum NativeUnaryOperator: UnaryOperator {
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

    public var tokenType: TokenType { return .unaryOperator }
    public var identifier: String {
        switch self {
            case .negate:
                return "-"
            case .abs:
                return "abs"
            case .sqrt:
                return "√"
            case .sin:
                return "sin"
            case .cos:
                return "cos"
            case .tan:
                return "tan"
            case .arcsin:
                return "arcsin"
            case .arccos:
                return "arccos"
            case .arctan:
                return "arctan"
            case .log:
                return "log"
            case .ln:
                return "ln"
        }
    }
    public static let identifiers: [String] = ["abs", "√", "sin", "cos", "tan", "arcsin", "arccos", "arctan", "log", "ln"]
    
    public func execute(value: Number) -> Number {
        switch self {
            case .negate:
                return value.negate()
            case .abs:
                return value.abs()
            case .sqrt:
                return value.sqrt()
            case .sin:
                return value.sin()
            case .cos:
                return value.cos()
            case .tan:
                return value.tan()
            case .arcsin:
                return value.arcsin()
            case .arccos:
                return value.arccos()
            case .arctan:
                return value.arctan()
            case .log:
                return value.log()
            case .ln:
                return value.ln()
        }
    }

    public static func parse(_ source: String) -> Token? {
        switch source {
            case "abs":
                return NativeUnaryOperator.abs
            case "√":
                return NativeUnaryOperator.sqrt
            case "sin":
                return NativeUnaryOperator.sin
            case "cos":
                return NativeUnaryOperator.cos
            case "tan":
                return NativeUnaryOperator.tan
            case "arcsin":
                return NativeUnaryOperator.arcsin
            case "arccos":
                return NativeUnaryOperator.arccos
            case "arctan":
                return NativeUnaryOperator.arctan
            case "log":
                return NativeUnaryOperator.log
            case "ln":
                return NativeUnaryOperator.ln
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
                return NativeUnaryOperator.abs
            case "sqrt":
                return NativeUnaryOperator.sqrt
            case "sin":
                return NativeUnaryOperator.sin
            case "cos":
                return NativeUnaryOperator.cos
            case "tan":
                return NativeUnaryOperator.tan
            case "arcsin":
                return NativeUnaryOperator.arcsin
            case "arccos":
                return NativeUnaryOperator.arccos
            case "arctan":
                return NativeUnaryOperator.arctan
            case "log":
                return NativeUnaryOperator.log
            case "ln":
                return NativeUnaryOperator.ln
            default:
                return nil
        }
    }

    public func serialize() -> String {
        if self == .sqrt {
            return "sqrt"
        }
        return identifier
    }
}
