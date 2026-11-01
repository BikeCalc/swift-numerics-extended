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
    internal init() {}

    private static let truncationArguments: Array<(Double, Double.DecimalPlace, Double)> = [
        (1.2345, .init(0), 1.0),
        (-1.2345, .init(0), -1.0),
        (1.2345, .init(1), 1.2),
        (-1.2345, .init(1), -1.2),
        (1.2345, .init(2), 1.23),
        (-1.2345, .init(2), -1.23),
        (1.2399, .init(2), 1.23),
        (-1.2399, .init(2), -1.23),
        (0.555, .init(2), 0.55),
        (-0.555, .init(2), -0.55),
        (12.999, .init(2), 12.99),
        (-12.999, .init(2), -12.99)
    ]

    @Test(
        "Truncated to succeeds",
        arguments: Self.truncationArguments
    )
    internal func truncatedToSucceeds(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        expected: Double
    ) {
        let result: Double = value.truncated(to: decimalPlace)
        #expect(result == expected)
    }

    @Test(
        "Truncate to succeeds",
        arguments: Self.truncationArguments
    )
    internal func truncateToSucceeds(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        expected: Double
    ) {
        var result: Double = value
        result.truncate(to: decimalPlace)
        #expect(result == expected)
    }
}

extension DoubleTruncatableTests {
    @Test(
        "Truncating follows toward-zero rule",
        arguments: [
            (1.9, .init(0), 1.0),
            (-1.9, .init(0), -1.0),
            (1.29, .init(1), 1.2),
            (-1.29, .init(1), -1.2)
        ] as Array<(Double, Double.DecimalPlace, Double)>
    )
    internal func truncatingFollowsTowardZeroRule(
        value: Double,
        decimalPlace: Double.DecimalPlace,
        expected: Double
    ) {
        let result: Double = value.truncated(to: decimalPlace)
        #expect(result == expected)
    }

    @Test(
        "Truncating whole value preserves value",
        arguments: [
            (1.0, .init(0)),
            (-1.0, .init(0)),
            (1.0, .init(2)),
            (-1.0, .init(2))
        ] as Array<(Double, Double.DecimalPlace)>
    )
    internal func truncatingWholeValuePreservesValue(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let result: Double = value.truncated(to: decimalPlace)
        #expect(result == value)
    }
}

// MARK: - NaN

extension DoubleTruncatableTests {
    @Test(
        "Truncating NaN returns NaN",
        arguments: [
            (.nan, .init(0)),
            (.nan, .init(2))
        ] as Array<(Double, Double.DecimalPlace)>
    )
    internal func truncatingNaNReturnsNaN(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let result: Double = value.truncated(to: decimalPlace)
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleTruncatableTests {
    @Test(
        "Truncating negative infinity follows floating-point rules",
        arguments: [
            .init(0),
            .init(2)
        ] as Array<Double.DecimalPlace>
    )
    internal func truncatingNegativeInfinityFollowsFloatingPointRules(decimalPlace: Double.DecimalPlace) {
        let result: Double = Double.negativeInfinity.truncated(to: decimalPlace)
        #expect(result == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension DoubleTruncatableTests {
    @Test(
        "Truncating negative zero preserves its sign",
        arguments: [
            (-0.0, .init(0)),
            (-0.0, .init(2))
        ] as Array<(Double, Double.DecimalPlace)>
    )
    internal func truncatingNegativeZeroPreservesItsSign(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let result: Double = value.truncated(to: decimalPlace)
        #expect(result == Double.zero)
        #expect(result.sign == .minus)
    }
}

// MARK: - Positive Infinity

extension DoubleTruncatableTests {
    @Test(
        "Truncating positive infinity follows floating-point rules",
        arguments: [
            .init(0),
            .init(2)
        ] as Array<Double.DecimalPlace>
    )
    internal func truncatingPositiveInfinityFollowsFloatingPointRules(decimalPlace: Double.DecimalPlace) {
        let result: Double = Double.infinity.truncated(to: decimalPlace)
        #expect(result == .infinity)
    }
}

// MARK: - Positive Zero

extension DoubleTruncatableTests {
    @Test(
        "Truncating positive zero preserves its sign",
        arguments: [
            (0.0, .init(0)),
            (0.0, .init(2))
        ] as Array<(Double, Double.DecimalPlace)>
    )
    internal func truncatingPositiveZeroPreservesItsSign(
        value: Double,
        decimalPlace: Double.DecimalPlace
    ) {
        let result: Double = value.truncated(to: decimalPlace)
        #expect(result == Double.zero)
        #expect(result.sign == .plus)
    }
}
