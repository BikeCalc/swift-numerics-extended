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
    private static let simplificationArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 4), Fraction<Int>(1, 2)),
        (Fraction<Int>(-2, 4), Fraction<Int>(-1, 2)),
        (Fraction<Int>(2, -4), Fraction<Int>(1, -2)),
        (Fraction<Int>(-2, -4), Fraction<Int>(-1, -2)),
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-1, 2)),
        (Fraction<Int>(1, -2), Fraction<Int>(1, -2)),
        (Fraction<Int>(-1, -2), Fraction<Int>(-1, -2))
    ]

    @Test(
        "Is simplifiable",
        arguments: [
            (Fraction<Int>(2, 4), true),
            (Fraction<Int>(-2, 4), true),
            (Fraction<Int>(2, -4), true),
            (Fraction<Int>(-2, -4), true),
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 2), true),
            (Fraction<Int>(1, -2), true),
            (Fraction<Int>(-1, -2), true)
        ]
    )
    internal func isSimplifiable(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isSimplifiable == result)
    }

    @Test(
        "Is simplified",
        arguments: [
            (Fraction<Int>(2, 4), false),
            (Fraction<Int>(-2, 4), false),
            (Fraction<Int>(2, -4), false),
            (Fraction<Int>(-2, -4), false),
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 2), true),
            (Fraction<Int>(1, -2), true),
            (Fraction<Int>(-1, -2), true)
        ]
    )
    internal func isSimplified(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isSimplified == result)
    }

    @Test(
        "Simplification succeeds",
        arguments: Self.simplificationArguments
    )
    internal func simplificationSucceeds(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        #expect(value.simplified() == result)
    }

    @Test(
        "Simplify succeeds",
        arguments: Self.simplificationArguments
    )
    internal func simplifySucceeds(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        var runningValue: Fraction<Int> = value
        runningValue.simplify()
        #expect(runningValue == result)
    }

    @Test(
        "Simplification is idempotent",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(2, 4),
            Fraction<Int>(1, -2),
            Fraction<Int>(2, -4)
        ]
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

        #expect(value.simplified() == expected)
    }
}

// MARK: - NaN

extension FractionSimplifiableTests {
    @Test("NaN simplification follows rational rules")
    internal func nanSimplificationFollowsRationalRules() {
        #expect(Fraction<Int>.nan.isSimplifiable == true)
        #expect(Fraction<Int>.nan.isSimplified == true)
        #expect(Fraction<Int>.nan.simplified().isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionSimplifiableTests {
    @Test("Negative infinity simplification follows rational rules")
    internal func negativeInfinitySimplificationFollowsRationalRules() {
        #expect(Fraction<Int>.negativeInfinity.isSimplifiable == true)
        #expect(Fraction<Int>.negativeInfinity.isSimplified == true)
        #expect(Fraction<Int>.negativeInfinity.simplified() == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionSimplifiableTests {
    @Test(
        "Negative zero simplification follows rational rules",
        arguments: [
            (Fraction<Int>.negativeZero, true),
            (Fraction<Int>(0, -2), false)
        ]
    )
    internal func negativeZeroSimplificationFollowsRationalRules(
        value: Fraction<Int>,
        isSimplified: Bool
    ) {
        #expect(value.isSimplifiable == true)
        #expect(value.isSimplified == isSimplified)
        #expect(value.simplified() == .negativeZero)
    }
}

// MARK: - Positive Infinity

extension FractionSimplifiableTests {
    @Test("Positive infinity simplification follows rational rules")
    internal func positiveInfinitySimplificationFollowsRationalRules() {
        #expect(Fraction<Int>.infinity.isSimplifiable == true)
        #expect(Fraction<Int>.infinity.isSimplified == true)
        #expect(Fraction<Int>.infinity.simplified() == .infinity)
    }
}

// MARK: - Positive Zero

extension FractionSimplifiableTests {
    @Test(
        "Positive zero simplification follows rational rules",
        arguments: [
            (Fraction<Int>.zero, true),
            (Fraction<Int>(0, 2), false)
        ]
    )
    internal func positiveZeroSimplificationFollowsRationalRules(
        value: Fraction<Int>,
        isSimplified: Bool
    ) {
        #expect(value.isSimplifiable == true)
        #expect(value.isSimplified == isSimplified)
        #expect(value.simplified() == .zero)
    }
}
