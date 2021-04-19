import Foundation

public enum HTTPError<T: LocalizedError>: LocalizedError {
    case failedRequest(URLError?)
    case invalidRequest(T)
    case invalidResponse(Int)
    case responseTypeMismatch

    public var errorDescription: String? {
        switch self {
            case .failedRequest: return "The request failed."
            case let .invalidRequest(error): return error.localizedDescription
            case let .invalidResponse(statusCode): return "The response was invalid (\(statusCode)."
            case .responseTypeMismatch: return "The response did not match the expected type."
        }
    }
}

extension HTTPError: Equatable where T: Equatable {}
