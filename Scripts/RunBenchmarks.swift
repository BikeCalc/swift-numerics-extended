// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

/// Selects the benchmark baseline from an explicit revision or workflow event arguments.
///
/// - Parameter arguments: No arguments, `--baseline <revision>`, or
///   `--event <event> <base-sha> <before-sha> <ref-name>`.
/// - Returns: The baseline revision, or an empty string when no comparison applies.
/// - Throws: An error if Git cannot be launched to resolve the release-branch baseline.
fileprivate func selectBaseline(from arguments: Array<String>) throws -> String {
    if arguments.isEmpty {
        return ""
    }

    if arguments.count == 2 && arguments[0] == "--baseline" {
        return arguments[1]
    }

    guard arguments.count == 5 && arguments[0] == "--event" else {
        let data: Data = .init(
            ("Usage: RunBenchmarks.swift [--baseline <revision>]\n"
                + "Usage: RunBenchmarks.swift --event <event> <base-sha> <before-sha> <ref-name>\n").utf8
        )
        FileHandle.standardError.write(data)
        exit(EXIT_FAILURE)
    }

    let event: String = arguments[1]
    let baseSHA: String = arguments[2]
    let beforeSHA: String = arguments[3]
    let refName: String = arguments[4]

    if event == "pull_request" {
        return baseSHA
    }

    if event == "push" && refName == "main" && !beforeSHA.allSatisfy({ $0 == "0" }) {
        return beforeSHA
    }

    if event == "push" && refName.hasPrefix("release/") {
        let output: Pipe = .init()
        let git: Process = .init()
        git.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        git.arguments = ["git", "rev-parse", "refs/remotes/origin/main"]
        git.standardOutput = output

        try git.run()
        let data: Data = output.fileHandleForReading.readDataToEndOfFile()
        git.waitUntilExit()

        guard git.terminationReason == .exit && git.terminationStatus == EXIT_SUCCESS else {
            exit(git.terminationReason == .exit ? git.terminationStatus : EXIT_FAILURE)
        }

        // Capture Git's revision instead of including it in the benchmark report on standard output.
        return String(decoding: data, as: UTF8.self).trimmingCharacters(in: .newlines)
    }

    return ""
}

do {
    let arguments: Array<String> = Array(CommandLine.arguments.dropFirst())
    let baselineSHA: String = try selectBaseline(from: arguments)

    let process: Process = .init()
    process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
    process.arguments = [
        "swift", "package", "plugin", "--allow-network-connections", "all", "benchmark"
    ]

    // An omitted or empty baseline requests a report for the current revision alone.
    if !baselineSHA.isEmpty {
        process.arguments?.append(contentsOf: ["--baseline", baselineSHA])
    }

    try process.run()
    process.waitUntilExit()

    // Preserve the plugin's exit status and treat signal termination as failure.
    exit(process.terminationReason == .exit ? process.terminationStatus : EXIT_FAILURE)
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
