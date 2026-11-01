// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Divisible Tests")
internal struct FractionDivisibleTests {
    internal init() {}

    private static let divisionArguments: [(Fraction<Int>, Fraction<Int>.Divisor, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(2, 2)),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), Fraction<Int>(3, 4)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2), Fraction<Int>(-2, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), Fraction<Int>(-3, -4))
    ]

    private static let remainderArguments: [(Fraction<Int>, Fraction<Int>.RemainderDivisor, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(0, 2)),
        (Fraction<Int>(2, 3), Fraction<Int>(1, 2), Fraction<Int>(1, 6)),
        (Fraction<Int>(2, 3), Fraction<Int>(-1, 2), Fraction<Int>(1, 6)),
        (Fraction<Int>(-2, 3), Fraction<Int>(1, 2), Fraction<Int>(-1, 6)),
        (Fraction<Int>(-2, 3), Fraction<Int>(-1, 2), Fraction<Int>(-1, 6))
    ]

    private static let halvingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 4)),
        (Fraction<Int>(2, 3), Fraction<Int>(2, 6)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-1, 4)),
        (Fraction<Int>(-2, 3), Fraction<Int>(-2, 6))
    ]

    @Test(
        "Reciprocal",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>(1, 1) as Fraction<Int>?),
            (Fraction<Int>(-1, 1), Fraction<Int>(1, -1)),
            (Fraction<Int>(2, 1), Fraction<Int>(1, 2)),
            (Fraction<Int>(-2, 1), Fraction<Int>(1, -2))
        ]
    )
    internal func reciprocal(
        dividend: Fraction<Int>,
        expected: Fraction<Int>?
    ) {
        #expect(dividend.reciprocal == expected)
    }

    @Test(
        "Is divisible by",
        arguments: [
            (Fraction<Int>(6, 1), Fraction<Int>(3, 1), true),
            (Fraction<Int>(7, 1), Fraction<Int>(3, 1), false),
            (Fraction<Int>(-6, 1), Fraction<Int>(3, 1), true),
            (Fraction<Int>(-7, 1), Fraction<Int>(3, 1), false)
        ]
    )
    internal func isDivisibleBy(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = dividend.isDivisible(by: divisor)
        #expect(result == expected)
    }

    @Test(
        "Is factor of",
        arguments: [
            (Fraction<Int>(3, 1), Fraction<Int>(6, 1), true),
            (Fraction<Int>(3, 1), Fraction<Int>(7, 1), false),
            (Fraction<Int>(3, 1), Fraction<Int>(-6, 1), true),
            (Fraction<Int>(3, 1), Fraction<Int>(-7, 1), false)
        ]
    )
    internal func isFactorOf(
        factor: Fraction<Int>,
        value: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = factor.isFactor(of: value)
        #expect(result == expected)
    }

    @Test(
        "Division succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionSucceeds(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = dividend / divisor
        #expect(result == quotient)
    }

    @Test(
        "Division equal succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionEqualSucceeds(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) {
        var result: Fraction<Int> = dividend
        result /= divisor
        #expect(result == quotient)
    }

    @Test(
        "Remainder succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderSucceeds(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.RemainderDivisor,
        remainder: Fraction<Int>
    ) {
        let result: Fraction<Int> = dividend % divisor
        #expect(result == remainder)
    }

    @Test(
        "Remainder equal succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualSucceeds(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.RemainderDivisor,
        remainder: Fraction<Int>
    ) {
        var result: Fraction<Int> = dividend
        result %= divisor
        #expect(result == remainder)
    }

    @Test(
        "Dividing by succeeds",
        arguments: Self.divisionArguments
    )
    internal func dividingBySucceeds(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) throws {
        let result: Fraction<Int> = try dividend.dividing(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Divide by succeeds",
        arguments: Self.divisionArguments
    )
    internal func divideBySucceeds(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) throws {
        var result: Fraction<Int> = dividend
        try result.divide(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Halved succeeds",
        arguments: Self.halvingArguments
    )
    internal func halvedSucceeds(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = dividend.halved()
        #expect(result == quotient)
    }

    @Test(
        "Halve succeeds",
        arguments: Self.halvingArguments
    )
    internal func halveSucceeds(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        var result: Fraction<Int> = dividend
        result.halve()
        #expect(result == quotient)
    }
}

extension FractionDivisibleTests {
    @Test(
        "Division is not commutative",
        arguments: [
            (Fraction<Int>(1, 2), Fraction<Int>(2, 3)),
            (Fraction<Int>(-1, 2), Fraction<Int>(1, 2)),
            (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3))
        ]
    )
    internal func divisionIsNotCommutative(
        dividend: Fraction<Int>,
        divisor: Fraction<Int>.Divisor
    ) {
        let result: Fraction<Int> = dividend / divisor
        #expect(result != divisor / dividend)
    }
}

