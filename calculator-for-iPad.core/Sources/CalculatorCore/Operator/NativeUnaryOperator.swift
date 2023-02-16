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
    public static let identifiers: [String] = ["abs", "√", "sin", "cos", "tan", "arcsin", "arccos", "arctan", "log", "ln"]
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
    public var priority: Int {
        return Int.max
    }
    
    public func execute(value: Number, isExponents: Bool) -> Number {
        switch self {
            case .negate:
                return value.negate(isExponents: isExponents)
            case .abs:
                return value.abs(isExponents: isExponents)
            case .sqrt:
                return value.sqrt(isExponents: isExponents)
            case .sin:
                return value.sin(isExponents: isExponents)
            case .cos:
                return value.cos(isExponents: isExponents)
            case .tan:
                return value.tan(isExponents: isExponents)
            case .arcsin:
                return value.arcsin(isExponents: isExponents)
            case .arccos:
                return value.arccos(isExponents: isExponents)
            case .arctan:
                return value.arctan(isExponents: isExponents)
            case .log:
                return value.log(isExponents: isExponents)
            case .ln:
                return value.ln(isExponents: isExponents)
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
