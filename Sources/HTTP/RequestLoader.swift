import Foundation

public protocol RequestLoader {
    func load(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: RequestLoader {
    public func load(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
