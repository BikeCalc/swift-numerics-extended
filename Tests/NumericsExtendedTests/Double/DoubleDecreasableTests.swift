// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Decreasable Tests")
internal struct DoubleDecreasableTests {
    @Test(
        "Decreasing by succeeds",
        arguments: [
            (10.0, 2.0, 9.8),
            (20.0, 3.0, 19.4),
            (-10.0, 2.0, -9.8),
            (-20.0, 3.0, -19.4),
            (0.5, 2.0, 0.49),
            (1.5, 3.0, 1.455),
            (-0.5, 2.0, -0.49),
            (-1.5, 3.0, -1.455)
        ]
    )
    internal func decreasingBySucceeds(
        value: Double,
        percentage: Double,
        result: Double
    ) {
        let decreasedValue: Double = value.decreasing(by: percentage)
        #expect(decreasedValue == result)
    }
}

extension DoubleDecreasableTests {
    @Test(
        "Decreasing positive value by negative percentage increases value",
        arguments: [
            (10.0, -2.0, 10.2),
            (20.0, -3.0, 20.6)
        ]
    )
    internal func decreasingPositiveValueByNegativePercentageIncreasesValue(
        value: Double,
        percentage: Double,
        result: Double
    ) {
        let decreasedValue: Double = value.decreasing(by: percentage)
        #expect(decreasedValue == result)
        #expect(decreasedValue > value)
    }

    @Test(
        "Decreasing negative value by negative percentage decreases value",
        arguments: [
            (-10.0, -2.0, -10.2),
            (-20.0, -3.0, -20.6)
        ]
    )
    internal func decreasingNegativeValueByNegativePercentageDecreasesValue(
        value: Double,
        percentage: Double,
        result: Double
    ) {
        let decreasedValue: Double = value.decreasing(by: percentage)
        #expect(decreasedValue == result)
        #expect(decreasedValue < value)
    }
}

// MARK: - Negative Zero

extension DoubleDecreasableTests {
    @Test(
        "Decreasing by negative zero preserves value",
        arguments: [
            10.0,
            20.0,
            -10.0,
            -20.0,
            0.5,
            1.5,
            -0.5,
            -1.5
        ]
    )
    internal func decreasingByNegativeZeroPreservesValue(value: Double) {
        let decreasedValue: Double = value.decreasing(by: Double.negativeZero)
        #expect(decreasedValue == value)
    }

    @Test(
        "Decreasing negative zero follows floating-point rules",
        arguments: [
            (2.0, FloatingPointSign.plus),
            (3.0, FloatingPointSign.plus),
            (-2.0, FloatingPointSign.minus),
            (-3.0, FloatingPointSign.minus)
        ]
    )
    internal func decreasingNegativeZeroFollowsFloatingPointRules(
        percentage: Double,
        sign: FloatingPointSign
    ) {
        let decreasedValue: Double = Double.negativeZero.decreasing(by: percentage)

        #expect(decreasedValue == Double.zero)
        #expect(decreasedValue.sign == sign)
    }
}

// MARK: - Positive Zero

extension DoubleDecreasableTests {
    @Test(
        "Decreasing by positive zero preserves value",
        arguments: [
            10.0,
            20.0,
            -10.0,
            -20.0,
            0.5,
            1.5,
            -0.5,
            -1.5
        ]
    )
    internal func decreasingByPositiveZeroPreservesValue(value: Double) {
        let decreasedValue: Double = value.decreasing(by: Double.zero)
        #expect(decreasedValue == value)
    }

    @Test(
        "Decreasing positive zero returns positive zero",
        arguments: [
            2.0,
            3.0,
            -2.0,
            -3.0
        ]
    )
    internal func decreasingPositiveZeroReturnsPositiveZero(percentage: Double) {
        let decreasedValue: Double = Double.zero.decreasing(by: percentage)
        #expect(decreasedValue == Double.zero)
        #expect(decreasedValue.sign == .plus)
    }
}
