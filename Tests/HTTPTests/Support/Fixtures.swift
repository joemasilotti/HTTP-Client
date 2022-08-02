import Foundation

struct TestObject: Codable, Equatable {
    let property: String
    let secondProperty: String
    let dateProperty: Date

    init(property: String = "First property", secondProperty: String = "Second property", dateProperty: Date = Date(timeIntervalSinceReferenceDate: 33)) {
        self.property = property
        self.secondProperty = secondProperty
        self.dateProperty = dateProperty
    }
}

struct TestError: LocalizedError, Codable, Equatable {
    let message: String
}
