import HTTP
import XCTest

final class ClientTests: XCTestCase {
    // MARK: request(_:completion:)

    func test_request_loadsTheRequest() {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, Empty>(requestLoader: requestLoader)

        client.request(Request(url: URL.test)) { _ in }

        XCTAssertEqual(requestLoader.lastLoadedRequest, URLRequest.test)
    }

    func test_request_withURLRequest_loadsTheRequest() {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, Empty>(requestLoader: requestLoader)

        let expectedURLRequest = URLRequest.testWithExtraProperties
        client.request(expectedURLRequest) { _ in }

        XCTAssertEqual(requestLoader.lastLoadedRequest, expectedURLRequest)
    }

    func test_request_failsWithANetworkError() {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, Empty>(requestLoader: requestLoader)

        let networkError = URLError(.badURL)
        requestLoader.nextError = networkError

        client.request(Request(url: URL.test)) { result in
            assertResultError(result, .failedRequest(URLError(.badURL)))
        }
    }

    func test_request_200range_succeedsWithParsedSuccessObject() throws {
        let requestLoader = FakeRequestLoader()
        let client = Client<TestObject, Empty>(requestLoader: requestLoader)

        let exampleObject = TestObject()
        let data = try XCTUnwrap(JSONEncoder().encode(exampleObject))
        requestLoader.nextData = data

        let response = HTTPURLResponse(url: URL.test, statusCode: 200, httpVersion: nil, headerFields: ["HEADER": "value"])
        requestLoader.nextResponse = response

        client.request(Request(url: URL.test)) { result in
            XCTAssertEqual(try? result.get().value, exampleObject)
            XCTAssertEqual(try? result.get().headers as? [String: String], ["HEADER": "value"])
        }
    }

    func test_request_200range_failsWhenParsingFails() {
        let requestLoader = FakeRequestLoader()
        let client = Client<TestObject, Empty>(requestLoader: requestLoader)

        let response = HTTPURLResponse(url: URL.test, statusCode: 200, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        client.request(Request(url: URL.test)) { result in
            assertResultError(result, .responseTypeMismatch)
        }
    }

    func test_request_non200range_failsWithParsedErrorObject() throws {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, TestError>(requestLoader: requestLoader)

        let error = TestError(message: "Example message.")
        let data = try XCTUnwrap(JSONEncoder().encode(error))
        requestLoader.nextData = data

        let response = HTTPURLResponse(url: URL.test, statusCode: 403, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        client.request(Request(url: URL.test)) { result in
            assertResultError(result, .invalidRequest(error))
        }
    }

    func test_request_non200range_failsWhenParsingFails() {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, TestError>(requestLoader: requestLoader)

        let response = HTTPURLResponse(url: URL.test, statusCode: 403, httpVersion: nil, headerFields: nil)
        requestLoader.nextResponse = response

        client.request(Request(url: URL.test)) { result in
            assertResultError(result, .invalidResponse(403))
        }
    }

    func test_request_failsWhenNotAnHTTPResponse() {
        let requestLoader = FakeRequestLoader()
        let client = Client<Empty, Empty>(requestLoader: requestLoader)

        requestLoader.nextResponse = URLResponse()

        client.request(Request(url: URL.test)) { result in
            assertResultError(result, .failedRequest(nil))
        }
    }
}
