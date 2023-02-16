import Foundation

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
    case unaryOperator
    case binaryOperator
    case customArgument
}

extension String {

}

/*受け取った文字列をトークンに分解して、一つの配列に格納して返す*/
private func toToken(words: String) -> [String] {
    var token: String
    var tokenList: [String]

    //文字列に対する数値判定メソッド
    func isNumeric(_ word: String) -> Bool {
        if(Int(word) == nil) {
            return true
        }else {
            return false
        }
    }

    while(words.count > 0) {
        //文字列の先頭から順番に1文字ずつ数字かどうか調べる
        var sub: String //着目している文字
        for i: Int in 0 ..< words.count {
            token = ""
            //着目する文字を抜き出す
            let start: Int = i
            let end: Int = i + 1
            let startIdx = words.index(words.startIndex, offsetBy: start, limitedBy: words.endIndex) ?? words.endIndex
            let endIdx = words.index(words.startIndex, offsetBy: end + 1, limitedBy: words.endIndex) ?? words.endIndex
            sub = String(words[startIdx..<endIdx])

            if(isNumeric(sub)) { //数字が来たら
                token += sub
            }else if(sub == "." && (tokenList.firstIndex(of: ".") == nil)) { //小数点が来たら
                token += sub
            }else {
                if(token != "") { //数字・小数点じゃないものが来たらトークンを書き出してリセット
                    tokenList.append(token)
                    token = ""
                }else if(sub == "+" && sub == "-" && sub == "*" && sub == "/" && sub == "^" && sub == "√" && sub == ")" && sub == ")") { //演算子系が来たら
                    tokenList.append(token)
                    token = ""
                }
            }
        }
        /*tokenList.append(token) //ここで一つのトークンとして配列に書き出し*/
    }
    if(tokenList.count > 0) {
        return tokenList
    /*
    }else {
        return nil
    */
    }
}

struct hoge: Token {
    var tokenType: TokenType

    static func Parse(_ source: String) -> Token? {

            return ""

            return nil
    }

    static func Deserialize(_ source: String) -> Token? {

    }

    func ToDisplayString() -> String {
        var displayString: String

        return displayString
    }

    func Serialize() -> String {
        var serializedString: String

        return serializedString
    }
}