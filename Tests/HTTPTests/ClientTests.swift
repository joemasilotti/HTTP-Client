import HTTP
import XCTest

final class ClientTests: XCTestCase {
    // MARK: request(_:success:,error:,completion:)

    func test_request_loadsTheRequest() {
        let requestLoader = FakeRequestLoader()
        let client = Client(requestLoader: requestLoader)

        client.request(Request(url: URL.test), success: Empty.self, error: Empty.self) { _ in }

        XCTAssertEqual(requestLoader.lastLoadedRequest, URLRequest.test)
    }

    func test_request_failsWithANetworkError() {
        let requestLoader = FakeRequestLoader()
        let client = Client(requestLoader: requestLoader)

        let networkError = URLError(.badURL)
        requestLoader.nextError = networkError

        client.request(Request(url: URL.test), success: Empty.self, error: Empty.self) { result in
            assertResultError(result, HTTP.Error.failedRequest(URLError(.badURL)))
        }
    }

    func test_request_200range_succeedsWithParsedSuccessObject() throws {
        let requestLoader = FakeRequestLoader()
        let client = Client(requestLoader: requestLoader)

        let exampleObject = TestObject()
        let data = try XCTUnwrap(JSONEncoder().encode(exampleObject))
        requestLoader.nextData = data

        let response = HTTPURLResponse(url: URL.test, statusCode: 200, httpVersion: nil, headerFields: ["HEADER": "value"])
        requestLoader.nextResponse = response

        client.request(Request(url: URL.test), success: TestObject.self, error: Empty.self) { result in
            XCTAssertEqual(try? result.get().value, exampleObject)
            XCTAssertEqual(try? result.get().headers as? [String: String], ["HEADER": "value"])
        }
    }

    func test_request_200range_failsWhenParsingFails() {
        let requestLoader = FakeRequestLoader()
        let client = Client(requestLoader: requestLoader)

        let response = HTTPURLResponse(url: URL.test, statusCode: 200, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        client.request(Request(url: URL.test), success: TestObject.self, error: Empty.self) { result in
            assertResultError(result, HTTP.Error.invalidResponse)
        }
    }

    func test_request_non200range_failsWithParsedErrorObject() throws {
        let requestLoader = FakeRequestLoader()
        let client = Client(requestLoader: requestLoader)

        let error = TestError(message: "Example message.")
        let data = try XCTUnwrap(JSONEncoder().encode(error))
        requestLoader.nextData = data

        let response = HTTPURLResponse(url: URL.test, statusCode: 403, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        client.request(Request(url: URL.test), success: Empty.self, error: TestError.self) { result in
            assertResultError(result, HTTP.Error.invalidRequest(error))
        }
    }

    func test_request_non200range_failsWhenParsingFails() {
        let requestLoader = FakeRequestLoader()
        let client = Client(requestLoader: requestLoader)

        let response = HTTPURLResponse(url: URL.test, statusCode: 403, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        client.request(Request(url: URL.test), success: Empty.self, error: TestError.self) { result in
            assertResultError(result, HTTP.Error.invalidRequest(nil))
        }
    }

    func test_request_failsWhenNotAnHTTPResponse() {
        let requestLoader = FakeRequestLoader()
        let client = Client(requestLoader: requestLoader)

        requestLoader.nextResponse = URLResponse()

        client.request(Request(url: URL.test), success: Empty.self, error: Empty.self) { result in
            assertResultError(result, HTTP.Error.failedRequest(nil))
        }
    }
}
