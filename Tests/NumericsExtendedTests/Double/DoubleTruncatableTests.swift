// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Truncatable Tests")
internal struct DoubleTruncatableTests {
    private static let truncationArguments: Array<(Double, Double.DecimalPlace, Double)> = [
        (1.2345, Double.DecimalPlace(0), 1.0),
        (-1.2345, Double.DecimalPlace(0), -1.0),
        (1.2345, Double.DecimalPlace(1), 1.2),
        (-1.2345, Double.DecimalPlace(1), -1.2),
        (1.2345, Double.DecimalPlace(2), 1.23),
        (-1.2345, Double.DecimalPlace(2), -1.23),
        (1.2399, Double.DecimalPlace(2), 1.23),
        (-1.2399, Double.DecimalPlace(2), -1.23),
        (0.555, Double.DecimalPlace(2), 0.55),
        (-0.555, Double.DecimalPlace(2), -0.55),
        (12.999, Double.DecimalPlace(2), 12.99),
        (-12.999, Double.DecimalPlace(2), -12.99)
    ]

    @Test(
        "Truncated to succeeds",
        arguments: Self.truncationArguments
    )
    internal func truncatedToSucceeds(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        result: Double
    ) {
        #expect(value.truncated(to: decimalPlace) == result)
    }

    @Test(
        "Truncate to succeeds",
        arguments: Self.truncationArguments
    )
    internal func truncateToSucceeds(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        result: Double
    ) {
        var truncatedValue: Double = value
        truncatedValue.truncate(to: decimalPlace)
        #expect(truncatedValue == result)
    }
}

extension DoubleTruncatableTests {
    @Test(
        "Truncating follows toward-zero rule",
        arguments: [
            (1.9, Double.DecimalPlace(0), 1.0),
            (-1.9, Double.DecimalPlace(0), -1.0),
            (1.29, Double.DecimalPlace(1), 1.2),
            (-1.29, Double.DecimalPlace(1), -1.2)
        ]
    )
    internal func truncatingFollowsTowardZeroRule(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        result: Double
    ) {
        #expect(value.truncated(to: decimalPlace) == result)
    }

    @Test(
        "Truncating whole value preserves value",
        arguments: [
            (1.0, Double.DecimalPlace(0)),
            (-1.0, Double.DecimalPlace(0)),
            (1.0, Double.DecimalPlace(2)),
            (-1.0, Double.DecimalPlace(2))
        ]
    )
    internal func truncatingWholeValuePreservesValue(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        #expect(value.truncated(to: decimalPlace) == value)
    }
}

// MARK: - NaN

extension DoubleTruncatableTests {
    @Test(
        "Truncating NaN returns NaN",
        arguments: [
            (Double.nan, Double.DecimalPlace(0)),
            (Double.nan, Double.DecimalPlace(2))
        ]
    )
    internal func truncatingNaNReturnsNaN(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        #expect(value.truncated(to: decimalPlace).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleTruncatableTests {
    @Test(
        "Truncating negative infinity follows floating-point rules",
        arguments: [
            Double.DecimalPlace(0),
            Double.DecimalPlace(2)
        ]
    )
    internal func truncatingNegativeInfinityFollowsFloatingPointRules(decimalPlace: Double.DecimalPlace) {
        #expect(Double.negativeInfinity.truncated(to: decimalPlace) == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension DoubleTruncatableTests {
    @Test(
        "Truncating negative zero preserves its sign",
        arguments: [
            (-0.0, Double.DecimalPlace(0)),
            (-0.0, Double.DecimalPlace(2))
        ]
    )
    internal func truncatingNegativeZeroPreservesItsSign(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let truncatedValue: Double = value.truncated(to: decimalPlace)

        #expect(truncatedValue == Double.zero)
        #expect(truncatedValue.sign == .minus)
    }
}

// MARK: - Positive Infinity

extension DoubleTruncatableTests {
    @Test(
        "Truncating positive infinity follows floating-point rules",
        arguments: [
            Double.DecimalPlace(0),
            Double.DecimalPlace(2)
        ]
    )
    internal func truncatingPositiveInfinityFollowsFloatingPointRules(decimalPlace: Double.DecimalPlace) {
        #expect(Double.infinity.truncated(to: decimalPlace) == .infinity)
    }
}

// MARK: - Positive Zero

extension DoubleTruncatableTests {
    @Test(
        "Truncating positive zero preserves its sign",
        arguments: [
            (0.0, Double.DecimalPlace(0)),
            (0.0, Double.DecimalPlace(2))
        ]
    )
    internal func truncatingPositiveZeroPreservesItsSign(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let truncatedValue: Double = value.truncated(to: decimalPlace)

        #expect(truncatedValue == Double.zero)
        #expect(truncatedValue.sign == .plus)
    }
}
