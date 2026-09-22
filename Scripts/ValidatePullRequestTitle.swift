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

guard CommandLine.arguments.count == 2 else {
    print("Usage: ValidatePullRequestTitle.swift <title>")
    exit(EXIT_FAILURE)
}

/// The pull request title supplied on the command line.
fileprivate let title: String = CommandLine.arguments[1]

/// The allowed commit types, optional scope and breaking-change marker, and required description.
///
/// The description includes line separators to preserve the original validator's treatment of multiline input.
/// Unicode scalar matching preserves its handling of combining characters beside punctuation.
fileprivate let pattern: Regex<Substring> = Regex {
    ChoiceOf {
        "fix"
        "feat"
        "build"
        "chore"
        "ci"
        "docs"
        "style"
        "refactor"
        "perf"
        "test"
    }
    Optionally {
        "("
        OneOrMore {
            CharacterClass.anyOf("()").inverted
        }
        ")"
    }
    Optionally {
        "!"
    }
    ": "
    OneOrMore(.any)
}
.matchingSemantics(.unicodeScalar)

if title.wholeMatch(of: pattern) != nil {
    exit(EXIT_SUCCESS)
}

print("Invalid pull request title: \(title)")
print("Use the Conventional Commit form:")
print("<type>[optional scope]: <description>")
print("Parentheses around a scope are required. Append ! after the type or scope for a breaking change.")
print("Allowed types: fix, feat, build, chore, ci, docs, style, refactor, perf, test")
exit(EXIT_FAILURE)
