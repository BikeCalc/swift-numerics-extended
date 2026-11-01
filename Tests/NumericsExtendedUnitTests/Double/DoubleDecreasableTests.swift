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
    internal init() {}

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
        ] as Array<(Double, Double, Double)>
    )
    internal func decreasingBySucceeds(
        value: Double,
        percentage: Double,
        expected: Double
    ) {
        let result: Double = value.decreasing(by: percentage)
        #expect(result == expected)
    }
}

extension DoubleDecreasableTests {
    @Test(
        "Decreasing positive value by negative percentage increases value",
        arguments: [
            (10.0, -2.0, 10.2),
            (20.0, -3.0, 20.6)
        ] as Array<(Double, Double, Double)>
    )
    internal func decreasingPositiveValueByNegativePercentageIncreasesValue(
        value: Double,
        percentage: Double,
        expected: Double
    ) {
        let result: Double = value.decreasing(by: percentage)
        #expect(result == expected)
        #expect(result > value)
    }

    @Test(
        "Decreasing negative value by negative percentage decreases value",
        arguments: [
            (-10.0, -2.0, -10.2),
            (-20.0, -3.0, -20.6)
        ] as Array<(Double, Double, Double)>
    )
    internal func decreasingNegativeValueByNegativePercentageDecreasesValue(
        value: Double,
        percentage: Double,
        expected: Double
    ) {
        let result: Double = value.decreasing(by: percentage)
        #expect(result == expected)
        #expect(result < value)
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
        ] as Array<Double>
    )
    internal func decreasingByNegativeZeroPreservesValue(value: Double) {
        let result: Double = value.decreasing(by: Double.negativeZero)
        #expect(result == value)
    }

    @Test(
        "Decreasing negative zero follows floating-point rules",
        arguments: [
            (2.0, .plus),
            (3.0, .plus),
            (-2.0, .minus),
            (-3.0, .minus)
        ] as Array<(Double, FloatingPointSign)>
    )
    internal func decreasingNegativeZeroFollowsFloatingPointRules(
        percentage: Double,
        sign: FloatingPointSign
    ) {
        let result: Double = Double.negativeZero.decreasing(by: percentage)
        #expect(result == Double.zero)
        #expect(result.sign == sign)
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
        ] as Array<Double>
    )
    internal func decreasingByPositiveZeroPreservesValue(value: Double) {
        let result: Double = value.decreasing(by: Double.zero)
        #expect(result == value)
    }

    @Test(
        "Decreasing positive zero returns positive zero",
        arguments: [
            2.0,
            3.0,
            -2.0,
            -3.0
        ] as Array<Double>
    )
    internal func decreasingPositiveZeroReturnsPositiveZero(percentage: Double) {
        let result: Double = Double.zero.decreasing(by: percentage)
        #expect(result == Double.zero)
        #expect(result.sign == .plus)
    }
}
