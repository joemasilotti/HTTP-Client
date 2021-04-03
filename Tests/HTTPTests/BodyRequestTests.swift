@testable import HTTP
import XCTest

class BodyRequestTests: XCTestCase {
    // MARK: asURLRequest

    func test_asURLRequest_encodesItsBody() throws {
        let request = BodyRequest(url: URL.test, body: TestObject())
        let urlRequest = request.asURLRequest

        let data = try XCTUnwrap(urlRequest.httpBody)
        let object = try? JSONDecoder().decode(TestObject.self, from: data)
        XCTAssertEqual(object, TestObject())
    }

    func test_init_setsJSONAsTheContentTypeHeader() {
        let request = BodyRequest(url: URL.test, body: TestObject())
        let urlRequest = request.asURLRequest
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func test_init_setsTheAllHTTPHeaderFields() {
        let expectedCookies = "yummy_cookie=choco; tasty_cookie=strawberry"
        let request = BodyRequest(url: URL.test, body: TestObject(),
                                  headers: ["Cookie": expectedCookies])
        let urlRequest = request.asURLRequest
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Cookie"), expectedCookies)
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
    
    func test_init_always_overrides_setsJSONAsTheContentTypeHeader() {
        let request = BodyRequest(url: URL.test, body: TestObject(),
                                  headers: ["Content-Type": "text/html"])
        let urlRequest = request.asURLRequest
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

}
