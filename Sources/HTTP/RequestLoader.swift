import Foundation

public protocol RequestLoader {
    func load(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: RequestLoader {
    public func load(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, macOS 12.0, *) {
            return try await data(for: request)
        } else {
            return try await _data(for: request)
        }
    }

    private func _data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
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
