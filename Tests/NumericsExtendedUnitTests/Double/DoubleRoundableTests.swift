// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Roundable Tests")
internal struct DoubleRoundableTests {
    internal init() {}

    private static let roundingArguments: Array<(Double, Double.DecimalPlace, Double)> = [
        (1.2345, .init(0), 1.0),
        (-1.2345, .init(0), -1.0),
        (1.2345, .init(1), 1.2),
        (-1.2345, .init(1), -1.2),
        (1.2345, .init(2), 1.23),
        (-1.2345, .init(2), -1.23),
        (1.2355, .init(2), 1.24),
        (-1.2355, .init(2), -1.24),
        (0.555, .init(2), 0.56),
        (-0.555, .init(2), -0.56),
        (12.999, .init(2), 13.0),
        (-12.999, .init(2), -13.0)
    ]

    @Test(
        "Rounded to succeeds",
        arguments: Self.roundingArguments
    )
    internal func roundedToSucceeds(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        expected: Double
    ) {
        let result: Double = value.rounded(to: decimalPlace)
        #expect(result == expected)
    }

    @Test(
        "Round to succeeds",
        arguments: Self.roundingArguments
    )
    internal func roundToSucceeds(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        expected: Double
    ) {
        var result: Double = value
        result.round(to: decimalPlace)
        #expect(result == expected)
    }
}

extension DoubleRoundableTests {
    @Test(
        "Rounding midpoint follows away-from-zero rule",
        arguments: [
            (1.5, .init(0), 2.0),
            (-1.5, .init(0), -2.0),
            (1.25, .init(1), 1.3),
            (-1.25, .init(1), -1.3)
        ] as Array<(Double, Double.DecimalPlace, Double)>
    )
    internal func roundingMidpointFollowsAwayFromZeroRule(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        expected: Double
    ) {
        let result: Double = value.rounded(to: decimalPlace)
        #expect(result == expected)
    }

    @Test(
        "Rounding whole value preserves value",
        arguments: [
            (1.0, .init(0)),
            (-1.0, .init(0)),
            (1.0, .init(2)),
            (-1.0, .init(2))
        ] as Array<(Double, Double.DecimalPlace)>
    )
    internal func roundingWholeValuePreservesValue(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let result: Double = value.rounded(to: decimalPlace)
        #expect(result == value)
    }
}

// MARK: - NaN

extension DoubleRoundableTests {
    @Test(
        "Rounding NaN returns NaN",
        arguments: [
            (.nan, .init(0)),
            (.nan, .init(2))
        ] as Array<(Double, Double.DecimalPlace)>
    )
    internal func roundingNaNReturnsNaN(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let result: Double = value.rounded(to: decimalPlace)
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleRoundableTests {
    @Test(
        "Rounding negative infinity follows floating-point rules",
        arguments: [
            .init(0),
            .init(2)
        ] as Array<Double.DecimalPlace>
    )
    internal func roundingNegativeInfinityFollowsFloatingPointRules(decimalPlace: Double.DecimalPlace) {
        let result: Double = Double.negativeInfinity.rounded(to: decimalPlace)
        #expect(result == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension DoubleRoundableTests {
    @Test(
        "Rounding negative zero preserves its sign",
        arguments: [
            (-0.0, .init(0)),
            (-0.0, .init(2))
        ] as Array<(Double, Double.DecimalPlace)>
    )
    internal func roundingNegativeZeroPreservesItsSign(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let result: Double = value.rounded(to: decimalPlace)
        #expect(result == Double.zero)
        #expect(result.sign == .minus)
    }
}

// MARK: - Positive Infinity

extension DoubleRoundableTests {
    @Test(
        "Rounding positive infinity follows floating-point rules",
        arguments: [
            .init(0),
            .init(2)
        ] as Array<Double.DecimalPlace>
    )
    internal func roundingPositiveInfinityFollowsFloatingPointRules(decimalPlace: Double.DecimalPlace) {
        let result: Double = Double.infinity.rounded(to: decimalPlace)
        #expect(result == .infinity)
    }
}

// MARK: - Positive Zero

extension DoubleRoundableTests {
    @Test(
        "Rounding positive zero preserves its sign",
        arguments: [
            (0.0, .init(0)),
            (0.0, .init(2))
        ] as Array<(Double, Double.DecimalPlace)>
    )
    internal func roundingPositiveZeroPreservesItsSign(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let result: Double = value.rounded(to: decimalPlace)
        #expect(result == Double.zero)
        #expect(result.sign == .plus)
    }
}
