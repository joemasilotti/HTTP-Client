@testable import HTTP
import XCTest

class RequestTests: XCTestCase {
    // MARK: asURLRequest

    func test_asURLRequest_setsTheURL() {
        let getRequest = Request(url: URL.test)
        XCTAssertEqual(getRequest.asURLRequest.url, URL.test)
    }

    func test_asURLRequest_setsTheHTTPMethod() {
        let getRequest = Request(url: URL.test)
        XCTAssertEqual(getRequest.asURLRequest.httpMethod, "GET")

        let postRequest = Request(url: URL.test, method: .post)
        XCTAssertEqual(postRequest.asURLRequest.httpMethod, "POST")

        let deleteRequest = Request(url: URL.test, method: .delete)
        XCTAssertEqual(deleteRequest.asURLRequest.httpMethod, "DELETE")
    }

    func test_asURLRequest_setsAllHTTPHeaderFields() {
        let headers = ["Cookie": "yummy_cookie=choco; tasty_cookie=strawberry;"]
        let requestWithHeaders = Request(url: URL.test, headers: headers)
        XCTAssertEqual(requestWithHeaders.asURLRequest.allHTTPHeaderFields, headers)
    }
}
