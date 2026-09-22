// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

guard CommandLine.arguments.count <= 2 else {
    print("Usage: ValidateContributors.swift [revision]")
    exit(EXIT_FAILURE)
}

/// The revision whose reachable commits define the expected contributors, defaulting to HEAD.
fileprivate let revision: String = CommandLine.arguments.dropFirst().first ?? "HEAD"

/// The name of the contributor file maintained at the repository root.
fileprivate let contributorsFileName: String = "CONTRIBUTORS.txt"

do {
    let output: Pipe = .init()

    let git: Process = .init()
    git.executableURL = .init(fileURLWithPath: "/usr/bin/env")

    // Uppercase author placeholders honor Git's mailmap when normalizing names and email addresses.
    git.arguments = ["git", "log", "--format=- %aN <%aE>", revision, "--"]
    git.standardOutput = output

    try git.run()

    // Drain the pipe before waiting so large histories cannot block on a full output buffer.
    let data: Data = output.fileHandleForReading.readDataToEndOfFile()
    git.waitUntilExit()

    guard git.terminationReason == .exit && git.terminationStatus == EXIT_SUCCESS else {
        exit(EXIT_FAILURE)
    }

    // Exclude GitHub bot addresses and compare UTF-8 bytes to preserve the workflow's LC_ALL=C sorting and uniqueness rules.
    let authors: Array<Array<UInt8>> = Set(
        String(decoding: data, as: UTF8.self)
            .split(separator: "\n")
            .filter { !$0.hasSuffix("[bot]@users.noreply.github.com>") }
            .map { Array($0.utf8) }
    )
    .sorted { $0.lexicographicallyPrecedes($1) }

    // Match the generated file byte for byte, including the final newline for each contributor.
    let expected: Data = Data(authors.flatMap { $0 + [10] })
    let current: Data

    do {
        current = try .init(contentsOf: URL(fileURLWithPath: contributorsFileName))
    } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
        FileHandle.standardError.write(
            Data("\(contributorsFileName) is missing. Run this script from the repository root.\n".utf8)
        )
        exit(EXIT_FAILURE)
    }

    if current == expected {
        exit(EXIT_SUCCESS)
    }

    FileHandle.standardOutput.write(
        Data("\(contributorsFileName) is not up to date.\nApply the following changes:\n".utf8)
    )

    // Give diff a temporary expected file and remove it after comparison, including on thrown errors.
    let temporaryURL: URL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

    try FileManager.default.createDirectory(
        at: temporaryURL,
        withIntermediateDirectories: true
    )

    defer {
        try? FileManager.default.removeItem(at: temporaryURL)
    }

    let expectedURL: URL = temporaryURL.appendingPathComponent(contributorsFileName)
    try expected.write(to: expectedURL)

    let diff: Process = .init()
    diff.executableURL = .init(fileURLWithPath: "/usr/bin/env")
    diff.arguments = ["diff", "-u", contributorsFileName, expectedURL.path]

    try diff.run()
    diff.waitUntilExit()

    // A mismatch always fails validation, regardless of whether diff can display it.
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
}

exit(EXIT_FAILURE)
