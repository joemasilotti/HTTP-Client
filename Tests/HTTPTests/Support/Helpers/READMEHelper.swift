import Foundation
import HTTP

let url = URL.test

struct GETRequestExample {
    func example() {
        let client = Client<Empty, Empty>()
        let request = Request(url: url)
        client.request(request) { result in
            switch result {
            case .success: print("Success!")
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}

struct POSTRequestExample {
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

        let client = Client<User, RegistrationError>()
        let registration = Registration(email: "joe@masilotti.com", password: "password")
        let request = BodyRequest(url: url, method: .post, body: registration)
        client.request(request) { result in
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

struct RequestWithHeadersExample {
    func example() {
        let client = Client<Empty, Empty>()
        let headers = ["Cookie": "tasty_cookie=strawberry"]
        let request = Request(url: url, headers: headers)
        client.request(request) { _ in }
    }
}

struct URLRequestExample {
    func example() {
        let client = Client<Empty, Empty>()
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 42.0
        )
        client.request(request) { _ in }
    }
}
