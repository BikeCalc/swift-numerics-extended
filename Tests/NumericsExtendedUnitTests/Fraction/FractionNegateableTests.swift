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
    internal init() {}

    private static let negationArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(1, 2), .init(-1, 2)),
        (.init(-1, 2), .init(1, 2)),
        (.init(5, 2), .init(-5, 2)),
        (.init(-5, 2), .init(5, 2))
    ]

    private static let additiveInverseArguments: [Fraction<Int>] = [
        .init(0, 1),
        .init(0, -2),
        .init(1, 2),
        .init(-1, 2),
        .init(5, 2),
        .init(-5, 2)
    ]

    @Test(
        "Negation succeeds",
        arguments: Self.negationArguments
    )
    internal func negationSucceeds(
        value: Fraction<Int>,
        negation: Fraction<Int>
    ) {
        let result: Fraction<Int> = -value
        #expect(result == negation)
    }

    @Test(
        "Negating succeeds",
        arguments: Self.negationArguments
    )
    internal func negatingSucceeds(
        value: Fraction<Int>,
        negation: Fraction<Int>
    ) {
        let result: Fraction<Int> = value.negating()
        #expect(result == negation)
    }

    @Test(
        "Negate succeeds",
        arguments: Self.negationArguments
    )
    internal func negateSucceeds(
        value: Fraction<Int>,
        negation: Fraction<Int>
    ) {
        var result: Fraction<Int> = value
        result.negate()
        #expect(result == negation)
    }

    @Test(
        "Is negative",
        arguments: [
            (.init(1, 2), false),
            (.init(-1, 2), true),
            (.init(5, 2), false),
            (.init(-5, 2), true)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func isNegative(
        value: Fraction<Int>,
        expected: Bool
    ) {
        #expect(value.isNegative == expected)
    }

    @Test(
        "Is positive",
        arguments: [
            (.init(1, 2), true),
            (.init(-1, 2), false),
            (.init(5, 2), true),
            (.init(-5, 2), false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func isPositive(
        value: Fraction<Int>,
        expected: Bool
    ) {
        #expect(value.isPositive == expected)
    }

    @Test(
        "Is signed",
        arguments: [
            (.init(1, 2), true),
            (.init(-1, 2), true),
            (.init(5, 2), true),
            (.init(-5, 2), true)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func isSigned(
        value: Fraction<Int>,
        expected: Bool
    ) {
        #expect(value.isSigned == expected)
    }

    @Test(
        "Is opposite",
        arguments: [
            (.init(1, 2), .init(1, 2), false),
            (.init(-1, 2), .init(-1, 2), false),
            (.init(-1, 2), .init(1, 2), true),
            (.init(1, 2), .init(-1, 2), true),
            (.init(5, 2), .init(5, 2), false),
            (.init(-5, 2), .init(-5, 2), false),
            (.init(-5, 2), .init(5, 2), true),
            (.init(5, 2), .init(-5, 2), true)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func isOpposite(
        value: Fraction<Int>,
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isOpposite(of: other)
        #expect(result == expected)
    }
}

extension FractionNegateableTests {
    @Test(
        "Negating twice returns original value",
        arguments: Self.additiveInverseArguments
    )
    internal func negatingTwiceReturnsOriginalValue(value: Fraction<Int>) {
        let result: Fraction<Int> = value.negating().negating()
        #expect(result == value)
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
            .zero,
            .negativeZero,
            .init(1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
    )
    internal func nanOppositeFollowsRationalRules(other: Fraction<Int>) {
        let firstResult: Bool = Fraction<Int>.nan.isOpposite(of: other)
        #expect(firstResult == false)
        let secondResult: Bool = other.isOpposite(of: .nan)
        #expect(secondResult == false)
    }

    @Test("Negating NaN returns NaN")
    internal func negatingNaNReturnsNaN() {
        let operatorResult: Fraction<Int> = -Fraction<Int>.nan
        let methodResult: Fraction<Int> = Fraction<Int>.nan.negating()
        var mutatingResult: Fraction<Int> = Fraction<Int>.nan
        mutatingResult.negate()
        #expect(operatorResult.isNaN == true)
        #expect(methodResult.isNaN == true)
        #expect(mutatingResult.isNaN == true)
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
            (.negativeInfinity, false),
            (.infinity, true)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func negativeInfinityOppositeFollowsRationalRules(
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = Fraction<Int>.negativeInfinity.isOpposite(of: other)
        #expect(result == expected)
    }

    @Test("Negating negative infinity follows rational rules")
    internal func negatingNegativeInfinityFollowsRationalRules() {
        let operatorResult: Fraction<Int> = -Fraction<Int>.negativeInfinity
        let methodResult: Fraction<Int> = Fraction<Int>.negativeInfinity.negating()
        var mutatingResult: Fraction<Int> = Fraction<Int>.negativeInfinity
        mutatingResult.negate()
        #expect(operatorResult == .infinity)
        #expect(methodResult == .infinity)
        #expect(mutatingResult == .infinity)
    }
}

// MARK: - Negative Zero

extension FractionNegateableTests {
    @Test("Adding negative zero and its negation returns negative zero")
    internal func addingNegativeZeroAndItsNegationReturnsNegativeZero() {
        let value: Fraction<Int> = .init(0, -2)
        let result: Fraction<Int> = value + value.negating()
        #expect(result.isZero == true)
        #expect(result.denominator < 0)
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
            (.negativeZero, true),
            (.zero, false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func negativeZeroOppositeFollowsStoredRepresentationRules(
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = Fraction<Int>.negativeZero.isOpposite(of: other)
        #expect(result == expected)
    }

    @Test(
        "Negating negative zero preserves stored representation",
        arguments: [
            .negativeZero,
            .init(0, -2)
        ] as Array<Fraction<Int>>
    )
    internal func negatingNegativeZeroPreservesStoredRepresentation(value: Fraction<Int>) {
        let operatorResult: Fraction<Int> = -value
        let methodResult: Fraction<Int> = value.negating()
        var mutatingResult: Fraction<Int> = value
        mutatingResult.negate()
        #expect(operatorResult == value)
        #expect(methodResult == value)
        #expect(mutatingResult == value)
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
            (.infinity, false),
            (.negativeInfinity, true)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func positiveInfinityOppositeFollowsRationalRules(
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = Fraction<Int>.infinity.isOpposite(of: other)
        #expect(result == expected)
    }

    @Test("Negating positive infinity follows rational rules")
    internal func negatingPositiveInfinityFollowsRationalRules() {
        let operatorResult: Fraction<Int> = -Fraction<Int>.infinity
        let methodResult: Fraction<Int> = Fraction<Int>.infinity.negating()
        var mutatingResult: Fraction<Int> = Fraction<Int>.infinity
        mutatingResult.negate()
        #expect(operatorResult == .negativeInfinity)
        #expect(methodResult == .negativeInfinity)
        #expect(mutatingResult == .negativeInfinity)
    }
}

// MARK: - Positive Zero

extension FractionNegateableTests {
    @Test(
        "Adding value and its negation returns positive zero",
        arguments: [
            .zero,
            .init(1, 2),
            .init(-1, 2),
            .init(5, 2),
            .init(-5, 2)
        ] as Array<Fraction<Int>>
    )
    internal func addingValueAndItsNegationReturnsPositiveZero(value: Fraction<Int>) {
        let result: Fraction<Int> = value + value.negating()
        #expect(result.isZero == true)
        #expect(result.denominator > 0)
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
            (.zero, true),
            (.negativeZero, false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func positiveZeroOppositeFollowsStoredRepresentationRules(
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = Fraction<Int>.zero.isOpposite(of: other)
        #expect(result == expected)
    }

    @Test(
        "Negating positive zero preserves stored representation",
        arguments: [
            .zero,
            .init(0, 2)
        ] as Array<Fraction<Int>>
    )
    internal func negatingPositiveZeroPreservesStoredRepresentation(value: Fraction<Int>) {
        let operatorResult: Fraction<Int> = -value
        let methodResult: Fraction<Int> = value.negating()
        var mutatingResult: Fraction<Int> = value
        mutatingResult.negate()
        #expect(operatorResult == value)
        #expect(methodResult == value)
        #expect(mutatingResult == value)
    }
}
