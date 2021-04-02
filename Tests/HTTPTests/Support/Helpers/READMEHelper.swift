import Foundation
import HTTP

let url = URL.test

struct GETRequest {
    func example() {
        let client = Client()
        let request = Request(url: url)
        client.request(request, success: Empty.self, error: Empty.self) { result in
            switch result {
            case .success: print("Success!")
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}

struct POSTRequest {
    func example() {
        struct Registration: Codable {
            let email: String
            let password: String
        }

        struct User: Codable {
            let id: Int
            let isAdmin: Bool
        }

        struct RegistrationError: LocalizedError, Codable, Equatable {
            let status: Int
            let message: String

            var errorDescription: String? { message }
        }

        let client = Client()
        let registration = Registration(email: "joe@masilotti.com", password: "password")
        let request = BodyRequest(url: url, method: .post, body: registration)
        client.request(request, success: User.self, error: RegistrationError.self) { result in
            switch result {
            case .success(let response):
                print("HTTP headers", response.headers)
                print("User", response.value)
            case .failure(let error):
                print("Error", error.localizedDescription)
            }
        }
    }
}
