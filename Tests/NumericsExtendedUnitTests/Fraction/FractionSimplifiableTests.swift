// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Simplifiable Tests")
internal struct FractionSimplifiableTests {
    internal init() {}

    private static let simplificationArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(2, 4), .init(1, 2)),
        (.init(-2, 4), .init(-1, 2)),
        (.init(2, -4), .init(1, -2)),
        (.init(-2, -4), .init(-1, -2)),
        (.init(1, 2), .init(1, 2)),
        (.init(-1, 2), .init(-1, 2)),
        (.init(1, -2), .init(1, -2)),
        (.init(-1, -2), .init(-1, -2))
    ]

    @Test(
        "Is simplifiable",
        arguments: [
            (.init(2, 4), true),
            (.init(-2, 4), true),
            (.init(2, -4), true),
            (.init(-2, -4), true),
            (.init(1, 2), true),
            (.init(-1, 2), true),
            (.init(1, -2), true),
            (.init(-1, -2), true)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func isSimplifiable(
        value: Fraction<Int>,
        expected: Bool
    ) {
        #expect(value.isSimplifiable == expected)
    }

    @Test(
        "Is simplified",
        arguments: [
            (.init(2, 4), false),
            (.init(-2, 4), false),
            (.init(2, -4), false),
            (.init(-2, -4), false),
            (.init(1, 2), true),
            (.init(-1, 2), true),
            (.init(1, -2), true),
            (.init(-1, -2), true)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func isSimplified(
        value: Fraction<Int>,
        expected: Bool
    ) {
        #expect(value.isSimplified == expected)
    }

    @Test(
        "Simplification succeeds",
        arguments: Self.simplificationArguments
    )
    internal func simplificationSucceeds(
        value: Fraction<Int>,
        expected: Fraction<Int>
    ) {
        let result: Fraction<Int> = value.simplified()
        #expect(result == expected)
    }

    @Test(
        "Simplify succeeds",
        arguments: Self.simplificationArguments
    )
    internal func simplifySucceeds(
        value: Fraction<Int>,
        expected: Fraction<Int>
    ) {
        var result: Fraction<Int> = value
        result.simplify()
        #expect(result == expected)
    }

    @Test(
        "Simplification is idempotent",
        arguments: [
            .init(1, 2),
            .init(2, 4),
            .init(1, -2),
            .init(2, -4)
        ] as Array<Fraction<Int>>
    )
    internal func simplificationIsIdempotent(value: Fraction<Int>) {
        let result: Fraction<Int> = value.simplified().simplified()
        #expect(result == value.simplified())
    }
}

// MARK: - IntMin

extension FractionSimplifiableTests {
    @Test("Int minimum terms simplify without overflow")
    internal func intMinimumTermsSimplifyWithoutOverflow() {
        let value: Fraction<Int> = .init(Int.min, Int.min)
        let expected: Fraction<Int> = .init(-1, -1)
        let result: Fraction<Int> = value.simplified()
        #expect(result == expected)
    }
}

// MARK: - NaN

extension FractionSimplifiableTests {
    @Test("NaN simplification follows rational rules")
    internal func nanSimplificationFollowsRationalRules() {
        #expect(Fraction<Int>.nan.isSimplifiable == true)
        #expect(Fraction<Int>.nan.isSimplified == true)
        let result: Fraction<Int> = Fraction<Int>.nan.simplified()
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionSimplifiableTests {
    @Test("Negative infinity simplification follows rational rules")
    internal func negativeInfinitySimplificationFollowsRationalRules() {
        #expect(Fraction<Int>.negativeInfinity.isSimplifiable == true)
        #expect(Fraction<Int>.negativeInfinity.isSimplified == true)
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity.simplified()
        #expect(result == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionSimplifiableTests {
    @Test(
        "Negative zero simplification follows rational rules",
        arguments: [
            (.negativeZero, true),
            (.init(0, -2), false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func negativeZeroSimplificationFollowsRationalRules(
        value: Fraction<Int>,
        isSimplified: Bool
    ) {
        #expect(value.isSimplifiable == true)
        #expect(value.isSimplified == isSimplified)
        let result: Fraction<Int> = value.simplified()
        #expect(result == .negativeZero)
    }
}

// MARK: - Positive Infinity

extension FractionSimplifiableTests {
    @Test("Positive infinity simplification follows rational rules")
    internal func positiveInfinitySimplificationFollowsRationalRules() {
        #expect(Fraction<Int>.infinity.isSimplifiable == true)
        #expect(Fraction<Int>.infinity.isSimplified == true)
        let result: Fraction<Int> = Fraction<Int>.infinity.simplified()
        #expect(result == .infinity)
    }
}

// MARK: - Positive Zero

extension FractionSimplifiableTests {
    @Test(
        "Positive zero simplification follows rational rules",
        arguments: [
            (.zero, true),
            (.init(0, 2), false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func positiveZeroSimplificationFollowsRationalRules(
        value: Fraction<Int>,
        isSimplified: Bool
    ) {
        #expect(value.isSimplifiable == true)
        #expect(value.isSimplified == isSimplified)
        let result: Fraction<Int> = value.simplified()
        #expect(result == .zero)
    }
}
