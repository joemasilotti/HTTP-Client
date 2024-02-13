import Foundation

public enum HTTPError<T: LocalizedError>: LocalizedError {
    case failedRequest(URLError?)
    case invalidRequest(T, Int)
    case invalidResponse(Int)
    case responseTypeMismatch(Int)

    public var errorDescription: String? {
        switch self {
            case .failedRequest:
                return "The request failed."
            case let .invalidRequest(error, _):
                return error.localizedDescription
            case let .invalidResponse(statusCode):
                return "The response was invalid (\(statusCode))."
            case .responseTypeMismatch:
                return "The response did not match the expected type."
        }
    }

    public var failureReason: String? {
        switch self {
            case let .failedRequest(error):
                return error?.localizedDescription
            case let .invalidRequest(error, _):
                return error.localizedDescription
            case let .invalidResponse(statusCode):
                return "The server returned a \(statusCode) status code."
            case .responseTypeMismatch:
                return "The response did not match the expected error type."
        }
    }

    public var statusCode: Int? {
        if case let .invalidRequest(_, statusCode) = self {
            return statusCode
        } else if case let .invalidResponse(statusCode) = self {
            return statusCode
        } else if case let .responseTypeMismatch(statusCode) = self {
            return statusCode
        }
        return nil
    }
}

extension HTTPError: Equatable where T: Equatable {}
