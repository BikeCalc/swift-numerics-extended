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
    private static let roundingArguments: Array<(Double, Double.DecimalPlace, Double)> = [
        (1.2345, Double.DecimalPlace(0), 1.0),
        (-1.2345, Double.DecimalPlace(0), -1.0),
        (1.2345, Double.DecimalPlace(1), 1.2),
        (-1.2345, Double.DecimalPlace(1), -1.2),
        (1.2345, Double.DecimalPlace(2), 1.23),
        (-1.2345, Double.DecimalPlace(2), -1.23),
        (1.2355, Double.DecimalPlace(2), 1.24),
        (-1.2355, Double.DecimalPlace(2), -1.24),
        (0.555, Double.DecimalPlace(2), 0.56),
        (-0.555, Double.DecimalPlace(2), -0.56),
        (12.999, Double.DecimalPlace(2), 13.0),
        (-12.999, Double.DecimalPlace(2), -13.0)
    ]

    @Test(
        "Rounded to succeeds",
        arguments: Self.roundingArguments
    )
    internal func roundedToSucceeds(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        result: Double
    ) {
        #expect(value.rounded(to: decimalPlace) == result)
    }

    @Test(
        "Round to succeeds",
        arguments: Self.roundingArguments
    )
    internal func roundToSucceeds(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        result: Double
    ) {
        var roundedValue: Double = value
        roundedValue.round(to: decimalPlace)
        #expect(roundedValue == result)
    }
}

extension DoubleRoundableTests {
    @Test(
        "Rounding midpoint follows away-from-zero rule",
        arguments: [
            (1.5, Double.DecimalPlace(0), 2.0),
            (-1.5, Double.DecimalPlace(0), -2.0),
            (1.25, Double.DecimalPlace(1), 1.3),
            (-1.25, Double.DecimalPlace(1), -1.3)
        ]
    )
    internal func roundingMidpointFollowsAwayFromZeroRule(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        result: Double
    ) {
        #expect(value.rounded(to: decimalPlace) == result)
    }

    @Test(
        "Rounding whole value preserves value",
        arguments: [
            (1.0, Double.DecimalPlace(0)),
            (-1.0, Double.DecimalPlace(0)),
            (1.0, Double.DecimalPlace(2)),
            (-1.0, Double.DecimalPlace(2))
        ]
    )
    internal func roundingWholeValuePreservesValue(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        #expect(value.rounded(to: decimalPlace) == value)
    }
}

// MARK: - NaN

extension DoubleRoundableTests {
    @Test(
        "Rounding NaN returns NaN",
        arguments: [
            (Double.nan, Double.DecimalPlace(0)),
            (Double.nan, Double.DecimalPlace(2))
        ]
    )
    internal func roundingNaNReturnsNaN(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        #expect(value.rounded(to: decimalPlace).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleRoundableTests {
    @Test(
        "Rounding negative infinity follows floating-point rules",
        arguments: [
            Double.DecimalPlace(0),
            Double.DecimalPlace(2)
        ]
    )
    internal func roundingNegativeInfinityFollowsFloatingPointRules(decimalPlace: Double.DecimalPlace) {
        #expect(Double.negativeInfinity.rounded(to: decimalPlace) == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension DoubleRoundableTests {
    @Test(
        "Rounding negative zero preserves its sign",
        arguments: [
            (-0.0, Double.DecimalPlace(0)),
            (-0.0, Double.DecimalPlace(2))
        ]
    )
    internal func roundingNegativeZeroPreservesItsSign(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let roundedValue: Double = value.rounded(to: decimalPlace)

        #expect(roundedValue == Double.zero)
        #expect(roundedValue.sign == .minus)
    }
}

// MARK: - Positive Infinity

extension DoubleRoundableTests {
    @Test(
        "Rounding positive infinity follows floating-point rules",
        arguments: [
            Double.DecimalPlace(0),
            Double.DecimalPlace(2)
        ]
    )
    internal func roundingPositiveInfinityFollowsFloatingPointRules(decimalPlace: Double.DecimalPlace) {
        #expect(Double.infinity.rounded(to: decimalPlace) == .infinity)
    }
}

// MARK: - Positive Zero

extension DoubleRoundableTests {
    @Test(
        "Rounding positive zero preserves its sign",
        arguments: [
            (0.0, Double.DecimalPlace(0)),
            (0.0, Double.DecimalPlace(2))
        ]
    )
    internal func roundingPositiveZeroPreservesItsSign(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let roundedValue: Double = value.rounded(to: decimalPlace)

        #expect(roundedValue == Double.zero)
        #expect(roundedValue.sign == .plus)
    }
}
