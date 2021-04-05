@testable import HTTP
import XCTest

class GlobalTests: XCTestCase {
    override class func setUp() {
        Global.resetToDefaults()
    }

    override class func tearDown() {
        Global.resetToDefaults()
    }

    func test_requestLoader_defaultsToTheSharedURLSession() {
        XCTAssert(Global.requestLoader as? URLSession === URLSession.shared)
    }

    func test_requestLoader_isUsedInClient() {
        let requestLoader = FakeRequestLoader()
        Global.requestLoader = requestLoader
        let client = Client<Empty, Empty>()

        client.request(Request(url: URL.test)) { _ in }

        XCTAssertEqual(requestLoader.lastLoadedRequest, URLRequest.test)
    }
}
