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
    internal init() {}

    private static let additionArguments: Array<(Double, Double.Addend, Double)> = [
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
        addend: Double.Addend,
        sum: Double
    ) {
        let result: Double = augend + addend
        #expect(result == sum)
    }

    @Test(
        "Addition equal succeeds",
        arguments: Self.additionArguments
    )
    internal func additionEqualSucceeds(
        augend: Double,
        addend: Double.Addend,
        sum: Double
    ) {
        var result: Double = augend
        result += addend
        #expect(result == sum)
    }

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: Double,
        addend: Double.Addend,
        sum: Double
    ) throws {
        let result: Double = try augend.adding(addend)
        #expect(result == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: Double,
        addend: Double.Addend,
        sum: Double
    ) throws {
        var result: Double = augend
        try result.add(addend)
        #expect(result == sum)
    }
}

extension DoubleAddableTests {
    @Test(
        "Addition is commutative",
        arguments: Self.additionArguments
    )
    internal func additionIsCommutative(
        augend: Double,
        addend: Double.Addend,
        sum _: Double
    ) {
        let result: Double = augend + addend
        #expect(result == addend + augend)
    }
}

// MARK: - NaN

extension DoubleAddableTests {
    @Test("Adding positive infinity to negative infinity returns NaN")
    internal func addingPositiveInfinityToNegativeInfinityReturnsNaN() {
        let result: Double = Double.negativeInfinity + .infinity
        #expect(result.isNaN == true)
    }

    @Test("Adding negative infinity to positive infinity returns NaN")
    internal func addingNegativeInfinityToPositiveInfinityReturnsNaN() {
        let result: Double = Double.infinity + .negativeInfinity
        #expect(result.isNaN == true)
    }

    @Test(
        "Adding to NaN returns NaN",
        arguments: [
            .nan,
            .zero,
            .negativeZero,
            1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double.Addend>
    )
    internal func addingToNaNReturnsNaN(addend: Double.Addend) {
        let result: Double = Double.nan + addend
        #expect(result.isNaN == true)
    }

    @Test(
        "Adding NaN returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            1.0,
            -1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double>
    )
    internal func addingNaNReturnsNaN(augend: Double) {
        let result: Double = augend + Double.nan
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleAddableTests {
    @Test(
        "Adding to negative infinity follows floating-point rules",
        arguments: [
            .negativeInfinity,
            1.0,
            -1.0
        ] as Array<Double.Addend>
    )
    internal func addingToNegativeInfinityFollowsFloatingPointRules(addend: Double.Addend) {
        let result: Double = Double.negativeInfinity + addend
        #expect(result == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension DoubleAddableTests {
    @Test(
        "Adding to negative zero follows floating-point rules",
        arguments: [
            (.zero, .zero),
            (.negativeZero, .negativeZero),
            (1.0, 1.0),
            (-1.0, -1.0)
        ] as Array<(Double.Addend, Double)>
    )
    internal func addingToNegativeZeroFollowsFloatingPointRules(
        addend: Double.Addend,
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
            .infinity,
            1.0,
            -1.0
        ] as Array<Double.Addend>
    )
    internal func addingToPositiveInfinityFollowsFloatingPointRules(addend: Double.Addend) {
        let result: Double = Double.infinity + addend
        #expect(result == .infinity)
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
        ] as Array<(Double, Double.Addend)>
    )
    internal func addingOppositeValuesReturnsPositiveZero(
        augend: Double,
        addend: Double.Addend
    ) {
        let result: Double = augend + addend
        #expect(result == Double.zero)
        #expect(result.sign == .plus)
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
        ] as Array<Double>
    )
    internal func addingPositiveZeroPreservesAugend(augend: Double) {
        let result: Double = augend + Double.zero
        #expect(result == augend)
    }

    @Test(
        "Adding to positive zero follows floating-point rules",
        arguments: [
            (.zero, .zero),
            (.negativeZero, .zero),
            (1.0, 1.0),
            (-1.0, -1.0)
        ] as Array<(Double.Addend, Double)>
    )
    internal func addingToPositiveZeroFollowsFloatingPointRules(
        addend: Double.Addend,
        sum: Double
    ) {
        let result: Double = Double.zero + addend
        #expect(result == sum)
        #expect(result.sign == sum.sign)
    }
}