// MARK: - NaN

extension FractionDivisibleTests {
    @Test(
        "NaN divisibility follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(2, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func nanDivisibilityFollowsRationalRules(other: Fraction<Int>) {
        let isDivisibleResult: Bool = Fraction<Int>.nan.isDivisible(by: other)
        #expect(isDivisibleResult == false)
        let isFactorResult: Bool = Fraction<Int>.nan.isFactor(of: other)
        #expect(isFactorResult == false)
    }

    @Test("Reciprocal of NaN returns nil")
    internal func reciprocalOfNaNReturnsNil() {
        #expect(Fraction<Int>.nan.reciprocal == nil)
    }

    @Test("NaN is not invertible")
    internal func nanIsNotInvertible() {
        #expect(Fraction<Int>.nan.isInvertible == false)
    }

    @Test(
        "Dividing positive zero by positive or negative zero returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero
        ]
    )
    internal func dividingPositiveZeroByPositiveOrNegativeZeroReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.zero / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing negative zero by positive or negative zero returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero
        ]
    )
    internal func dividingNegativeZeroByPositiveOrNegativeZeroReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.negativeZero / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing positive infinity by infinity returns NaN",
        arguments: [
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func dividingPositiveInfinityByInfinityReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.infinity / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing negative infinity by infinity returns NaN",
        arguments: [
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func dividingNegativeInfinityByInfinityReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing NaN returns NaN",
        arguments: [
            Fraction<Int>.nan,
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func dividingNaNReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.nan / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing by NaN returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func dividingByNaNReturnsNaN(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend / Fraction<Int>.nan
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of positive infinity returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func remainderOfPositiveInfinityReturnsNaN(divisor: Fraction<Int>.RemainderDivisor) {
        let result: Fraction<Int> = Fraction<Int>.infinity % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of negative infinity returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func remainderOfNegativeInfinityReturnsNaN(divisor: Fraction<Int>.RemainderDivisor) {
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by positive zero returns NaN",
        arguments: [
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1)
        ]
    )
    internal func remainderByPositiveZeroReturnsNaN(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % Fraction<Int>.zero
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by negative zero returns NaN",
        arguments: [
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1)
        ]
    )
    internal func remainderByNegativeZeroReturnsNaN(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % Fraction<Int>.negativeZero
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of NaN returns NaN",
        arguments: [
            Fraction<Int>.nan,
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func remainderOfNaNReturnsNaN(divisor: Fraction<Int>.RemainderDivisor) {
        let result: Fraction<Int> = Fraction<Int>.nan % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by NaN returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func remainderByNaNReturnsNaN(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % Fraction<Int>.nan
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionDivisibleTests {
    @Test(
        "Negative infinity divisibility follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(2, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func negativeInfinityDivisibilityFollowsRationalRules(other: Fraction<Int>) {
        let isDivisibleResult: Bool = Fraction<Int>.negativeInfinity.isDivisible(by: other)
        #expect(isDivisibleResult == false)
        let isFactorResult: Bool = Fraction<Int>.negativeInfinity.isFactor(of: other)
        #expect(isFactorResult == false)
    }

    @Test("Reciprocal of negative infinity returns negative zero")
    internal func reciprocalOfNegativeInfinityReturnsNegativeZero() {
        #expect(Fraction<Int>.negativeInfinity.reciprocal == Fraction<Int>.negativeZero)
    }

    @Test("Negative infinity is invertible")
    internal func negativeInfinityIsInvertible() {
        #expect(Fraction<Int>.negativeInfinity.isInvertible == true)
    }

    @Test(
        "Dividing negative infinity follows rational rules",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>.negativeInfinity),
            (Fraction<Int>(-1, 1), Fraction<Int>.infinity)
        ]
    )
    internal func dividingNegativeInfinityFollowsRationalRules(
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity / divisor
        #expect(result == quotient)
    }

    @Test(
        "Dividing by negative infinity follows rational rules",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>.negativeZero),
            (Fraction<Int>(-1, 1), Fraction<Int>.zero)
        ]
    )
    internal func dividingByNegativeInfinityFollowsRationalRules(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = dividend / Fraction<Int>.negativeInfinity
        #expect(result == quotient)
    }

    @Test(
        "Remainder by negative infinity preserves dividend",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(-1, 2),
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero
        ]
    )
    internal func remainderByNegativeInfinityPreservesDividend(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % Fraction<Int>.negativeInfinity
        #expect(result == dividend)
    }
}

// MARK: - Negative One

extension FractionDivisibleTests {
    @Test(
        "Dividing by negative one preserves raw quotient terms",
        arguments: [
            (Fraction<Int>(6, 1), Fraction<Int>(6, -1)),
            (Fraction<Int>(4, 1), Fraction<Int>(4, -1)),
            (Fraction<Int>(-6, 1), Fraction<Int>(-6, -1)),
            (Fraction<Int>(-4, 1), Fraction<Int>(-4, -1))
        ]
    )
    internal func dividingByNegativeOnePreservesRawQuotientTerms(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        let operatorResult: Fraction<Int> = dividend / -1
        #expect(operatorResult == quotient)
        let isCanonicallyEqualResult: Bool = quotient.isCanonicallyEqual(to: -dividend)
        #expect(isCanonicallyEqualResult == true)
    }
}

// MARK: - Negative Zero

extension FractionDivisibleTests {
    @Test(
        "Negative zero divisibility follows rational rules",
        arguments: [
            (Fraction<Int>.zero, false, false),
            (Fraction<Int>.negativeZero, false, false),
            (Fraction<Int>(2, 1), true, false),
            (Fraction<Int>.infinity, false, false),
            (Fraction<Int>.negativeInfinity, false, false)
        ]
    )
    internal func negativeZeroDivisibilityFollowsRationalRules(
        other: Fraction<Int>,
        isDivisible: Bool,
        isFactor: Bool
    ) {
        let isDivisibleResult: Bool = Fraction<Int>.negativeZero.isDivisible(by: other)
        #expect(isDivisibleResult == isDivisible)
        let isFactorResult: Bool = Fraction<Int>.negativeZero.isFactor(of: other)
        #expect(isFactorResult == isFactor)
    }

    @Test("Reciprocal of negative zero returns nil")
    internal func reciprocalOfNegativeZeroReturnsNil() {
        #expect(Fraction<Int>.negativeZero.reciprocal == nil)
    }

    @Test("Negative zero is not invertible")
    internal func negativeZeroIsNotInvertible() {
        #expect(Fraction<Int>.negativeZero.isInvertible == false)
    }

    @Test(
        "Dividing negative zero follows rational rules",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>.negativeZero),
            (Fraction<Int>(-1, 1), Fraction<Int>.zero)
        ]
    )
    internal func dividingNegativeZeroFollowsRationalRules(
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.negativeZero / divisor
        #expect(result == quotient)
    }

    @Test(
        "Dividing by negative zero follows rational rules",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>.negativeInfinity),
            (Fraction<Int>(-1, 1), Fraction<Int>.infinity)
        ]
    )
    internal func dividingByNegativeZeroFollowsRationalRules(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = dividend / Fraction<Int>.negativeZero
        #expect(result == quotient)
    }
}

