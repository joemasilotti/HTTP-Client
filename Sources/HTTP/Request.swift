import Foundation

public class Request {
    public typealias HTTPHeaderFields = [String : String]
    
    public init(url: URL, method: Method = .get, headers: HTTPHeaderFields = [:]) {
        self.url = url
        self.method = method
        self.headers = headers
    }

    // MARK: Internal

    var asURLRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        addToRequest(&request)
        return request
    }

    func addToRequest(_ request: inout URLRequest) {}

    // MARK: Private

    private let method: Method
    private let url: URL
    private let headers: HTTPHeaderFields
}
