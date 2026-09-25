// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation
import RegexBuilder

// MARK: - PullRequestTitleValidationError

/// An error produced while validating pull request titles.
fileprivate enum PullRequestTitleValidationError {
    /// The command-line arguments are missing or invalid.
    case invalidArguments

    /// The title does not follow the repository's Conventional Commit rules.
    ///
    /// - Parameter title: The rejected pull request title.
    case invalidTitle(title: String)
}

// MARK: - CustomStringConvertible

extension PullRequestTitleValidationError: CustomStringConvertible {
    fileprivate var description: String {
        switch self {
        case .invalidArguments:
            return "Usage: ValidatePullRequestTitle.swift <title>"
        case .invalidTitle(let title):
            return """
                Invalid pull request title: \(title)
                Use the Conventional Commit form:
                <type>[optional scope]: <description>
                Parentheses around a scope are required. Append ! after the type or scope for a breaking change.
                Allowed types: fix, feat, build, chore, ci, docs, style, refactor, perf, test
                """
        }
    }
}

// MARK: - Error

extension PullRequestTitleValidationError: Error {}

// MARK: - Arguments

/// The command-line arguments used by the validator.
fileprivate struct Arguments {
    /// The pull request title to validate.
    fileprivate let title: String

    /// Parses the values supplied to the validator.
    ///
    /// - Parameter arguments: The arguments following the script name.
    /// - Throws: `PullRequestTitleValidationError.invalidArguments` if the argument count is incorrect.
    fileprivate init(_ arguments: Array<String>) throws(PullRequestTitleValidationError) {
        guard arguments.count == 1 else {
            throw PullRequestTitleValidationError.invalidArguments
        }

        self.title = arguments[0]
    }
}

// MARK: - PullRequestTitleValidator

/// Validates a pull request title against the repository conventions.
fileprivate struct PullRequestTitleValidator {
    /// The input to validate.
    private let arguments: Arguments

    /// Creates a validator for the supplied arguments.
    ///
    /// - Parameter arguments: The input to validate.
    fileprivate init(arguments: Arguments) {
        self.arguments = arguments
    }

    /// The allowed commit types, optional scope and breaking-change marker, and required description.
    ///
    /// The description includes line separators to preserve the original validator's treatment of multiline input.
    /// Unicode scalar matching preserves its handling of combining characters beside punctuation.
    private let pattern: Regex<Substring> = Regex {
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

    /// Checks that the input follows the repository conventions.
    ///
    /// - Throws: `PullRequestTitleValidationError` if validation fails.
    fileprivate func run() throws(PullRequestTitleValidationError) {
        guard self.arguments.title.wholeMatch(of: self.pattern) != nil else {
            throw PullRequestTitleValidationError.invalidTitle(title: self.arguments.title)
        }
    }
}

// MARK: - Validation

do throws(PullRequestTitleValidationError) {
    let arguments: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let validator: PullRequestTitleValidator = .init(arguments: arguments)
    try validator.run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
