// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Negateable Tests")
internal struct FractionNegateableTests {
    private static let negationArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(-1, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2)),
        (Fraction<Int>(5, 2), Fraction<Int>(-5, 2)),
        (Fraction<Int>(-5, 2), Fraction<Int>(5, 2))
    ]

    private static let additiveInverseArguments: [Fraction<Int>] = [
        Fraction<Int>(0, 1),
        Fraction<Int>(0, -2),
        Fraction<Int>(1, 2),
        Fraction<Int>(-1, 2),
        Fraction<Int>(5, 2),
        Fraction<Int>(-5, 2)
    ]

    @Test(
        "Negation succeeds",
        arguments: Self.negationArguments
    )
    internal func negationSucceeds(
        value: Fraction<Int>,
        negation: Fraction<Int>
    ) {
        #expect(-value == negation)
    }

    @Test(
        "Negating succeeds",
        arguments: Self.negationArguments
    )
    internal func negatingSucceeds(
        value: Fraction<Int>,
        negation: Fraction<Int>
    ) {
        #expect(value.negating() == negation)
    }

    @Test(
        "Negate succeeds",
        arguments: Self.negationArguments
    )
    internal func negateSucceeds(
        value: Fraction<Int>,
        negation: Fraction<Int>
    ) {
        var runningValue: Fraction<Int> = value
        runningValue.negate()
        #expect(runningValue == negation)
    }

    @Test(
        "Is negative",
        arguments: [
            (Fraction<Int>(1, 2), false),
            (Fraction<Int>(-1, 2), true),
            (Fraction<Int>(5, 2), false),
            (Fraction<Int>(-5, 2), true)
        ]
    )
    internal func isNegative(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isNegative == result)
    }

    @Test(
        "Is positive",
        arguments: [
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 2), false),
            (Fraction<Int>(5, 2), true),
            (Fraction<Int>(-5, 2), false)
        ]
    )
    internal func isPositive(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isPositive == result)
    }

    @Test(
        "Is signed",
        arguments: [
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 2), true),
            (Fraction<Int>(5, 2), true),
            (Fraction<Int>(-5, 2), true)
        ]
    )
    internal func isSigned(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isSigned == result)
    }

    @Test(
        "Is opposite",
        arguments: [
            (Fraction<Int>(1, 2), Fraction<Int>(1, 2), false),
            (Fraction<Int>(-1, 2), Fraction<Int>(-1, 2), false),
            (Fraction<Int>(-1, 2), Fraction<Int>(1, 2), true),
            (Fraction<Int>(1, 2), Fraction<Int>(-1, 2), true),
            (Fraction<Int>(5, 2), Fraction<Int>(5, 2), false),
            (Fraction<Int>(-5, 2), Fraction<Int>(-5, 2), false),
            (Fraction<Int>(-5, 2), Fraction<Int>(5, 2), true),
            (Fraction<Int>(5, 2), Fraction<Int>(-5, 2), true)
        ]
    )
    internal func isOpposite(
        value: Fraction<Int>,
        other: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isOpposite(of: other) == result)
    }
}

extension FractionNegateableTests {
    @Test(
        "Negating twice returns original value",
        arguments: Self.additiveInverseArguments
    )
    internal func negatingTwiceReturnsOriginalValue(value: Fraction<Int>) {
        #expect(value.negating().negating() == value)
    }
}

// MARK: - IntMin

extension FractionNegateableTests {
    @Test("Negating Int minimum numerator traps")
    internal func negatingIntMinimumNumeratorTraps() async {
        await #expect(processExitsWith: .failure) {
            _ = -Fraction<Int>(Int.min, 1)
        }
    }
}

// MARK: - NaN

extension FractionNegateableTests {
    @Test("NaN sign predicates follow rational rules")
    internal func nanSignPredicatesFollowRationalRules() {
        #expect(Fraction<Int>.nan.isNegative == false)
        #expect(Fraction<Int>.nan.isPositive == false)
        #expect(Fraction<Int>.nan.isSigned == true)
    }

    @Test(
        "NaN opposite follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func nanOppositeFollowsRationalRules(other: Fraction<Int>) {
        #expect(Fraction<Int>.nan.isOpposite(of: other) == false)
        #expect(other.isOpposite(of: .nan) == false)
    }

    @Test("Negating NaN returns NaN")
    internal func negatingNaNReturnsNaN() {
        let operatorNegation: Fraction<Int> = -Fraction<Int>.nan
        let methodNegation: Fraction<Int> = Fraction<Int>.nan.negating()
        var mutatingNegation: Fraction<Int> = Fraction<Int>.nan
        mutatingNegation.negate()

        #expect(operatorNegation.isNaN == true)
        #expect(methodNegation.isNaN == true)
        #expect(mutatingNegation.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionNegateableTests {
    @Test("Negative infinity sign predicates follow rational rules")
    internal func negativeInfinitySignPredicatesFollowRationalRules() {
        #expect(Fraction<Int>.negativeInfinity.isNegative == true)
        #expect(Fraction<Int>.negativeInfinity.isPositive == false)
        #expect(Fraction<Int>.negativeInfinity.isSigned == true)
    }

    @Test(
        "Negative infinity opposite follows rational rules",
        arguments: [
            (Fraction<Int>.negativeInfinity, false),
            (Fraction<Int>.infinity, true)
        ]
    )
    internal func negativeInfinityOppositeFollowsRationalRules(
        other: Fraction<Int>,
        result: Bool
    ) {
        #expect(Fraction<Int>.negativeInfinity.isOpposite(of: other) == result)
    }

    @Test("Negating negative infinity follows rational rules")
    internal func negatingNegativeInfinityFollowsRationalRules() {
        let operatorNegation: Fraction<Int> = -Fraction<Int>.negativeInfinity
        let methodNegation: Fraction<Int> = Fraction<Int>.negativeInfinity.negating()
        var mutatingNegation: Fraction<Int> = Fraction<Int>.negativeInfinity
        mutatingNegation.negate()

        #expect(operatorNegation == .infinity)
        #expect(methodNegation == .infinity)
        #expect(mutatingNegation == .infinity)
    }
}

// MARK: - Negative Zero

extension FractionNegateableTests {
    @Test("Adding negative zero and its negation returns negative zero")
    internal func addingNegativeZeroAndItsNegationReturnsNegativeZero() {
        let value: Fraction<Int> = .init(0, -2)
        let sum: Fraction<Int> = value + value.negating()
        #expect(sum.isZero == true)
        #expect(sum.denominator < 0)
    }

