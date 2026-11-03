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
        (.init(1, 2), .init(1, 2), .init(2, 2)),
        (.init(1, 2), .init(2, 3), .init(3, 4)),
        (.init(-1, 2), .init(1, 2), .init(-2, 2)),
        (.init(-1, 2), .init(-2, 3), .init(-3, -4))
    ]

    private static let remainderArguments: [(Fraction<Int>, Fraction<Int>.RemainderDivisor, Fraction<Int>)] = [
        (.init(1, 2), .init(1, 2), .init(0, 2)),
        (.init(2, 3), .init(1, 2), .init(1, 6)),
        (.init(2, 3), .init(-1, 2), .init(1, 6)),
        (.init(-2, 3), .init(1, 2), .init(-1, 6)),
        (.init(-2, 3), .init(-1, 2), .init(-1, 6))
    ]

    private static let halvingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(1, 2), .init(1, 4)),
        (.init(2, 3), .init(2, 6)),
        (.init(-1, 2), .init(-1, 4)),
        (.init(-2, 3), .init(-2, 6))
    ]

    @Test(
        "Reciprocal",
        arguments: [
            (.init(1, 1), Fraction<Int>(1, 1) as Fraction<Int>?),
            (.init(-1, 1), Fraction<Int>(1, -1)),
            (.init(2, 1), Fraction<Int>(1, 2)),
            (.init(-2, 1), Fraction<Int>(1, -2))
        ] as Array<(Fraction<Int>, Fraction<Int>.Reciprocal?)>
    )
    internal func reciprocal(
        dividend: Fraction<Int>,
        expected: Fraction<Int>.Reciprocal?
    ) {
        #expect(dividend.reciprocal == expected)
    }

    @Test(
        "Is invertible",
        arguments: [
            .init(2, 1),
            .init(3, 1),
            .init(-2, 1),
            .init(-3, 1)
        ] as Array<Fraction<Int>>
    )
    internal func isInvertible(dividend: Fraction<Int>) {
        let result: Bool = dividend.isInvertible
        #expect(result == true)
    }

    @Test(
        "Is divisible by",
        arguments: [
            (.init(6, 1), .init(3, 1), true),
            (.init(7, 1), .init(3, 1), false),
            (.init(-6, 1), .init(3, 1), true),
            (.init(-7, 1), .init(3, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
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
            (.init(3, 1), .init(6, 1), true),
            (.init(3, 1), .init(7, 1), false),
            (.init(3, 1), .init(-6, 1), true),
            (.init(3, 1), .init(-7, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
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
            (.init(1, 2), .init(2, 3)),
            (.init(-1, 2), .init(1, 2)),
            (.init(-1, 2), .init(-2, 3))
        ] as Array<(Fraction<Int>, Fraction<Int>.Divisor)>
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
            .zero,
            .negativeZero,
            .init(2, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
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
            .zero,
            .negativeZero
        ] as Array<Fraction<Int>.Divisor>
    )
    internal func dividingPositiveZeroByPositiveOrNegativeZeroReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.zero / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing negative zero by positive or negative zero returns NaN",
        arguments: [
            .zero,
            .negativeZero
        ] as Array<Fraction<Int>.Divisor>
    )
    internal func dividingNegativeZeroByPositiveOrNegativeZeroReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.negativeZero / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing positive infinity by infinity returns NaN",
        arguments: [
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>.Divisor>
    )
    internal func dividingPositiveInfinityByInfinityReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.infinity / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing negative infinity by infinity returns NaN",
        arguments: [
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>.Divisor>
    )
    internal func dividingNegativeInfinityByInfinityReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing NaN returns NaN",
        arguments: [
            .nan,
            .zero,
            .negativeZero,
            .init(1, 1),
            .init(-1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>.Divisor>
    )
    internal func dividingNaNReturnsNaN(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.nan / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing by NaN returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            .init(1, 1),
            .init(-1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
    )
    internal func dividingByNaNReturnsNaN(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend / Fraction<Int>.nan
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of positive infinity returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            .init(1, 1),
            .init(-1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>.RemainderDivisor>
    )
    internal func remainderOfPositiveInfinityReturnsNaN(divisor: Fraction<Int>.RemainderDivisor) {
        let result: Fraction<Int> = Fraction<Int>.infinity % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of negative infinity returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            .init(1, 1),
            .init(-1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>.RemainderDivisor>
    )
    internal func remainderOfNegativeInfinityReturnsNaN(divisor: Fraction<Int>.RemainderDivisor) {
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by positive zero returns NaN",
        arguments: [
            .init(1, 1),
            .init(-1, 1)
        ] as Array<Fraction<Int>>
    )
    internal func remainderByPositiveZeroReturnsNaN(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % Fraction<Int>.zero
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by negative zero returns NaN",
        arguments: [
            .init(1, 1),
            .init(-1, 1)
        ] as Array<Fraction<Int>>
    )
    internal func remainderByNegativeZeroReturnsNaN(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % Fraction<Int>.negativeZero
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of NaN returns NaN",
        arguments: [
            .nan,
            .zero,
            .negativeZero,
            .init(1, 1),
            .init(-1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>.RemainderDivisor>
    )
    internal func remainderOfNaNReturnsNaN(divisor: Fraction<Int>.RemainderDivisor) {
        let result: Fraction<Int> = Fraction<Int>.nan % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by NaN returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            .init(1, 1),
            .init(-1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
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
            .zero,
            .negativeZero,
            .init(2, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
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
            (.init(1, 1), .negativeInfinity),
            (.init(-1, 1), .infinity)
        ] as Array<(Fraction<Int>.Divisor, Fraction<Int>)>
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
            (.init(1, 1), .negativeZero),
            (.init(-1, 1), .zero)
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            .init(1, 2),
            .init(-1, 2),
            .zero,
            .negativeZero
        ] as Array<Fraction<Int>>
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
            (.init(6, 1), .init(6, -1)),
            (.init(4, 1), .init(4, -1)),
            (.init(-6, 1), .init(-6, -1)),
            (.init(-4, 1), .init(-4, -1))
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            (.zero, false, false),
            (.negativeZero, false, false),
            (.init(2, 1), true, false),
            (.infinity, false, false),
            (.negativeInfinity, false, false)
        ] as Array<(Fraction<Int>, Bool, Bool)>
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
            (.init(1, 1), .negativeZero),
            (.init(-1, 1), .zero)
        ] as Array<(Fraction<Int>.Divisor, Fraction<Int>)>
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
            (.init(1, 1), .negativeInfinity),
            (.init(-1, 1), .infinity)
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            .zero,
            .negativeZero,
            .init(2, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
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
            (.init(1, 1), .infinity),
            (.init(-1, 1), .negativeInfinity)
        ] as Array<(Fraction<Int>.Divisor, Fraction<Int>)>
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
            (.init(1, 1), .zero),
            (.init(-1, 1), .negativeZero)
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            .init(1, 2),
            .init(-1, 2),
            .zero,
            .negativeZero
        ] as Array<Fraction<Int>>
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
            .init(6, 1),
            .init(4, 1),
            .init(-6, 1),
            .init(-4, 1)
        ] as Array<Fraction<Int>>
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
            .init(2, 1),
            .init(-3, 1),
            .init(3, 1)
        ] as Array<Fraction<Int>.Divisor>
    )
    internal func dividingPositiveZeroByNonzeroValueReturnsPositiveOrNegativeZero(divisor: Fraction<Int>.Divisor) {
        let result: Fraction<Int> = Fraction<Int>.zero / divisor
        #expect(result.isZero == true)
    }

    @Test(
        "Positive zero divisibility follows rational rules",
        arguments: [
            (.zero, false, false),
            (.negativeZero, false, false),
            (.init(2, 1), true, false),
            (.infinity, false, false),
            (.negativeInfinity, false, false)
        ] as Array<(Fraction<Int>, Bool, Bool)>
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
            (.init(1, 1), .zero),
            (.init(-1, 1), .negativeZero)
        ] as Array<(Fraction<Int>.Divisor, Fraction<Int>)>
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
            (.init(1, 1), .infinity),
            (.init(-1, 1), .negativeInfinity)
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            .init(6, 1),
            .init(4, 1),
            .init(-6, 1),
            .init(-4, 1)
        ] as Array<Fraction<Int>>
    )
    internal func remainderBySelfReturnsPositiveZero(dividend: Fraction<Int>) {
        let result: Fraction<Int> = dividend % dividend
        #expect(result.isZero == true)
        #expect(result.denominator > 0)
    }
}
