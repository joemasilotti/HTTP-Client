import Foundation
import HTTP

class FakeRequestLoader: RequestLoader {
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: URLError?

    private(set) var lastLoadedRequest: URLRequest?

    func load(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, URLError?) -> Void) {
        lastLoadedRequest = request
        completion(nextData, nextResponse, nextError)
    }

    func load(_ request: URLRequest) async throws -> (Data, URLResponse) {
        lastLoadedRequest = request
        if let error = nextError {
            throw error
        }
        return (nextData ?? Data(), nextResponse ?? HTTPURLResponse())
    }
}
