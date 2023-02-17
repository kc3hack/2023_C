@testable import CalculatorCore

public class FooServiceMock: PFooService {
    public func add(_ x: Int, _ y: Int) -> Int {
        return x + y
    }
}