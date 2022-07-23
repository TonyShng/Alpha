//
//  Logger.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import CocoaLumberjack

extension DDLogFlag {
    public var level: String {
        switch self {
        case .error: return "❤️ ERROR"
        case .warning: return "💛 WARNING"
        case .info: return "💙 INFO"
        case .debug: return "💚 DEBUG"
        case .verbose: return "💜 VERBOSE"
        default: return "☠️ UNKNOWN"
        }
    }
}

private class LogFormatter: NSObject, DDLogFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = LogFormatter.dateFormatter.string(from: logMessage.timestamp)
        let level = logMessage.flag.level
        let filename = logMessage.fileName
        let function = logMessage.function ?? ""
        let line = logMessage.line
        let message = logMessage.message.components(separatedBy: "\n").joined(separator: "\n    ")
        return "\(timestamp) \(level) \(filename) \(function):\(line) - \(message)"
    }
    
    private func formattedDate(from date: Date) -> String {
        return LogFormatter.dateFormatter.string(from: date)
    }
}

// A shared instance of 'Logger'.
public let log = Logger()

final public class Logger {
    public init() {
        setenv("XcodeColors", "YES", 0)
        // TTY = Xcode console
        DDTTYLogger.sharedInstance!.logFormatter = LogFormatter()
        DDTTYLogger.sharedInstance!.colorsEnabled = false
        DDTTYLogger.sharedInstance!.setForegroundColor(DDMakeColor(30, 121, 214), backgroundColor: nil, for: .info)
        DDTTYLogger.sharedInstance!.setForegroundColor(DDMakeColor(50, 143, 72), backgroundColor: nil, for: .debug)
        DDLog.add(DDTTYLogger.sharedInstance!)
        
        // File logger
        let fileLogger: DDFileLogger = {
            let fileLogger = DDFileLogger()
            fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24) // 24 hours
            fileLogger.logFileManager.maximumNumberOfLogFiles = 7
            return fileLogger
        }()
        DDLog.add(fileLogger)
    }
    
    // MARK: Logging
    public func error(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let message = self.message(from: items)
        DDLogError(message, file: file, function: function, line: line)
    }
    
    public func warning(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let message = self.message(from: items)
        DDLogWarn(message, file: file, function: function, line: line)
    }
    
    public func info(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let message = self.message(from: items)
        DDLogInfo(message, file: file, function: function, line: line)
    }
    
    public func debug(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let message = self.message(from: items)
        DDLogDebug(message, file: file, function: function, line: line)
    }
    
    public func verbose(_ items: Any..., file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        let message = self.message(from: items)
        DDLogVerbose(message, file: file, function: function, line: line)
    }
    
    // MARK: Utils
    private func message(from items: [Any]) -> String {
        return items.map { String(describing: $0) }.joined(separator: " ")
    }
}
