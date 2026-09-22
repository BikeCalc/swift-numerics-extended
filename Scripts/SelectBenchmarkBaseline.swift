// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

guard CommandLine.arguments.count == 5 else {
    print("Usage: SelectBenchmarkBaseline.swift <event> <base-sha> <before-sha> <ref-name>")
    exit(EXIT_FAILURE)
}

/// The workflow event name, such as pull_request, push, or workflow_dispatch.
fileprivate let event: String = CommandLine.arguments[1]

/// The pull request base revision, or an empty string for other events.
fileprivate let baseSHA: String = CommandLine.arguments[2]

/// The revision preceding a push; an all-zero value indicates that no previous revision exists.
fileprivate let beforeSHA: String = CommandLine.arguments[3]

/// The unqualified branch or tag name associated with the event.
fileprivate let refName: String = CommandLine.arguments[4]

if event == "pull_request" {
    print(baseSHA)
} else if event == "push" && refName == "main" && !beforeSHA.allSatisfy({ $0 == "0" }) {
    print(beforeSHA)
} else if event == "push" && refName.hasPrefix("release/") {
    // Resolve the local remote-tracking reference using the workflow's complete Git checkout.
    do {
        let process: Process = .init()
        process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["git", "rev-parse", "refs/remotes/origin/main"]

        try process.run()
        process.waitUntilExit()

        // Preserve Git's exit status and treat signal termination as failure.
        exit(process.terminationReason == .exit ? process.terminationStatus : EXIT_FAILURE)
    } catch let error {
        FileHandle.standardError.write(Data("\(error)\n".utf8))
        exit(EXIT_FAILURE)
    }
} else {
    print("")
}