// MARK: - Positive Infinity

extension FractionDivisibleTests {
    @Test(
        "Positive infinity divisibility follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(2, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func positiveInfinityDivisibilityFollowsRationalRules(other: Fraction<Int>) {
        let isDivisibleResult: Bool = Fraction<Int>.infinity.isDivisible(by: other)
        #expect(isDivisibleResult == false)
        let isFactorResult: Bool = Fraction<Int>.infinity.isFactor(of: other)
        #expect(isFactorResult == false)
    }

    @Test("Reciprocal of positive infinity returns positive zero")
    internal func reciprocalOfPositiveInfinityReturnsPositiveZero() {
        #expect(Fraction<Int>.infinity.reciprocal == Fraction<Int>.zero)
    }

    @Test("Positive infinity is invertible")
    internal func positiveInfinityIsInvertible() {
        #expect(Fraction<Int>.infinity.isInvertible == true)
    }

    @Test(
        "Dividing positive infinity follows rational rules",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>.infinity),
            (Fraction<Int>(-1, 1), Fraction<Int>.negativeInfinity)
        ]
    )
    internal func dividingPositiveInfinityFollowsRationalRules(
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.infinity / divisor
        #expect(result == quotient)
    }

    @Test(
        "Dividing by positive infinity follows rational rules",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>.zero),
            (Fraction<Int>(-1, 1), Fraction<Int>.negativeZero)
        ]
    )
    internal func dividingByPositiveInfinityFollowsRationalRules(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = dividend / Fraction<Int>.infinity
        #expect(result == quotient)
    }

    @Test(
        "Remainder by positive infinity preserves dividend",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(-1, 2),
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero
        ]
    )
    internal func remainderByPositiveInfinityPreservesDividend(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % Fraction<Int>.infinity
        #expect(result == dividend)
    }
}

