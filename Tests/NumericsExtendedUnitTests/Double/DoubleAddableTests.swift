// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Addable Tests")
internal struct DoubleAddableTests {
    private static let additionArguments: Array<(Double, Double, Double)> = [
        (2.0, 3.0, 5.0),
        (3.0, 4.0, 7.0),
        (-2.0, 3.0, 1.0),
        (-3.0, -4.0, -7.0),
        (0.5, 1.5, 2.0),
        (1.5, 2.5, 4.0),
        (-0.5, 1.5, 1.0),
        (-1.5, -2.5, -4.0)
    ]

    @Test(
        "Addition succeeds",
        arguments: Self.additionArguments
    )
    internal func additionSucceeds(
        augend: Double,
        addend: Double,
        sum: Double
    ) {
        #expect(augend + addend == sum)
    }

    @Test(
        "Addition equal succeeds",
        arguments: Self.additionArguments
    )
    internal func additionEqualSucceeds(
        augend: Double,
        addend: Double,
        sum: Double
    ) {
        var runningSum: Double = augend
        runningSum += addend
        #expect(runningSum == sum)
    }

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: Double,
        addend: Double,
        sum: Double
    ) {
        #expect(augend.adding(addend) == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: Double,
        addend: Double,
        sum: Double
    ) {
        var runningSum: Double = augend
        runningSum.add(addend)
        #expect(runningSum == sum)
    }
}

extension DoubleAddableTests {
    @Test(
        "Addition is commutative",
        arguments: Self.additionArguments
    )
    internal func additionIsCommutative(
        augend: Double,
        addend: Double,
        sum _: Double
    ) {
        #expect(augend + addend == addend + augend)
    }
}

// MARK: - NaN

extension DoubleAddableTests {
    @Test("Adding positive infinity to negative infinity returns NaN")
    internal func addingPositiveInfinityToNegativeInfinityReturnsNaN() {
        #expect((Double.negativeInfinity + .infinity).isNaN == true)
    }

    @Test("Adding negative infinity to positive infinity returns NaN")
    internal func addingNegativeInfinityToPositiveInfinityReturnsNaN() {
        #expect((Double.infinity + .negativeInfinity).isNaN == true)
    }

    @Test(
        "Adding to NaN returns NaN",
        arguments: [
            Double.nan,
            Double.zero,
            Double.negativeZero,
            1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func addingToNaNReturnsNaN(addend: Double) {
        #expect((Double.nan + addend).isNaN == true)
    }

    @Test(
        "Adding NaN returns NaN",
        arguments: [
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func addingNaNReturnsNaN(augend: Double) {
        #expect((augend + Double.nan).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleAddableTests {
    @Test(
        "Adding to negative infinity follows floating-point rules",
        arguments: [
            Double.negativeInfinity,
            1.0,
            -1.0
        ]
    )
    internal func addingToNegativeInfinityFollowsFloatingPointRules(addend: Double) {
        #expect(Double.negativeInfinity + addend == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension DoubleAddableTests {
    @Test(
        "Adding to negative zero follows floating-point rules",
        arguments: [
            (Double.zero, Double.zero),
            (Double.negativeZero, Double.negativeZero),
            (1.0, 1.0),
            (-1.0, -1.0)
        ]
    )
    internal func addingToNegativeZeroFollowsFloatingPointRules(
        addend: Double,
        sum: Double
    ) {
        let result: Double = Double.negativeZero + addend

        #expect(result == sum)
        #expect(result.sign == sum.sign)
    }
}

// MARK: - Positive Infinity

extension DoubleAddableTests {
    @Test(
        "Adding to positive infinity follows floating-point rules",
        arguments: [
            Double.infinity,
            1.0,
            -1.0
        ]
    )
    internal func addingToPositiveInfinityFollowsFloatingPointRules(addend: Double) {
        #expect(Double.infinity + addend == .infinity)
    }
}

// MARK: - Positive Zero

extension DoubleAddableTests {
    @Test(
        "Adding opposite values returns positive zero",
        arguments: [
            (2.0, -2.0),
            (3.0, -3.0),
            (-2.0, 2.0),
            (-3.0, 3.0),
            (0.5, -0.5),
            (1.5, -1.5),
            (-0.5, 0.5),
            (-1.5, 1.5)
        ]
    )
    internal func addingOppositeValuesReturnsPositiveZero(
        augend: Double,
        addend: Double
    ) {
        let sum: Double = augend + addend
        #expect(sum == Double.zero)
        #expect(sum.sign == .plus)
    }

    @Test(
        "Adding positive zero preserves augend",
        arguments: [
            2.0,
            3.0,
            -2.0,
            -3.0,
            0.5,
            1.5,
            -0.5,
            -1.5
        ]
    )
    internal func addingPositiveZeroPreservesAugend(augend: Double) {
        #expect(augend + Double.zero == augend)
    }

    @Test(
        "Adding to positive zero follows floating-point rules",
        arguments: [
            (Double.zero, Double.zero),
            (Double.negativeZero, Double.zero),
            (1.0, 1.0),
            (-1.0, -1.0)
        ]
    )
    internal func addingToPositiveZeroFollowsFloatingPointRules(
        addend: Double,
        sum: Double
    ) {
        let result: Double = Double.zero + addend

        #expect(result == sum)
        #expect(result.sign == sum.sign)
    }
}
