# HTTP Client

A barebones Swift HTTP client with automatic JSON response parsing.

## Installation

Add HTTP Client as a dependency through Xcode or directly to Package.swift:

```
.package(url: "https://github.com/joemasilotti/HTTP-Client", branch: "main")
```

## Usage

GET request with no expected success or error response object types.

```swift
import HTTP

let client = Client()
let request = Request(url: url)
client.request(request, success: Empty.self, error: Empty.self) { result in
    switch result {
    case .success: print("Success!")
    case .failure(let error): print(error.localizedDescription)
    }
}
```

POST request with both HTTP body and expected success and response object types.

```swift
import HTTP

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
```

HTTP headers can also be set on `Request`.

```swift
let client = Client()
let headers = ["Cookie": "tasty_cookie=strawberry"]
let request = Request(url: url, headers: headers)
client.request(request, success: Empty.self, error: Empty.self) { _ in }
```

`URLRequest` can be used directly if you require more fine grained control.

```swift
let client = Client()
let request = URLRequest(
    url: url,
    cachePolicy: .reloadIgnoringLocalCacheData,
    timeoutInterval: 42.0
)
client.request(request, success: Empty.self, error: Empty.self) { _ in }
```