    @Test("Negative zero sign predicates follow stored denominator rules")
    internal func negativeZeroSignPredicatesFollowStoredDenominatorRules() {
        #expect(Fraction<Int>.negativeZero.isNegative == true)
        #expect(Fraction<Int>.negativeZero.isPositive == false)
        #expect(Fraction<Int>.negativeZero.isSigned == true)
    }

    @Test(
        "Negative zero opposite follows stored representation rules",
        arguments: [
            (Fraction<Int>.negativeZero, true),
            (Fraction<Int>.zero, false)
        ]
    )
    internal func negativeZeroOppositeFollowsStoredRepresentationRules(
        other: Fraction<Int>,
        result: Bool
    ) {
        #expect(Fraction<Int>.negativeZero.isOpposite(of: other) == result)
    }

    @Test(
        "Negating negative zero preserves stored representation",
        arguments: [
            Fraction<Int>.negativeZero,
            Fraction<Int>(0, -2)
        ]
    )
    internal func negatingNegativeZeroPreservesStoredRepresentation(value: Fraction<Int>) {
        let operatorNegation: Fraction<Int> = -value
        let methodNegation: Fraction<Int> = value.negating()
        var mutatingNegation: Fraction<Int> = value
        mutatingNegation.negate()

        #expect(operatorNegation == value)
        #expect(methodNegation == value)
        #expect(mutatingNegation == value)
    }
}

// MARK: - Positive Infinity

extension FractionNegateableTests {
    @Test("Positive infinity sign predicates follow rational rules")
    internal func positiveInfinitySignPredicatesFollowRationalRules() {
        #expect(Fraction<Int>.infinity.isNegative == false)
        #expect(Fraction<Int>.infinity.isPositive == true)
        #expect(Fraction<Int>.infinity.isSigned == true)
    }

    @Test(
        "Positive infinity opposite follows rational rules",
        arguments: [
            (Fraction<Int>.infinity, false),
            (Fraction<Int>.negativeInfinity, true)
        ]
    )
    internal func positiveInfinityOppositeFollowsRationalRules(
        other: Fraction<Int>,
        result: Bool
    ) {
        #expect(Fraction<Int>.infinity.isOpposite(of: other) == result)
    }

    @Test("Negating positive infinity follows rational rules")
    internal func negatingPositiveInfinityFollowsRationalRules() {
        let operatorNegation: Fraction<Int> = -Fraction<Int>.infinity
        let methodNegation: Fraction<Int> = Fraction<Int>.infinity.negating()
        var mutatingNegation: Fraction<Int> = Fraction<Int>.infinity
        mutatingNegation.negate()

        #expect(operatorNegation == .negativeInfinity)
        #expect(methodNegation == .negativeInfinity)
        #expect(mutatingNegation == .negativeInfinity)
    }
}

// MARK: - Positive Zero

extension FractionNegateableTests {
    @Test(
        "Adding value and its negation returns positive zero",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>(1, 2),
            Fraction<Int>(-1, 2),
            Fraction<Int>(5, 2),
            Fraction<Int>(-5, 2)
        ]
    )
    internal func addingValueAndItsNegationReturnsPositiveZero(value: Fraction<Int>) {
        let sum: Fraction<Int> = value + value.negating()
        #expect(sum.isZero == true)
        #expect(sum.denominator > 0)
    }

    @Test("Positive zero sign predicates follow stored denominator rules")
    internal func positiveZeroSignPredicatesFollowStoredDenominatorRules() {
        #expect(Fraction<Int>.zero.isNegative == false)
        #expect(Fraction<Int>.zero.isPositive == false)
        #expect(Fraction<Int>.zero.isSigned == true)
    }

    @Test(
        "Positive zero opposite follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, true),
            (Fraction<Int>.negativeZero, false)
        ]
    )
    internal func positiveZeroOppositeFollowsStoredRepresentationRules(
        other: Fraction<Int>,
        result: Bool
    ) {
        #expect(Fraction<Int>.zero.isOpposite(of: other) == result)
    }

    @Test(
        "Negating positive zero preserves stored representation",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>(0, 2)
        ]
    )
    internal func negatingPositiveZeroPreservesStoredRepresentation(value: Fraction<Int>) {
        let operatorNegation: Fraction<Int> = -value
        let methodNegation: Fraction<Int> = value.negating()
        var mutatingNegation: Fraction<Int> = value
        mutatingNegation.negate()

        #expect(operatorNegation == value)
        #expect(methodNegation == value)
        #expect(mutatingNegation == value)
    }
}
