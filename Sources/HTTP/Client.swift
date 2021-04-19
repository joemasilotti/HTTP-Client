import Foundation

public typealias Completion<T, E> = (Result<Response<T>, HTTPError<E>>) -> Void
    where T: Decodable, E: LocalizedError & Decodable & Equatable

public struct Client<T, E> where T: Decodable, E: LocalizedError & Decodable & Equatable {
    public init(requestLoader: RequestLoader = Global.requestLoader) {
        self.requestLoader = requestLoader
    }

    public func request(_ request: Request, completion: @escaping Completion<T, E>) {
        self.request(request.asURLRequest, completion: completion)
    }

    public func request(_ request: URLRequest, completion: @escaping Completion<T, E>) {
        requestLoader.load(request) { data, response, error in
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
            completion(.failure(.responseTypeMismatch))
        }
    }

    private func handleFailure<T, E>(_ data: Data?, completion: @escaping Completion<T, E>) {
        if let error: E = parse(data) {
            completion(.failure(.invalidRequest(error)))
        } else {
            completion(.failure(.invalidResponse))
        }
    }

    private func parse<T: Decodable>(_ data: Data?) -> T? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
