import Foundation

public typealias ClientResult<T, E> = Result<Response<T>, HTTPError<E>>
    where T: Decodable, E: LocalizedError & Decodable & Equatable

public struct Client<T, E> where T: Decodable, E: LocalizedError & Decodable & Equatable {
    public init(requestLoader: RequestLoader = Global.requestLoader) {
        self.requestLoader = requestLoader
    }

    @MainActor
    public func request(_ request: Request) async -> ClientResult<T, E> {
        await self.request(request.asURLRequest)
    }

    @MainActor
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

    private func handleResponse(_ response: URLResponse, with data: Data) -> ClientResult<T, E> {
        guard let response = response as? HTTPURLResponse
        else { return .failure(.failedRequest(nil)) }

        if (200 ..< 300).contains(response.statusCode) {
            return handleSuccess(data, headers: response.allHeaderFields, statusCode: response.statusCode)
        } else {
            return handleFailure(data, statusCode: response.statusCode)
        }
    }

    private func handleSuccess(_ data: Data, headers: [AnyHashable: Any], statusCode: Int) -> ClientResult<T, E> {
        if let value: T = parse(data) {
            return .success(Response(headers: headers, value: value, statusCode: statusCode))
        } else {
            return .failure(.responseTypeMismatch(statusCode))
        }
    }

    private func handleFailure(_ data: Data, statusCode: Int) -> ClientResult<T, E> {
        if let error: E = parse(data) {
            return .failure(.invalidRequest(error, statusCode))
        } else {
            return .failure(.invalidResponse(statusCode))
        }
    }

    private func parse<D: Decodable>(_ data: Data?) -> D? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = Global.keyDecodingStrategy
        return try? decoder.decode(D.self, from: data)
    }
}
