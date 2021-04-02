import Foundation

public class BodyRequest<T: Encodable>: Request {
    public init(url: URL, method: Method = .get, body: T) {
        self.body = body
        super.init(url: url, method: method)
    }

    // MARK: Internal

    override func addToRequest(_ request: inout URLRequest) {
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    // MARK: Private

    private let body: T
}
