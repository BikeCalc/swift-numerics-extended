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
    print("Usage: ValidateTag.swift <tag>")
    exit(EXIT_FAILURE)
}

/// The release tag supplied on the command line.
fileprivate let tag: String = CommandLine.arguments[1]

/// A version component consisting of zero or an ASCII decimal integer with no leading zeros.
fileprivate let versionComponent: Regex<Substring> = Regex {
    ChoiceOf {
        "0"
        Regex {
            CharacterClass("1" ... "9")
            ZeroOrMore {
                CharacterClass("0" ... "9")
            }
        }
    }
}

/// The complete release version format, with no leading zeros except for a component equal to zero.
///
/// Prefixes, prerelease identifiers, and build metadata are excluded by the repository's tag convention.
fileprivate let pattern: Regex<Substring> = Regex {
    versionComponent
    "."
    versionComponent
    "."
    versionComponent
}

if tag.wholeMatch(of: pattern) != nil {
    exit(EXIT_SUCCESS)
}

print("Invalid semantic version tag: \(tag)")
exit(EXIT_FAILURE)
