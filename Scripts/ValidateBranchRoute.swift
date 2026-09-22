// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import RegexBuilder

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

guard CommandLine.arguments.count == 3 else {
    print("Usage: ValidateBranchRoute.swift <base> <head>")
    exit(EXIT_FAILURE)
}

/// The destination branch of the pull request.
fileprivate let base: String = CommandLine.arguments[1]

/// The source branch of the pull request.
fileprivate let head: String = CommandLine.arguments[2]

/// A destination branch beginning with the release prefix.
fileprivate let releaseBranch: Regex<Substring> = Regex {
    "release/"
    ZeroOrMore(.any)
}

/// A source branch with one of the prefixes permitted when targeting a release branch.
fileprivate let allowedSourceBranch: Regex<Substring> = Regex {
    ChoiceOf {
        "feature"
        "bugfix"
        "chore"
        "docs"
        "test"
    }
    "/"
    ZeroOrMore(.any)
}

// Every source branch may target main.
if base == "main" {
    exit(EXIT_SUCCESS)
}

// Release branches accept only the documented prefixes.
if base.wholeMatch(of: releaseBranch) != nil && head.wholeMatch(of: allowedSourceBranch) != nil {
    exit(EXIT_SUCCESS)
}

print("Invalid branch route: \(head) -> \(base)")
print("Allowed routes:")
print("- Any branch -> main")
print("- feature/*, bugfix/*, chore/*, docs/*, or test/* -> release/*")
exit(EXIT_FAILURE)
