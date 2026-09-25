// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

// MARK: - ContributorValidationError

/// An error produced while checking contributor attribution.
fileprivate enum ContributorValidationError {
    /// More than one revision was supplied.
    case invalidArguments

    /// The contributor file is absent from the current directory.
    case missingContributorsFile

    /// The contributor file differs from the Git history.
    ///
    /// - Parameter difference: The unified diff needed to update the file.
    case contributorsOutOfDate(difference: String)

    /// A subprocess could not be started.
    ///
    /// - Parameters:
    ///   - command: The subprocess name.
    ///   - underlyingError: The original process-launch error.
    case commandLaunchFailed(
        command: String,
        underlyingError: any Error
    )

    /// A file-system operation could not be completed.
    ///
    /// - Parameters:
    ///   - operation: The operation being performed.
    ///   - path: The file or directory involved.
    ///   - underlyingError: The original file-system error.
    case fileOperationFailed(
        operation: String,
        path: String,
        underlyingError: any Error
    )

    /// A subprocess failed or was terminated by a signal.
    ///
    /// - Parameters:
    ///   - command: The subprocess name.
    ///   - status: The exit status or terminating signal.
    case commandFailed(
        command: String,
        status: Int32
    )
}

// MARK: - CustomStringConvertible

extension ContributorValidationError: CustomStringConvertible {
    fileprivate var description: String {
        switch self {
        case .invalidArguments:
            return "Usage: ValidateContributors.swift [revision]"
        case .missingContributorsFile:
            return "CONTRIBUTORS.txt is missing. Run this script from the repository root."
        case .contributorsOutOfDate(let difference):
            return "CONTRIBUTORS.txt is not up to date.\nApply the following changes:\n\(difference)"
        case .commandLaunchFailed(let command, let underlyingError):
            return "Could not start \(command): \(underlyingError)"
        case .fileOperationFailed(let operation, let path, let underlyingError):
            return "Could not \(operation) at \(path): \(underlyingError)"
        case .commandFailed(let command, let status):
            return "\(command) failed with termination status \(status)."
        }
    }
}

// MARK: - Error

extension ContributorValidationError: Error {}

// MARK: - Arguments

/// The command-line arguments used to select contributor history.
fileprivate struct Arguments {
    /// The revision whose reachable commits define the expected contributors.
    fileprivate let revision: String

    /// Parses an optional revision, defaulting to HEAD.
    ///
    /// - Parameter arguments: The arguments following the script name.
    /// - Throws: `ContributorValidationError.invalidArguments` if more than one revision is supplied.
    fileprivate init(_ arguments: Array<String>) throws(ContributorValidationError) {
        guard arguments.count <= 1 else {
            throw ContributorValidationError.invalidArguments
        }

        self.revision = arguments.first ?? "HEAD"
    }
}

// MARK: - ContributorValidator

