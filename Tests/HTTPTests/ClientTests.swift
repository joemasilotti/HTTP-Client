import HTTP
import XCTest

final class ClientTests: TestCase {
    // MARK: request(_:completion:)

    func test_request_loadsTheRequest() async {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, Empty>(requestLoader: requestLoader)

        _ = await client.request(Request(url: URL.test))

        XCTAssertEqual(requestLoader.lastLoadedRequest, URLRequest.test)
    }

    func test_request_withURLRequest_loadsTheRequest() async {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, Empty>(requestLoader: requestLoader)

        let expectedURLRequest = URLRequest.testWithExtraProperties
        _ = await client.request(expectedURLRequest)

        XCTAssertEqual(requestLoader.lastLoadedRequest, expectedURLRequest)
    }

    func test_request_failsWithANetworkError() async {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, Empty>(requestLoader: requestLoader)

        let networkError = URLError(.badURL)
        requestLoader.nextError = networkError

        let result = await client.request(Request(url: URL.test))
        assertResultError(result, .failedRequest(URLError(.badURL)))
    }

    func test_request_200range_succeedsWithParsedSuccessObject() async throws {
        let requestLoader = FakeRequestLoader()
        let client = Client<TestObject, Empty>(requestLoader: requestLoader)

        let exampleObject = TestObject()
        let data = try XCTUnwrap(encoder.encode(exampleObject))
        requestLoader.nextData = data

        let response = HTTPURLResponse(url: URL.test, statusCode: 200, httpVersion: nil, headerFields: ["HEADER": "value"])
        requestLoader.nextResponse = response

        let result = await client.request(Request(url: URL.test))
        XCTAssertEqual(try? result.get().value, exampleObject)
        XCTAssertEqual(try? result.get().headers as? [String: String], ["HEADER": "value"])
    }

    func test_request_200range_failsWhenParsingFails() async {
        let requestLoader = FakeRequestLoader()
        let client = Client<TestObject, Empty>(requestLoader: requestLoader)

        let response = HTTPURLResponse(url: URL.test, statusCode: 200, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        let result = await client.request(Request(url: URL.test))
        assertResultError(result, .responseTypeMismatch)
    }

    func test_request_non200range_failsWithParsedErrorObject() async throws {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, TestError>(requestLoader: requestLoader)

        let error = TestError(message: "Example message.")
        let data = try XCTUnwrap(encoder.encode(error))
        requestLoader.nextData = data

        let response = HTTPURLResponse(url: URL.test, statusCode: 403, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        let result = await client.request(Request(url: URL.test))
        assertResultError(result, .invalidRequest(error))
    }

    func test_request_non200range_failsWhenParsingFails() async {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, TestError>(requestLoader: requestLoader)

        let response = HTTPURLResponse(url: URL.test, statusCode: 403, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        let result = await client.request(Request(url: URL.test))
        assertResultError(result, .invalidResponse(403))
    }

    func test_request_failsWhenNotAnHTTPResponse() async {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, Empty>(requestLoader: requestLoader)

        requestLoader.nextResponse = URLResponse()

        let result = await client.request(Request(url: URL.test))
        assertResultError(result, .failedRequest(nil))
    }

    func test_request_nonSnakeCaseKeyCodingStrategy() async throws {
        let requestLoader = FakeRequestLoader()
        HTTP.Global.keyDecodingStrategy = .useDefaultKeys
        HTTP.Global.keyEncodingStrategy = .useDefaultKeys
        let client = Client<TestObject, Empty>(requestLoader: requestLoader)

        let exampleObject = TestObject()
        let data = try XCTUnwrap(encoder.encode(exampleObject))
        requestLoader.nextData = data

        let result = await client.request(Request(url: URL.test))
        XCTAssertEqual(try? result.get().value, exampleObject)
    }

    func test_request_dateCodingStrategy() async throws {
        let requestLoader = FakeRequestLoader()
        HTTP.Global.dateDecodingStrategy = .millisecondsSince1970
        HTTP.Global.dateEncodingStrategy = .millisecondsSince1970
        let client = Client<TestObject, Empty>(requestLoader: requestLoader)

        let exampleObject = TestObject()
        let data = try XCTUnwrap(encoder.encode(exampleObject))
        requestLoader.nextData = data

        let result = await client.request(Request(url: URL.test))
        XCTAssertEqual(try? result.get().value, exampleObject)
    }
}
