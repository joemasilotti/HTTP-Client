# HTTP Client

A barebones async-await Swift HTTP client with automatic JSON response parsing.

## Installation

Add HTTP Client as a dependency through Xcode or directly to Package.swift:

```
.package(url: "https://github.com/joemasilotti/HTTP-Client", branch: "main")
```

## Usage

### GET request with empty responses

```swift
import HTTP

let client = Client<Empty, Empty>()
let request = Request(url: url)
switch await client.request(request) {
case .success: print("Success!")
case .failure(let error): print(error.localizedDescription)
}
```

### POST request with success and response objects

Failure response objects are parsed when the response code is outside of the 200 range.

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

let client = Client<User, RegistrationError>()
let registration = Registration(email: "joe@masilotti.com", password: "password")
let request = BodyRequest(url: url, method: .post, body: registration)
switch await client.request(request) {
case .success(let response):
    print("HTTP headers", response.headers)
    print("User", response.value)
case .failure(let error):
    print("Error", error.localizedDescription)
}
```

### Status code

When possible, a status code is also exposed.

```swift
import HTTP

let client = Client<Empty, Empty>()
let request = Request(url: url)
switch await client.request(request) {
case .success(let statusCode):
    print("Status code", statusCode)
case .failure(let error):
    print("Status code", error.statusCode ?? "(none)")
}
```

### HTTP headers

HTTP headers can also be set on `Request`.

```swift
import HTTP

let client = Client<Empty, Empty>()
let headers = ["Cookie": "tasty_cookie=strawberry"]
let request = Request(url: url, headers: headers)
_ = await client.request(request)
```

### Custom `URLRequest`

`URLRequest` can be used directly if you require more fine grained control.

```swift
import HTTP

let client = Client<Empty, Empty>()
let request = URLRequest(
    url: url,
    cachePolicy: .reloadIgnoringLocalCacheData,
    timeoutInterval: 42.0
)
_ = await client.request(request)
```

### Key encoding strategies

By default, all encoding and decoding of keys to JSON is done by converting to snake case.

This can be changed via the global configuration.

```swift
import HTTP

HTTP.Global.keyDecodingStrategy = .useDefaultKeys
HTTP.Global.keyEncodingStrategy = .useDefaultKeys
```
