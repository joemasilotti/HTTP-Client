import Foundation

public protocol RequestLoader {
    func load(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, URLError?) -> Void)
}

extension URLSession: RequestLoader {
    public func load(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, URLError?) -> Void) {
        dataTask(with: request) { data, response, error in
            completion(data, response, error as? URLError)
        }.resume()
    }
}