// MARK: - Positive One

extension FractionDivisibleTests {
    @Test(
        "Dividing by positive one preserves dividend",
        arguments: [
            Fraction<Int>(6, 1),
            Fraction<Int>(4, 1),
            Fraction<Int>(-6, 1),
            Fraction<Int>(-4, 1)
        ]
    )
    internal func dividingByPositiveOnePreservesDividend(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend / 1
        #expect(result == dividend)
    }
}

// MARK: - Positive Zero

extension FractionDivisibleTests {
    @Test(
        "Dividing positive zero by nonzero value returns positive or negative zero",
        arguments: [
            Fraction<Int>(2, 1),
            Fraction<Int>(-3, 1),
            Fraction<Int>(3, 1)
        ]
    )
    internal func dividingPositiveZeroByNonzeroValueReturnsPositiveOrNegativeZero(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.zero / divisor
        #expect(result.isZero == true)
    }

    @Test(
        "Positive zero divisibility follows rational rules",
        arguments: [
            (Fraction<Int>.zero, false, false),
            (Fraction<Int>.negativeZero, false, false),
            (Fraction<Int>(2, 1), true, false),
            (Fraction<Int>.infinity, false, false),
            (Fraction<Int>.negativeInfinity, false, false)
        ]
    )
    internal func positiveZeroDivisibilityFollowsRationalRules(
        other: Fraction<Int>,
        isDivisible: Bool,
        isFactor: Bool
    ) {
        let isDivisibleResult: Bool = Fraction<Int>.zero.isDivisible(by: other)
        #expect(isDivisibleResult == isDivisible)
        let isFactorResult: Bool = Fraction<Int>.zero.isFactor(of: other)
        #expect(isFactorResult == isFactor)
    }

    @Test("Reciprocal of positive zero returns nil")
    internal func reciprocalOfPositiveZeroReturnsNil() {
        #expect(Fraction<Int>.zero.reciprocal == nil)
    }

    @Test("Positive zero is not invertible")
    internal func positiveZeroIsNotInvertible() {
        #expect(Fraction<Int>.zero.isInvertible == false)
    }

    @Test(
        "Dividing positive zero follows rational rules",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>.zero),
            (Fraction<Int>(-1, 1), Fraction<Int>.negativeZero)
        ]
    )
    internal func dividingPositiveZeroFollowsRationalRules(
        divisor: Fraction<Int>.Divisor,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.zero / divisor
        #expect(result == quotient)
    }

    @Test(
        "Dividing by positive zero follows rational rules",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>.infinity),
            (Fraction<Int>(-1, 1), Fraction<Int>.negativeInfinity)
        ]
    )
    internal func dividingByPositiveZeroFollowsRationalRules(
        dividend: Fraction<Int>,
        quotient: Fraction<Int>
    ) {
        let result: Fraction<Int> = dividend / Fraction<Int>.zero
        #expect(result == quotient)
    }

    @Test(
        "Remainder by self returns positive zero",
        arguments: [
            Fraction<Int>(6, 1),
            Fraction<Int>(4, 1),
            Fraction<Int>(-6, 1),
            Fraction<Int>(-4, 1)
        ]
    )
    internal func remainderBySelfReturnsPositiveZero(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % dividend
        #expect(result.isZero == true)
        #expect(result.denominator > 0)
    }
}
