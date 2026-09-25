// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation
import RegexBuilder

// MARK: - TagValidationError

/// An error produced while validating release tags.
fileprivate enum TagValidationError {
    /// The command-line arguments are missing or invalid.
    case invalidArguments

    /// The tag does not follow the repository's release version format.
    ///
    /// - Parameter tag: The rejected release tag.
    case invalidTag(tag: String)
}

// MARK: - CustomStringConvertible

extension TagValidationError: CustomStringConvertible {
    fileprivate var description: String {
        switch self {
        case .invalidArguments:
            return "Usage: ValidateTag.swift <tag>"
        case .invalidTag(let tag):
            return "Invalid semantic version tag: \(tag)"
        }
    }
}

// MARK: - Error

extension TagValidationError: Error {}

// MARK: - Arguments

/// The command-line arguments used by the validator.
fileprivate struct Arguments {
    /// The release tag to validate.
    fileprivate let tag: String

    /// Parses the values supplied to the validator.
    ///
    /// - Parameter arguments: The arguments following the script name.
    /// - Throws: `TagValidationError.invalidArguments` if the argument count is incorrect.
    fileprivate init(_ arguments: Array<String>) throws(TagValidationError) {
        guard arguments.count == 1 else {
            throw TagValidationError.invalidArguments
        }

        self.tag = arguments[0]
    }
}

// MARK: - TagValidator

/// Validates a release tag against the repository conventions.
fileprivate struct TagValidator {
    /// The input to validate.
    private let arguments: Arguments

    /// Creates a validator for the supplied arguments.
    ///
    /// - Parameter arguments: The input to validate.
    fileprivate init(arguments: Arguments) {
        self.arguments = arguments
    }

    /// The complete release version format, with no leading zeros except for a component equal to zero.
    ///
    /// Prefixes, prerelease identifiers, and build metadata are excluded by the repository's tag convention.
    private let pattern: Regex<Substring> = Regex {
        Self.versionComponent
        "."
        Self.versionComponent
        "."
        Self.versionComponent
    }

    /// A version component consisting of zero or an ASCII decimal integer with no leading zeros.
    private static let versionComponent: Regex<Substring> = Regex {
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

    /// Checks that the input follows the repository conventions.
    ///
    /// - Throws: `TagValidationError` if validation fails.
    fileprivate func run() throws(TagValidationError) {
        guard self.arguments.tag.wholeMatch(of: self.pattern) != nil else {
            throw TagValidationError.invalidTag(tag: self.arguments.tag)
        }
    }
}

// MARK: - Validation

do throws(TagValidationError) {
    let arguments: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let validator: TagValidator = .init(arguments: arguments)
    try validator.run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
