import Foundation

extension URL {
    static var test = Self(string: "https://example.com")!
}

extension URLRequest {
    static var test = Self(url: URL.test)
}
