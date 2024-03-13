//
//  BasicAudioPlayer
//  Logging.swift
//
//  Copyright © 2022 Fabio Vinotti. All rights reserved.
//  Licensed under MIT License.
//

import os.log

let log = LoggerWrapper(subsystem: "BasicAudioPlayer", category: "general")

struct LoggerWrapper {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    init(subsystem: String, category: String) {
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    func debug(
        _ message: String,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line
    ) {
        log(
            level: .debug,
            message,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    func info(
        _ message: String,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line
    ) {
        log(
            level: .info,
            message,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    func error(
        _ message: String,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line
    ) {
        log(
            level: .error,
            message,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    func fault(
        _ message: String,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line
    ) {
        log(
            level: .fault,
            message,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    func log(
        level: OSLogType,
        _ message: String,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line
    ) {
        logger.log(
            level: level,
            "\(fileName.lastPathComponent) \(functionName) \(lineNumber) > \(message)")
    }

}
