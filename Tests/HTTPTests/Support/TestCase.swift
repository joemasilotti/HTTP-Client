@testable import HTTP
import XCTest

class TestCase: XCTestCase {
    lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = Global.dateEncodingStrategy
        encoder.keyEncodingStrategy = Global.keyEncodingStrategy
        return encoder
    }()

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = Global.dateDecodingStrategy
        decoder.keyDecodingStrategy = Global.keyDecodingStrategy
        return decoder
    }()

    override func setUp() {
        Global.resetToDefaults()
    }

    override func tearDown() {
        Global.resetToDefaults()
    }
}
