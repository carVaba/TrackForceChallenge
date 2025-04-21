import Foundation

protocol WeatherCacheProtocol {
    func save(_ info: Data) throws
    func load() throws -> Data
}
