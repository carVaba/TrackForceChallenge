import Foundation

final class SecureWeatherCache: WeatherCacheProtocol {
    private let fileManager: FileManager
    private let directoryURL: URL
    
    init?(fileManager: FileManager) {
        self.fileManager = fileManager
        // https://developer.apple.com/documentation/foundation/url/cachesdirectory
        let url = fileManager.urls(for: .cachesDirectory,
                                   in: .userDomainMask).first
        
        guard let url = url else {
            return nil
        }
        self.directoryURL = url
    }
    
    private var savedFileURL: URL {
        let fileName = "last-saved-data.json"
        return directoryURL.appendingPathComponent(fileName)
    }
    
    func save(_ info: Data) throws {
        try info.write(to: savedFileURL, options: .completeFileProtectionUntilFirstUserAuthentication)
    }
    
    func load() throws -> Data {
        return try Data(contentsOf: savedFileURL)
    }
}
