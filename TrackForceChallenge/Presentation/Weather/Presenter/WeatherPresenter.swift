import Foundation
import CoreLocation

protocol Presenter: AnyObject {
    func onViewDidLoad()
}

protocol View: AnyObject {
    func showLoading(_ value: Bool)
    func showError(_ title: String?, _ message: String)
}

protocol WeatherPresenterProtocol: Presenter {
    func forecastCount() -> Int
    func forecastViewModel(at index: Int) -> ForecastViewModelCell?
    func mapModelToCellViewModel(using info: ForecastInfo) -> [ForecastViewModelCell]
    func mapModelToHeaderViewModel(using info: ForecastInfo) -> ForecastHeaderViewModel
}

final class WeatherPresenter: WeatherPresenterProtocol {
    private weak var view: WeatherView?
    private let getWeatherListUseCase: GetWeatherUseCaseProtocol
    private let getUserLocationUseCase: GetUserLocationUseCaseProtocol
    
    private var forecastViewModels: [ForecastViewModelCell] = []
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.calendar = .current
        formatter.dateFormat = "cccc" // return the date name
        return formatter
    }()
    
    init(view: WeatherView?, getWeatherListUseCase: GetWeatherUseCaseProtocol, getUserLocationUseCase: GetUserLocationUseCaseProtocol) {
        self.view = view
        self.getWeatherListUseCase = getWeatherListUseCase
        self.getUserLocationUseCase = getUserLocationUseCase
    }
    
    func onViewDidLoad() {
        view?.showLoading(true)
        getUserLocation()
    }
    
    private func getUserLocation() {
        getUserLocationUseCase.run { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let success):
                        self?.fetchForeCastFor(latitude: success.latitude,
                                               longitude: success.longitude)
                    case .failure(let failure):
                        self?.view?.showLoading(false)
                        self?.view?.showError(failure.title, failure.message)
                }
            }
        }
    }
    
    func forecastCount() -> Int {
        self.forecastViewModels.count
    }
    
    func forecastViewModel(at index: Int) -> ForecastViewModelCell? {
        guard forecastViewModels.indices.contains(index) else { return nil }
        return self.forecastViewModels[index]
    }
    
    func mapModelToCellViewModel(using info: ForecastInfo) -> [ForecastViewModelCell] {
        return info.daily.map({ forecast in
            ForecastViewModelCell(
                dateText: formatter.string(from: forecast.date),
                temperatureText: String(format: "%.0f°", forecast.temperature.max),
                iconName: "\(forecast.icon)_t"
            )
        })
    }
    
    func mapModelToHeaderViewModel(using info: ForecastInfo) -> ForecastHeaderViewModel {
        return ForecastHeaderViewModel(iconName: "\(info.current.icon)_t",
                                       weatherDescription: info.current.weatherDescription,
                                       temperatureLabel: String(format: "%.0f°", info.current.temperature.current),
                                       cityName: info.city.name,
                                       coordinate: info.city.coordinate)
    }
    
    private func fetchForeCastFor(latitude: Double, longitude: Double) {
        getWeatherListUseCase.run(for: LocationCoordinate(latitude: latitude,
                                                          longitude: longitude)) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                view?.showLoading(false)
                switch result {
                    case .success(let info):
                        self.forecastViewModels = mapModelToCellViewModel(using: info)
                        let headerViewModel = mapModelToHeaderViewModel(using: info)
                        self.view?.showForecast(headerViewModel)
                    case .failure(let failure):
                        self.view?.showError("", failure.message)
                }
            }
        }
    }
}
