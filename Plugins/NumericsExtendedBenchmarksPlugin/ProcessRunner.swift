// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

/// Runs subprocesses required by the benchmark plugin and validates their termination status.
internal enum ProcessRunner {
    /// Runs a command and captures its standard output.
    ///
    /// Standard error remains connected to the plugin process so progress and diagnostics remain visible.
    ///
    /// - Parameters:
    ///   - command: The executable command to locate through the environment.
    ///   - arguments: The arguments to pass to the command.
    ///   - workingDirectoryURL: The directory in which to run the command.
    /// - Returns: The data written by the command to standard output.
    /// - Throws: An error when the process cannot start or terminates unsuccessfully.
    internal static func output(
        command: String,
        arguments: Array<String>,
        workingDirectoryURL: URL
    ) throws -> Data {
        let pipe: Pipe = .init()
        let process: Process = Self.process(
            command: command,
            arguments: arguments,
            workingDirectoryURL: workingDirectoryURL
        )
        process.standardOutput = pipe

        try process.run()
        let output: Data = pipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        try Self.validate(process, command: command)

        return output
    }

    /// Runs a command while forwarding its output to the plugin's standard error stream.
    ///
    /// - Parameters:
    ///   - command: The executable command to locate through the environment.
    ///   - arguments: The arguments to pass to the command.
    ///   - workingDirectoryURL: The directory in which to run the command.
    /// - Throws: An error when the process cannot start or terminates unsuccessfully.
    internal static func run(
        command: String,
        arguments: Array<String>,
        workingDirectoryURL: URL
    ) throws {
        let process: Process = Self.process(
            command: command,
            arguments: arguments,
            workingDirectoryURL: workingDirectoryURL
        )
        process.standardOutput = FileHandle.standardError

        try process.run()
        process.waitUntilExit()
        try Self.validate(process, command: command)
    }

    /// Creates a process configured to locate a command through the environment.
    ///
    /// - Parameters:
    ///   - command: The executable command to locate.
    ///   - arguments: The arguments to pass to the command.
    ///   - workingDirectoryURL: The directory in which to run the command.
    /// - Returns: A configured process that has not yet started.
    private static func process(
        command: String,
        arguments: Array<String>,
        workingDirectoryURL: URL
    ) -> Process {
        let process: Process = .init()
        process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        process.arguments = [command] + arguments
        process.currentDirectoryURL = workingDirectoryURL

        return process
    }

    /// Confirms that a process exited successfully.
    ///
    /// - Parameters:
    ///   - process: The terminated process to validate.
    ///   - command: The command to identify if validation fails.
    /// - Throws: `NumericsExtendedBenchmarksPluginError.commandFailed` when the process did not exit successfully.
    private static func validate(
        _ process: Process,
        command: String
    ) throws(NumericsExtendedBenchmarksPluginError) {
        guard process.terminationReason == .exit && process.terminationStatus == EXIT_SUCCESS else {
            throw NumericsExtendedBenchmarksPluginError.commandFailed(
                command: command,
                status: Int(process.terminationStatus)
            )
        }
    }
}
