@testable import HTTP
import XCTest

class BodyRequestTests: XCTestCase {
    override func tearDown() {
        Global.resetToDefaults()
    }

    // MARK: asURLRequest

    func test_asURLRequest_encodesItsBody() throws {
        let request = BodyRequest(url: URL.test, body: TestObject())
        let urlRequest = request.asURLRequest

        let data = try XCTUnwrap(urlRequest.httpBody)
        let object = try? JSONDecoder.convertingKeysFromSnakeCase.decode(TestObject.self, from: data)
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

    func test_init_usesSnakeCaseKeyEncodingStrategy() throws {
        Global.keyEncodingStrategy = .convertToSnakeCase
        let request = BodyRequest(url: URL.test, body: TestObject(secondProperty: "value"))

        let json = try decodeRequest(request)
        XCTAssertEqual(json["second_property"], "value")
    }

    func test_init_usesDefaultKeyEncodingStrategy() throws {
        Global.keyEncodingStrategy = .useDefaultKeys
        let request = BodyRequest(url: URL.test, body: TestObject(secondProperty: "value"))

        let json = try decodeRequest(request)
        XCTAssertEqual(json["secondProperty"], "value")
    }

    private func decodeRequest(_ request: Request) throws -> [String: String] {
        let urlRequest = request.asURLRequest
        let data = try XCTUnwrap(urlRequest.httpBody)
        return try XCTUnwrap(JSONSerialization.jsonObject(with: data, options: []) as? [String: String])
    }
}
