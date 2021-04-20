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
        let request = BodyRequest(
            url: URL.test,
            body: TestObject(),
            headers: ["Cookie": "yummy_cookie=choco;"]
        )

        let urlRequest = request.asURLRequest
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Cookie"), "yummy_cookie=choco;")
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }

    func test_init_usesTheKeyEncodingStrategy() throws {
        let request = BodyRequest(
            url: URL.test,
            body: LongNameObject(longProperty: "value"),
            keyEncodingStrategy: .convertToSnakeCase
        )

        let urlRequest = request.asURLRequest
        let data = try XCTUnwrap(urlRequest.httpBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: []) as? [String: String])
        XCTAssertEqual(json["long_property"], "value")
    }
}

private struct LongNameObject: Encodable {
    let longProperty: String
}
