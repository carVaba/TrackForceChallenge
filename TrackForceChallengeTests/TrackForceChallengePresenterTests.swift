import XCTest
@testable import TrackForceChallenge

final class TrackForceChallengePresenterTests: XCTestCase {

    func test_onViewDidLoad_fetchesLocationAndForecastSuccessfully() {
        let expectation = expectation(description: "wait for forecast success")
        // Given
        let viewSpy = WeatherViewSpy {
            expectation.fulfill()
        }
        let locationUseCase = MockLocationUseCase(result: .success(LocationCoordinate(latitude: 10, longitude: 20)))
        let weatherUseCase = MockWeatherUseCase(result: .success(MockForecastInfo.sample))
        let presenter = WeatherPresenter(view: viewSpy,
                                         getWeatherListUseCase: weatherUseCase,
                                         getUserLocationUseCase: locationUseCase)

        // When
        presenter.onViewDidLoad()
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertTrue(viewSpy.didCallShowForecast)
        XCTAssertFalse(viewSpy.didCallShowError)
        XCTAssertEqual(presenter.forecastCount(), 7)
    }
    
    func test_onViewDidLoad_whenLocationFails_showsError() {
        let expectation = expectation(description: "wait for location failed")

        // Given
        let viewSpy = WeatherViewSpy {
            expectation.fulfill()
        }
        let locationUseCase = MockLocationUseCase(result: .failure(LocationUserLocationError.permissionDenied))
        let weatherUseCase = MockWeatherUseCase(result: .success(MockForecastInfo.sample))
        let presenter = WeatherPresenter(view: viewSpy,
                                         getWeatherListUseCase: weatherUseCase,
                                         getUserLocationUseCase: locationUseCase)

        // When
        presenter.onViewDidLoad()
        waitForExpectations(timeout: 1.0)

        // Then
        XCTAssertTrue(viewSpy.didCallShowError)
        XCTAssertFalse(viewSpy.didCallShowForecast)
    }
    
    func test_onViewDidLoad_whenForecastFailsAfterLocation_showsError() {
        let expectation = expectation(description: "wait for Forecast after location failed")

        // Given
        let viewSpy = WeatherViewSpy {
            expectation.fulfill()
        }
        let locationUseCase = MockLocationUseCase(result: .success(LocationCoordinate(latitude: 10, longitude: 20)))
        let weatherUseCase = MockWeatherUseCase(result: .failure(.serviceFail))
        let presenter = WeatherPresenter(view: viewSpy,
                                         getWeatherListUseCase: weatherUseCase,
                                         getUserLocationUseCase: locationUseCase)

        // When
        presenter.onViewDidLoad()
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertTrue(viewSpy.didCallShowError)
        XCTAssertFalse(viewSpy.didCallShowForecast)
    }
}
