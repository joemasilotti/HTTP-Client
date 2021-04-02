import Foundation

public class Request {
    public init(url: URL, method: Method = .get) {
        self.url = url
        self.method = method
    }

    // MARK: Internal

    var asURLRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        addToRequest(&request)
        return request
    }

    func addToRequest(_ request: inout URLRequest) {}

    // MARK: Private

    private let method: Method
    private let url: URL
}
