import XCTest
import Swinject
@testable import CalculatorCore

public class BarServiceTest: XCTestCase {
    var barService: PBarService? = nil

    public override func setUp() {
        let container = Container()
        container.register(PFooService.self) { _ in FooServiceMock() }
        container.register(PBarService.self) { r in BarService(fooService: r.resolve(PFooService.self)!) }
        barService = container.resolve(PBarService.self)
        super.setUp()
    }

    public func testAdd() throws {
        guard let barService else {
            return
        }

        XCTAssertEqual(barService.execute(1, 2), 3)
    }
} 