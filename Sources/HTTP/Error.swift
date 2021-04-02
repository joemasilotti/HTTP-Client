import Foundation

public extension HTTP {
    enum Error<T: LocalizedError>: LocalizedError {
        case failedRequest(URLError?)
        case invalidResponse
        case invalidRequest(T?)

        public var errorDescription: String? {
            switch self {
                case .failedRequest: return "The request failed."
                case .invalidResponse: return "The response was invalid."
                case let .invalidRequest(error):
                    return error?.localizedDescription ?? "The request was invalid."
            }
        }
    }
}

extension HTTP.Error: Equatable where T: Equatable {}
