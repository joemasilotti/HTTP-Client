import Foundation

public protocol RequestLoader {
    func load(_ request: URLRequest) async throws -> (Data, URLResponse)
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
extension URLSession: RequestLoader {
    public func load(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}

@available(macOS, deprecated: 12.0, message: "Use the built-in API instead")
@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
