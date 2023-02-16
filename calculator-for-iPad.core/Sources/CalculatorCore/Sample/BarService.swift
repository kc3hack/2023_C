public protocol PBarService {
    func execute(_ x: Int, _ y: Int) -> Int
}

internal class BarService : PBarService {
    private let fooService: PFooService

    init(fooService: PFooService) {
        self.fooService = fooService
    }

    func execute(_ x: Int, _ y: Int) -> Int {
        return fooService.add(x, y)
    }
}

