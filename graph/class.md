大文字関数名はミスなので書くときに修正してください
UI層とやり取りするところ
```mermaid
classDiagram

PCalculatorService <|.. CalculatorService
PDataService <.. CalculatorService
PDataService <|.. DataService
PUserDefaultsService <.. DataService

class PCalculatorService {
    <<protocol>>
    Parse(string expressionRawString) Exression
    Execute(Expression expression) Number
}
class PDataService {
    <<protocol>>
    LoadExpression() Array_string
    SaveExpression(Expression expression)
    LoadConfig() Config
    SaveConfig(Config config)
}
class PUserDefaultsService {
    <<protocol>>
    set(string value, string forKey)
    set(bool value, string forKey)
    set(int value, string forKey)
    set(float value, string forKey)
    set(double value, string forKey)
    getString(string forKey) string
    getBool(string forKey) bool
    getIntger(string forKey) int
    getFloat(string forKey) float
    getDouble(string forKey) double
}
```

Entity系 ロジックはない
```mermaid
classDiagram

Expression o-- Token
Token <|-- Number
Token <|-- UnaryOperator
Token <|-- BinaryOperator
Token <|-- CustomArgument

Number <|.. Real
Number <|.. Fraction
Number <|.. CustomConstant

UnaryOperator <|.. NativeUnaryOperator
UnaryOperator <|.. CustomUnaryOperator
BinaryOperator <|.. NativeBinaryOperator
BinaryOperator <|.. CustomBinaryOperator

Expression <.. CustomUnaryOperator
Expression <.. CustomBinaryOperator

class Expression {
    string rawExpression
    Array_Token tokens

    Execute() Number
}

class Token {
    <<protocol>>
    TokenType tokenType

    TryParse(string source, inout Token token) bool
    ToDisplayString() string
    Serialize() string
    TryDeserialize(string value, inout Token token) bool
}
class Number {
    <<protocol>>
    static Number e
    static Number pi
    ToReal() Real
}
class Real {
    -decimal value
}
class Fraction {
    -int numerator
    -int denominator

    Reduce() Fraction
}
class CustomConstant {
    static CustomConstant e
    static CustomConstant pi
    string rawText

}

class UnaryOperator {
    <<protocol>>
    Execute(Number value) Number
}
class BinaryOperator {
    <<protocol>>
    Execute(Number left, Number right) Number
}

class TokenType {
    <<enum>>
    UnaryOperator
    BinaryOperator
    Number
    CustomArgument
}
```
`Number`がデカくなりすぎたので移動
```mermaid
classDiagram

class Number {
    <<protocol>>
    IsInteger bool
    ToReal() Real

    // 逆ポーランド記法で処理する都合上演算子の右側が先に
    // 見えてくるので、受け取るのは演算子の左として処理する
    Add(Number left) Number
    Substrct(Number left) Number
    Multiply(Number left) Number
    Divide(Number left) Number
    Modulus(Number left) Number
    Pow(Number left) Number

    Negate() Number
    Abs() Number
    Sqrt() Number
    Sin() Number
    Cos() Number
    Tan() Number
    ArcSin() Number
    ArcCos() Number
    ArcTan() Number
    Log() Number
    Ln() Number
}
