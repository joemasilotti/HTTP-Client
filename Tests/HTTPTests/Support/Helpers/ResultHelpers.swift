import XCTest

func assertResultError<T, E>(
    _ result: Result<T, E>,
    _ expectedError: E,
    file: StaticString = #filePath,
    line: UInt = #line
) where E: Equatable {
    switch result {
    case .failure(let actualError):
        XCTAssertEqual(actualError, expectedError, file: file, line: line)
    case .success:
        XCTFail("Result did not fail", file: file, line: line)
    }
}
