import Foundation

extension JSONEncoder {
    static var convertingKeysFromSnakeCase: JSONEncoder {
        let decoder = JSONEncoder()
        decoder.keyEncodingStrategy = .convertToSnakeCase
        return decoder
    }
}