/// Checks the contributor file against the authors recorded in Git history.
fileprivate struct ContributorValidator {
    /// The revision to validate.
    private let arguments: Arguments

    /// Creates a validator for the selected history.
    ///
    /// - Parameter arguments: The revision to validate.
    fileprivate init(arguments: Arguments) {
        self.arguments = arguments
    }

    /// The contributor file maintained at the repository root.
    private let contributorsFileName: String = "CONTRIBUTORS.txt"

    /// Validates contributor attribution without changing the contributor file.
    ///
    /// Git mailmap entries normalize author identities, and GitHub bot addresses are excluded.
    /// A mismatch includes a unified diff in the validation error.
    ///
    /// - Throws: `ContributorValidationError` if arguments, history, or attribution are invalid, or a
    ///   subprocess cannot start or a file cannot be read or written.
    fileprivate func run() throws(ContributorValidationError) {
        let expected: Data = try self.expectedContributors()
        let current: Data

        do {
            current = try .init(contentsOf: URL(fileURLWithPath: self.contributorsFileName))
        } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
            throw ContributorValidationError.missingContributorsFile
        } catch let error {
            throw ContributorValidationError.fileOperationFailed(
                operation: "read the contributor file",
                path: self.contributorsFileName,
                underlyingError: error
            )
        }

        guard current != expected else {
            return
        }

        let difference: String = try self.contributorDifference(expected: expected)
        throw ContributorValidationError.contributorsOutOfDate(difference: difference)
    }

    /// Reads and normalizes the authors reachable from the selected revision.
    ///
    /// - Returns: The sorted, unique contributor lines encoded as UTF-8 with a final newline.
    /// - Throws: `ContributorValidationError` if Git cannot start or history cannot be read.
    private func expectedContributors() throws(ContributorValidationError) -> Data {
        let output: Pipe = .init()
        let git: Process = .init()
        git.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        // Uppercase author placeholders honor Git's mailmap when normalizing names and email addresses.
        git.arguments = ["git", "log", "--format=- %aN <%aE>", self.arguments.revision, "--"]
        git.standardOutput = output

        do {
            try git.run()
        } catch let error {
            throw ContributorValidationError.commandLaunchFailed(
                command: "git",
                underlyingError: error
            )
        }

        // Drain the pipe before waiting so large histories cannot block on a full output buffer.
        let data: Data = output.fileHandleForReading.readDataToEndOfFile()
        git.waitUntilExit()

        guard git.terminationReason == .exit && git.terminationStatus == EXIT_SUCCESS else {
            throw ContributorValidationError.commandFailed(
                command: "git",
                status: git.terminationStatus
            )
        }

        // Compare UTF-8 bytes to preserve the workflow's LC_ALL=C sorting and uniqueness rules.
        let authors: Array<Array<UInt8>> = Set(
            String(decoding: data, as: UTF8.self)
                .split(separator: "\n")
                .filter { $0.hasSuffix("[bot]@users.noreply.github.com>") == false }
                .map { Array($0.utf8) }
        )
        .sorted { $0.lexicographicallyPrecedes($1) }

        return Data(authors.flatMap { $0 + [10] })
    }

    /// Compares the contributor file with a temporary copy of the expected contents.
    ///
    /// - Parameter expected: The normalized contributor file contents.
    /// - Returns: The unified diff produced by the comparison.
    /// - Throws: `ContributorValidationError` if temporary files cannot be created or the comparison cannot run.
    private func contributorDifference(expected: Data) throws(ContributorValidationError) -> String {
        let temporaryURL: URL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        do {
            try FileManager.default.createDirectory(
                at: temporaryURL,
                withIntermediateDirectories: true
            )
        } catch let error {
            throw ContributorValidationError.fileOperationFailed(
                operation: "create the temporary directory",
                path: temporaryURL.path,
                underlyingError: error
            )
        }

        defer {
            try? FileManager.default.removeItem(at: temporaryURL)
        }

        let expectedURL: URL = temporaryURL.appendingPathComponent(self.contributorsFileName)
        do {
            try expected.write(to: expectedURL)
        } catch let error {
            throw ContributorValidationError.fileOperationFailed(
                operation: "write the expected contributors",
                path: expectedURL.path,
                underlyingError: error
            )
        }

        let output: Pipe = .init()
        let diff: Process = .init()
        diff.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        diff.arguments = ["diff", "-u", self.contributorsFileName, expectedURL.path]
        diff.standardOutput = output

        do {
            try diff.run()
        } catch let error {
            throw ContributorValidationError.commandLaunchFailed(
                command: "diff",
                underlyingError: error
            )
        }

        let data: Data = output.fileHandleForReading.readDataToEndOfFile()
        diff.waitUntilExit()

        // diff returns 1 for differences; other nonzero statuses indicate a comparison failure.
        guard diff.terminationReason == .exit && (diff.terminationStatus == 0 || diff.terminationStatus == 1) else {
            throw ContributorValidationError.commandFailed(
                command: "diff",
                status: diff.terminationStatus
            )
        }

        return String(decoding: data, as: UTF8.self)
    }
}

// MARK: - Validation

do throws(ContributorValidationError) {
    let arguments: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let validator: ContributorValidator = .init(arguments: arguments)
    try validator.run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
