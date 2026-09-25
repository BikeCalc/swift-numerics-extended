// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

// MARK: - DocumentationBuildError

/// An error produced while building the documentation website.
fileprivate enum DocumentationBuildError {
    /// The script received unsupported command-line arguments.
    case invalidArguments

    /// The documentation process could not be started.
    ///
    /// - Parameter underlyingError: The original process-launch error.
    case launchFailed(underlyingError: any Error)

    /// The documentation process exited unsuccessfully.
    ///
    /// - Parameter status: The process exit status.
    case buildFailed(status: Int32)

    /// The documentation process was terminated by a signal.
    ///
    /// - Parameter signal: The terminating signal.
    case buildInterrupted(signal: Int32)

    /// The landing-page redirect could not be written.
    ///
    /// - Parameters:
    ///   - path: The destination of the redirect.
    ///   - underlyingError: The original file-writing error.
    case landingPageWriteFailed(
        path: String,
        underlyingError: any Error
    )

    /// The command-line exit status, preserving an unsuccessful documentation build's status.
    fileprivate var exitStatus: Int32 {
        switch self {
        case .buildFailed(let status):
            return status
        default:
            return EXIT_FAILURE
        }
    }
}

// MARK: - CustomStringConvertible

extension DocumentationBuildError: CustomStringConvertible {
    fileprivate var description: String {
        switch self {
        case .invalidArguments:
            return "Usage: BuildDocumentation.swift"
        case .launchFailed(let underlyingError):
            return "Could not start the documentation build: \(underlyingError)"
        case .buildFailed(let status):
            return "Documentation build failed with exit status \(status)."
        case .buildInterrupted(let signal):
            return "Documentation build was terminated by signal \(signal)."
        case .landingPageWriteFailed(let path, let underlyingError):
            return "Could not write the documentation landing page at \(path): \(underlyingError)"
        }
    }
}

// MARK: - Error

extension DocumentationBuildError: Error {}

// MARK: - Arguments

/// The command-line arguments accepted by the documentation builder.
fileprivate struct Arguments {
    /// Validates that the script was invoked without options.
    ///
    /// - Parameter arguments: The arguments following the script name.
    /// - Throws: `DocumentationBuildError.invalidArguments` if any arguments are supplied.
    fileprivate init(_ arguments: Array<String>) throws(DocumentationBuildError) {
        guard arguments.isEmpty else {
            throw DocumentationBuildError.invalidArguments
        }
    }
}

// MARK: - DocumentationBuilder

/// Builds the combined DocC website and adds its GitHub Pages landing-page redirect.
fileprivate struct DocumentationBuilder {
    /// Creates a documentation builder using the repository's publishing configuration.
    fileprivate init() {}

    /// The HTML that redirects the site root to DocC's documentation landing page.
    private let redirectHTML: String = "<meta http-equiv=\"refresh\" content=\"0; url=documentation/\">\n"

    /// The output path of the documentation site's landing page.
    private let landingPagePath: String = ".build/github-pages/index.html"

    /// Builds the website and writes the redirect only after documentation generation succeeds.
    ///
    /// Run from the repository root. Generated files remain in `.build/github-pages/`; this script does not deploy
    /// them.
    ///
    /// - Throws: `DocumentationBuildError` if the process cannot start, the build fails, or the redirect cannot be
    /// written.
    fileprivate func run() throws(DocumentationBuildError) {
        try self.buildWebsite()

        do {
            try self.redirectHTML.write(
                toFile: self.landingPagePath,
                atomically: true,
                encoding: .utf8
            )
        } catch let error {
            throw DocumentationBuildError.landingPageWriteFailed(
                path: self.landingPagePath,
                underlyingError: error
            )
        }
    }

    /// Invokes the DocC plugin with the module selection and GitHub Pages hosting settings.
    ///
    /// - Throws: `DocumentationBuildError` if the process cannot start or does not complete successfully.
    private func buildWebsite() throws(DocumentationBuildError) {
        let process: Process = .init()
        process.executableURL = .init(fileURLWithPath: "/usr/bin/env")

        // Keep the generated site rooted at .build/github-pages/ for the workflow's Pages artifact upload.
        process.arguments = [
            "swift", "package", "--allow-writing-to-directory", ".build/github-pages", "generate-documentation",
            "--enable-experimental-combined-documentation",
            "--target", "CoreNumericOperators",
            "--target", "CoreNumericProtocols",
            "--target", "ExperimentalNumericConstants",
            "--target", "ExperimentalNumericProtocols",
            "--target", "ExperimentalNumericTypes",
            "--target", "StandardNumericProtocols",
            "--target", "StandardNumericTypes",
            "--target", "NumericsExtended",
            "--output-path", ".build/github-pages",
            "--transform-for-static-hosting",
            "--hosting-base-path", "swift-numerics-extended"
        ]

        do {
            try process.run()
        } catch let error {
            throw DocumentationBuildError.launchFailed(underlyingError: error)
        }

        process.waitUntilExit()

        guard process.terminationReason == .exit else {
            throw DocumentationBuildError.buildInterrupted(signal: process.terminationStatus)
        }
        guard process.terminationStatus == EXIT_SUCCESS else {
            throw DocumentationBuildError.buildFailed(status: process.terminationStatus)
        }
    }
}

// MARK: - Documentation Generation

do throws(DocumentationBuildError) {
    let _: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let builder: DocumentationBuilder = .init()
    try builder.run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(error.exitStatus)
}
