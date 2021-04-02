import Foundation

struct TestObject: Codable, Equatable {
    let title: String

    init(title: String = "Test Title") {
        self.title = title
    }
}

struct TestError: LocalizedError, Codable, Equatable {
    let message: String
}
