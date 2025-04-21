import XCTest
@testable import TrackForceChallenge

final class TrackForceChallengeMapperTest: XCTestCase {

    func test_mapFromResponse_mapsAllDailyEntries() {
        // Given
        let mapper = DefaultWeatherResponseMapper()
        let response = MockWeatherResponseFactory.make(days: 3)

        // When
        let result = mapper.map(from: response)

        // Then
        XCTAssertEqual(result.daily.count, 3)
        XCTAssertEqual(result.city.name, "Test City")
        XCTAssertEqual(result.city.coordinate.latitude, 10)
        XCTAssertEqual(result.city.coordinate.longitude, 20)
    }
}
