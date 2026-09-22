// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

guard CommandLine.arguments.count <= 2 else {
    print("Usage: RunBenchmarks.swift [baseline-sha]")
    exit(EXIT_FAILURE)
}

do {
    let process: Process = .init()
    process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
    process.arguments = [
        "swift", "package", "plugin", "--allow-network-connections", "all", "benchmark"
    ]

    // An omitted or empty baseline requests a report for the current revision alone.
    if let baselineSHA = CommandLine.arguments.dropFirst().first, !baselineSHA.isEmpty {
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
