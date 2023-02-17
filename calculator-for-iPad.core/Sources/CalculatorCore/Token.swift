public protocol Token {
    /// トークンの型
    var tokenType: TokenType { get }

    /// 文字列をトークンに変換します
    /// - Parameters:
    ///   - source: もととなる文字列
    /// - Returns: 文字列が表すトークン
    static func parse(_ source: String) -> Token?

    /// シリアライズ文字列をトークンに変換します
    /// - Parameters:
    ///   - source: シリアライズ文字列
    /// - Returns: シリアライズ文字列が表すトークン 変換に失敗したときnil
    static func deserialize(_ source: String) -> Token?

    /// 表示に使う文字列を返します
    func toDisplayString() -> String

    /// シリアライズした文字列を返します
    func serialize() -> String
}

/// トークンの型
public enum TokenType {
    case number
    case bracket
    case unaryOperator
    case binaryOperator
    case customArgument
}
