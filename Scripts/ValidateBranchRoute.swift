// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation
import RegexBuilder

// MARK: - BranchRouteValidationError

/// An error produced while validating branch routes.
fileprivate enum BranchRouteValidationError {
    /// The command-line arguments are missing or invalid.
    case invalidArguments

    /// The source branch cannot target the destination branch.
    ///
    /// - Parameters:
    ///   - base: The destination branch.
    ///   - head: The source branch.
    case invalidRoute(
        base: String,
        head: String
    )
}

// MARK: - CustomStringConvertible

extension BranchRouteValidationError: CustomStringConvertible {
    fileprivate var description: String {
        switch self {
        case .invalidArguments:
            return "Usage: ValidateBranchRoute.swift <base> <head>"
        case .invalidRoute(let base, let head):
            return """
                Invalid branch route: \(head) -> \(base)
                Allowed routes:
                - Any branch -> main
                - feature/*, bugfix/*, chore/*, docs/*, or test/* -> release/*
                """
        }
    }
}

// MARK: - Error

extension BranchRouteValidationError: Error {}

// MARK: - Arguments

/// The command-line arguments used by the validator.
fileprivate struct Arguments {
    /// The destination branch of the pull request.
    fileprivate let base: String

    /// The source branch of the pull request.
    fileprivate let head: String

    /// Parses the values supplied to the validator.
    ///
    /// - Parameter arguments: The arguments following the script name.
    /// - Throws: `BranchRouteValidationError.invalidArguments` if the argument count is incorrect.
    fileprivate init(_ arguments: Array<String>) throws(BranchRouteValidationError) {
        guard arguments.count == 2 else {
            throw BranchRouteValidationError.invalidArguments
        }

        self.base = arguments[0]
        self.head = arguments[1]
    }
}

// MARK: - BranchRouteValidator

/// Validates the source and destination branches of a pull request.
fileprivate struct BranchRouteValidator {
    /// The input to validate.
    private let arguments: Arguments

    /// Creates a validator for the supplied arguments.
    ///
    /// - Parameter arguments: The input to validate.
    fileprivate init(arguments: Arguments) {
        self.arguments = arguments
    }

    /// A destination branch beginning with the release prefix.
    private let releaseBranch: Regex<Substring> = Regex {
        "release/"
        ZeroOrMore(.any)
    }

    /// A source branch with one of the prefixes permitted when targeting a release branch.
    private let allowedSourceBranch: Regex<Substring> = Regex {
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

    /// Checks that the input follows the repository conventions.
    ///
    /// - Throws: `BranchRouteValidationError` if validation fails.
    fileprivate func run() throws(BranchRouteValidationError) {
        // Every source branch may target main.
        if self.arguments.base == "main" {
            return
        }

        if self.arguments.base.wholeMatch(of: self.releaseBranch) != nil
            && self.arguments.head.wholeMatch(of: self.allowedSourceBranch) != nil
        {
            return
        }

        throw BranchRouteValidationError.invalidRoute(
            base: self.arguments.base,
            head: self.arguments.head
        )
    }
}

// MARK: - Validation

do throws(BranchRouteValidationError) {
    let arguments: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let validator: BranchRouteValidator = .init(arguments: arguments)
    try validator.run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
