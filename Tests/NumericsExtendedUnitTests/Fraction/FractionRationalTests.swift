// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Rational Tests")
internal struct FractionRationalTests {
    @Test(
        "Whole initialization uses denominator one",
        arguments: [
            -2,
            -1,
            1,
            2
        ]
    )
    internal func wholeInitializationUsesDenominatorOne(integer: Int) {
        let value: Fraction<Int> = .init(integer)

        #expect(value.numerator == integer)
        #expect(value.denominator == 1)
    }

    @Test(
        "Is one",
        arguments: [
            (Fraction<Int>(1, 1), true),
            (Fraction<Int>(3, 3), true),
            (Fraction<Int>(-3, -3), true),
            (Fraction<Int>(-1, 1), false)
        ]
    )
    internal func isOne(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isOne == result)
    }

    @Test(
        "Is whole",
        arguments: [
            (Fraction<Int>(4, 2), true),
            (Fraction<Int>(-4, -2), true),
            (Fraction<Int>(3, 2), false),
            (Fraction<Int>(-4, 2), false)
        ]
    )
    internal func isWhole(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isWhole == result)
    }

    @Test(
        "Is proper",
        arguments: [
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 2), true),
            (Fraction<Int>(2, 2), false),
            (Fraction<Int>(-2, 2), false)
        ]
    )
    internal func isProper(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isProper == result)
    }

    @Test(
        "Is improper",
        arguments: [
            (Fraction<Int>(3, 2), true),
            (Fraction<Int>(-3, 2), true),
            (Fraction<Int>(2, 2), true),
            (Fraction<Int>(1, 2), false)
        ]
    )
    internal func isImproper(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isImproper == result)
    }

    @Test(
        "Is unit",
        arguments: [
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, -2), false),
            (Fraction<Int>(1, -2), false),
            (Fraction<Int>(2, 4), false)
        ]
    )
    internal func isUnit(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isUnit == result)
    }

    @Test(
        "Quotient",
        arguments: [
            (Fraction<Int>(1, 2), 0.5),
            (Fraction<Int>(-1, 2), -0.5),
            (Fraction<Int>(4, 2), 2.0),
            (Fraction<Int>(-4, 2), -2.0)
        ]
    )
    internal func quotient(
        value: Fraction<Int>,
        result: Double
    ) {
        #expect(value.quotient == result)
    }

    @Test(
        "Is like",
        arguments: [
            (Fraction<Int>(1, 4), Fraction<Int>(3, 4), true),
            (Fraction<Int>(1, 2), Fraction<Int>(2, 4), false),
            (Fraction<Int>(1, -4), Fraction<Int>(3, -4), true),
            (Fraction<Int>(1, -2), Fraction<Int>(2, -4), false)
        ]
    )
    internal func isLike(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect(lhs.isLike(rhs) == result)
    }
}

// MARK: - IntMin

extension FractionRationalTests {
    @Test("Int minimum over negative one is whole")
    internal func intMinimumOverNegativeOneIsWhole() {
        let value: Fraction<Int> = .init(Int.min, -1)

        #expect(value.isWhole == true)
    }
}

// MARK: - NaN

extension FractionRationalTests {
    @Test("NaN properties follow rational rules")
    internal func nanPropertiesFollowRationalRules() {
        let value: Fraction<Int> = .nan

        #expect(value.isOne == false)
        #expect(value.isWhole == false)
        #expect(value.isProper == false)
        #expect(value.isImproper == false)
        #expect(value.isUnit == false)
        #expect(value.quotient.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionRationalTests {
    @Test("Negative infinity properties follow rational rules")
    internal func negativeInfinityPropertiesFollowRationalRules() {
        let value: Fraction<Int> = .negativeInfinity

        #expect(value.isOne == false)
        #expect(value.isWhole == false)
        #expect(value.isProper == false)
        #expect(value.isImproper == false)
        #expect(value.isUnit == false)
        #expect(value.quotient == Double.negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionRationalTests {
    @Test(
        "Negative zero properties follow rational rules",
        arguments: [
            Fraction<Int>.negativeZero,
            Fraction<Int>(0, -2)
        ]
    )
    internal func negativeZeroPropertiesFollowRationalRules(value: Fraction<Int>) {
        #expect(value.isOne == false)
        #expect(value.isWhole == true)
        #expect(value.isProper == false)
        #expect(value.isImproper == false)
        #expect(value.isUnit == false)

        let quotient: Double = value.quotient

        #expect(quotient == .zero)
        #expect(quotient.sign == .minus)
    }
}

// MARK: - Positive Infinity

extension FractionRationalTests {
    @Test("Positive infinity properties follow rational rules")
    internal func positiveInfinityPropertiesFollowRationalRules() {
        let value: Fraction<Int> = .infinity

        #expect(value.isOne == false)
        #expect(value.isWhole == false)
        #expect(value.isProper == false)
        #expect(value.isImproper == false)
        #expect(value.isUnit == false)
        #expect(value.quotient == Double.infinity)
    }
}

// MARK: - Positive Zero

extension FractionRationalTests {
    @Test(
        "Positive zero properties follow rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>(0, 2)
        ]
    )
    internal func positiveZeroPropertiesFollowRationalRules(value: Fraction<Int>) {
        #expect(value.isOne == false)
        #expect(value.isWhole == true)
        #expect(value.isProper == false)
        #expect(value.isImproper == false)
        #expect(value.isUnit == false)

        let quotient: Double = value.quotient

        #expect(quotient == .zero)
        #expect(quotient.sign == .plus)
    }
}
