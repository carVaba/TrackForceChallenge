protocol GetUserLocationUseCaseProtocol {
    func run(completion: @escaping (Result<LocationCoordinate, LocationUserLocationError>) -> Void)
}

final class GetUserLocationUseCase: GetUserLocationUseCaseProtocol {
    private let locationService: LocationServiceProtocol
    
    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }
    
    func run(completion: @escaping (Result<LocationCoordinate, LocationUserLocationError>) -> Void) {
        locationService.requestUserLocation { result in
            switch result {
                case .success(let success):
                    completion(.success(LocationCoordinate(latitude: success.latitude,
                                                           longitude: success.longitude)))
                case .failure(let failure):
                    completion(.failure(failure))
            }
        }
    }
}
