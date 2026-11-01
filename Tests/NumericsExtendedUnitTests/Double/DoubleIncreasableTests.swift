// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Increasable Tests")
internal struct DoubleIncreasableTests {
    internal init() {}

    @Test(
        "Increasing by succeeds",
        arguments: [
            (10.0, 2.0, 10.2),
            (20.0, 3.0, 20.6),
            (-10.0, 2.0, -10.2),
            (-20.0, 3.0, -20.6),
            (0.5, 2.0, 0.51),
            (1.5, 3.0, 1.545),
            (-0.5, 2.0, -0.51),
            (-1.5, 3.0, -1.545)
        ]
    )
    internal func increasingBySucceeds(
        value: Double,
        percentage: Double,
        expected: Double
    ) {
        let result: Double = value.increasing(by: percentage)
        #expect(result == expected)
    }
}

extension DoubleIncreasableTests {
    @Test(
        "Increasing positive value by negative percentage decreases value",
        arguments: [
            (10.0, -2.0, 9.8),
            (20.0, -3.0, 19.4)
        ]
    )
    internal func increasingPositiveValueByNegativePercentageDecreasesValue(
        value: Double,
        percentage: Double,
        expected: Double
    ) {
        let result: Double = value.increasing(by: percentage)
        #expect(result == expected)
        #expect(result < value)
    }

    @Test(
        "Increasing negative value by negative percentage increases value",
        arguments: [
            (-10.0, -2.0, -9.8),
            (-20.0, -3.0, -19.4)
        ]
    )
    internal func increasingNegativeValueByNegativePercentageIncreasesValue(
        value: Double,
        percentage: Double,
        expected: Double
    ) {
        let result: Double = value.increasing(by: percentage)
        #expect(result == expected)
        #expect(result > value)
    }
}

// MARK: - Negative Zero

extension DoubleIncreasableTests {
    @Test(
        "Increasing by negative zero preserves value",
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
    internal func increasingByNegativeZeroPreservesValue(value: Double) {
        let result: Double = value.increasing(by: Double.negativeZero)
        #expect(result == value)
    }

    @Test(
        "Increasing negative zero follows floating-point rules",
        arguments: [
            (2.0, FloatingPointSign.minus),
            (3.0, FloatingPointSign.minus),
            (-2.0, FloatingPointSign.plus),
            (-3.0, FloatingPointSign.plus)
        ]
    )
    internal func increasingNegativeZeroFollowsFloatingPointRules(
        percentage: Double,
        sign: FloatingPointSign
    ) {
        let result: Double = Double.negativeZero.increasing(by: percentage)
        #expect(result == Double.zero)
        #expect(result.sign == sign)
    }
}

// MARK: - Positive Zero

extension DoubleIncreasableTests {
    @Test(
        "Increasing by positive zero preserves value",
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
    internal func increasingByPositiveZeroPreservesValue(value: Double) {
        let result: Double = value.increasing(by: Double.zero)
        #expect(result == value)
    }

    @Test(
        "Increasing positive zero returns positive zero",
        arguments: [
            2.0,
            3.0,
            -2.0,
            -3.0
        ]
    )
    internal func increasingPositiveZeroReturnsPositiveZero(percentage: Double) {
        let result: Double = Double.zero.increasing(by: percentage)
        #expect(result == Double.zero)
        #expect(result.sign == .plus)
    }
}
