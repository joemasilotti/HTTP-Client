import Foundation

public enum Global {
    public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    public static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
    public static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    public static var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
    public static var requestLoader: RequestLoader = URLSession.shared

    static func resetToDefaults() {
        dateDecodingStrategy = .iso8601
        dateEncodingStrategy = .iso8601
        keyDecodingStrategy = .convertFromSnakeCase
        keyEncodingStrategy = .convertToSnakeCase
        requestLoader = URLSession.shared
    }
}
