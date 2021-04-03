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
    }
    
    func test_asURLRequest_setsTheAllHTTPHeaderFields() {
        let noHeadersRequest = Request(url: URL.test)
        XCTAssertTrue(noHeadersRequest.asURLRequest.allHTTPHeaderFields?.isEmpty ?? false)
        
        let expectedHeaders = ["Cookie":"yummy_cookie=choco; tasty_cookie=strawberry"]
        let headersRequest = Request(url: URL.test, headers: expectedHeaders)
        XCTAssertEqual(headersRequest.asURLRequest.allHTTPHeaderFields ?? [:], expectedHeaders)
    }
}
