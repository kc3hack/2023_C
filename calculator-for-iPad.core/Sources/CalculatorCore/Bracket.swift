public enum Bracket: Operator {
    /// (
    case left
    /// )
    case right

    public var tokenType: TokenType { return .bracket }
    public var priority: Int { return Int.min }

    public static func parse(_ source: String) -> Token? {
        switch source {
            case "(":
                return Bracket.left
            case ")":
                return Bracket.right
            default:
                return nil
        }
    }

    public func toDisplayString() -> String {
        switch self {
            case .left:
                return "("
            case .right:
                return ")"
        }
    }

    public static func deserialize(_ source: String) -> Token? {
        return parse(source)
    }

    public func serialize() -> String {
        return toDisplayString()
    }
}