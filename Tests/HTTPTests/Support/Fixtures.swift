import Foundation

struct TestObject: Codable, Equatable {
    let property: String
    let secondProperty: String

    init(property: String = "First property", secondProperty: String = "Second property") {
        self.property = property
        self.secondProperty = secondProperty
    }
}

struct TestError: LocalizedError, Codable, Equatable {
    let message: String
}
