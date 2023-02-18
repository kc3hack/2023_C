//
//  UserDefaultsService.swift
//  calculator-for-iPad
//
//  Created by 紀仁 on 2023/02/17.
//

import CalculatorCore
import Foundation

public class UserDefaultsService: PUserDefaultsService {
    public func set(value: String, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }

    public func set(value: Bool, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    public func set(value: Int, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    public func set(value: Float, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    public func set(value: Double, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    public func getString(forKey: String) -> String? {
        return UserDefaults.standard.string(forKey: forKey)
    }

    public func getBool(forKey: String) -> Bool {
        return UserDefaults.standard.bool(forKey: forKey)
    }

    public func getInteger(forKey: String) -> Int {
        return UserDefaults.standard.integer(forKey: forKey)
    }

    public func getFloat(forKey: String) -> Float {
        return UserDefaults.standard.float(forKey: forKey)
    }

    public func getDouble(forKey: String) -> Double {
        return UserDefaults.standard.double(forKey: forKey)
    }
}
