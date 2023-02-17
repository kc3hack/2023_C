public protocol PUserDefaultsService {
    func set(value: String, forKey: String)
    func set(value: Bool, forKey: String)
    func set(value: Int, forKey: String)
    func set(value: Float, forKey: String)
    func set(value: Double, forKey: String)

    func getString(forKey: String) -> String?
    func getBool(forKey: String) -> Bool
    func getInteger(forKey: String) -> Int
    func getFloat(forKey: String) -> Float
    func getDouble(forKey: String) -> Double
}
