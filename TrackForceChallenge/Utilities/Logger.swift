import Foundation

enum LogLevel: String {
    case debug = "💬"
    case info = "ℹ️"
    case warning = "⚠️"
    case error = "❌"
}

// Logger compatible with iOS 11
struct Logger {
    static var isEnabled = false

    static func log(_ message: String,
                    level: LogLevel = .info,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        let logMessage = "\(level.rawValue) [\(sourceFileName(filePath: file)):\(line)] \(function) → \(message)"
        guard isEnabled else { return }
        print(logMessage)
    }

    private static func sourceFileName(filePath: String) -> String {
        return (filePath as NSString).lastPathComponent
    }

    // Convenience methods
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }

    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }

    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}
