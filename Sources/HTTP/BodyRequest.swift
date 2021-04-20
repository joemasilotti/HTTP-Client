import Foundation

public class BodyRequest<T: Encodable>: Request {
    private let keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy

    public init(url: URL, method: Method = .get, body: T, headers: Headers = [:], keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) {
        self.body = body
        self.keyEncodingStrategy = keyEncodingStrategy
        super.init(url: url, method: method, headers: headers)
    }

    // MARK: Internal

    override func addToRequest(_ request: inout URLRequest) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        request.httpBody = try? encoder.encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    // MARK: Private

    private let body: T
}
