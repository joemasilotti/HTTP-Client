import Foundation

public enum Global {
    public static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    public static var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
    public static var userAgent: String?
    public static var requestLoader: RequestLoader = URLSession.shared

    static func resetToDefaults() {
        keyDecodingStrategy = .convertFromSnakeCase
        keyEncodingStrategy = .convertToSnakeCase
        userAgent = nil
        requestLoader = URLSession.shared
    }
}
