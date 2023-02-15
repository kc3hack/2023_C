public struct CustomArgument: Token {
    public let tokenType: TokenType = .customArgument
    public var value: Number? = nil
    public let identifier: String

    init(identifier: String) {
        self.identifier = identifier
    }

    public static func parse(_ source: String) -> Token? {
        return CustomArgument(identifier: source)
    }

    public static func deserialize(_ source: String) -> Token? {
        return CustomArgument(identifier: source)
    }

    public func toDisplayString() -> String {
        return identifier
    }

    public func serialize() -> String {
        return identifier
    }
}