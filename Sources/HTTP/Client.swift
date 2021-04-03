import Combine
import Foundation

public typealias Completion<T, E> = (Result<Response<T>, HTTP.Error<E>>) -> Void
    where T: Decodable, E: LocalizedError & Decodable & Equatable

public struct Client {
    public init(requestLoader: RequestLoader = URLSession.shared) {
        self.requestLoader = requestLoader
    }

    public func request<T, E>(_ request: Request, success: T.Type, error: E.Type, completion: @escaping Completion<T, E>) {
        self.request(request.asURLRequest, success: success, error: error, completion: completion)
    }

    public func request<T, E>(_ urlRequest: URLRequest, success: T.Type, error: E.Type, completion: @escaping Completion<T, E>) {
        requestLoader.load(urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.failedRequest(error)))
            } else if let response = response as? HTTPURLResponse {
                handleResponse(response, with: data, completion: completion)
            } else {
                completion(.failure(.failedRequest(nil)))
            }
        }
    }

    // MARK: Private

    private let requestLoader: RequestLoader

    private func handleResponse<T, E>(_ response: HTTPURLResponse, with data: Data?, completion: @escaping Completion<T, E>) {
        if (200 ..< 300).contains(response.statusCode) {
            handleSuccess(data, headers: response.allHeaderFields, completion: completion)
        } else {
            handleFailure(data, completion: completion)
        }
    }

    private func handleSuccess<T, E>(_ data: Data?, headers: [AnyHashable: Any], completion: @escaping Completion<T, E>) {
        if let object: T = parse(data) {
            completion(.success(Response(headers: headers, value: object)))
        } else {
            completion(.failure(.invalidResponse))
        }
    }

    private func handleFailure<T, E>(_ data: Data?, completion: @escaping Completion<T, E>) {
        if let error: E = parse(data) {
            completion(.failure(.invalidRequest(error)))
        } else {
            completion(.failure(.invalidRequest(nil)))
        }
    }

    private func parse<T: Decodable>(_ data: Data?) -> T? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
