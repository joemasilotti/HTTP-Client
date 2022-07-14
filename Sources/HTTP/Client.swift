import Foundation

public typealias ClientResult<T, E> = Result<Response<T>, HTTPError<E>>
    where T: Decodable, E: LocalizedError & Decodable & Equatable

public struct Client<T, E> where T: Decodable, E: LocalizedError & Decodable & Equatable {
    public init(requestLoader: RequestLoader = Global.requestLoader) {
        self.requestLoader = requestLoader
    }

    public func request(_ request: Request) async -> ClientResult<T, E> {
        await self.request(request.asURLRequest)
    }

    public func request(_ request: URLRequest) async -> ClientResult<T, E> {
        do {
            let (data, response) = try await requestLoader.load(request)
            return handleResponse(response, with: data)
        } catch {
            return .failure(.failedRequest(error as? URLError))
        }
    }

    // MARK: Private

    private let requestLoader: RequestLoader

    private func handleResponse<T>(_ response: URLResponse, with data: Data) -> ClientResult<T, E> {
        guard let response = response as? HTTPURLResponse
        else { return .failure(.failedRequest(nil)) }

        if (200 ..< 300).contains(response.statusCode) {
            return handleSuccess(data, headers: response.allHeaderFields)
        } else {
            return handleFailure(data, statusCode: response.statusCode)
        }
    }

    private func handleSuccess<T, E>(_ data: Data, headers: [AnyHashable: Any]) -> ClientResult<T, E> {
        if let value: T = parse(data) {
            return .success(Response(headers: headers, value: value))
        } else {
            return .failure(.responseTypeMismatch)
        }
    }

    private func handleFailure<T, E>(_ data: Data, statusCode: Int) -> ClientResult<T, E> {
        if let error: E = parse(data) {
            return .failure(.invalidRequest(error))
        } else {
            return .failure(.invalidResponse(statusCode))
        }
    }

    private func parse<T: Decodable>(_ data: Data?) -> T? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = Global.keyDecodingStrategy
        return try? decoder.decode(T.self, from: data)
    }
}
