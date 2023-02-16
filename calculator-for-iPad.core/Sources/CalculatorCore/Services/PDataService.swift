public protocol PDataService {
    func loadExpression() -> [String]
    func saveExpression(expression: Expression)
    func loadConfig() -> Config
    func saveConfig(config: Config)
}