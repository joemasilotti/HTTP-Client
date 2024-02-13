import Foundation

public struct Response<T> {
    public let headers: [AnyHashable: Any]
    public let value: T
    public let statusCode: Int
}
