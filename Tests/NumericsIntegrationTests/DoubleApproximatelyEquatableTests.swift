// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Numerics
import NumericsExtended
import Testing

@Suite("Double ApproximatelyEquatable Tests")
internal struct DoubleApproximatelyEquatableTests {
    @Test(
        "Approximate equality follows the specified tolerances",
        arguments: [
            (1.0, 1.0, 0.0, 0.0, true),
            (1.0, 1.25, 0.25, 0.0, true),
            (1.0, 1.5, 0.25, 0.0, false),
            (-1.0, -1.25, 0.25, 0.0, true),
            (-0.125, 0.125, 0.25, 0.0, true),
            (100.0, 101.0, 0.0, 0.01, true),
            (100.0, 102.0, 0.0, 0.01, false),
            (0.0, 0.125, 0.25, 0.01, true),
            (0.0, 0.125, 0.0, 0.01, false)
        ]
    )
    internal func approximateEqualityFollowsSpecifiedTolerances(
        lhs: Double,
        rhs: Double,
        absoluteTolerance: Double,
        relativeTolerance: Double,
        result: Bool
    ) {
        #expect(
            lhs.isApproximatelyEqual(
                to: rhs,
                absoluteTolerance: absoluteTolerance,
                relativeTolerance: relativeTolerance
            ) == result
        )
    }

    @Test("Tolerance accommodates floating-point rounding")
    internal func toleranceAccommodatesRounding() {
        let value: Double = 0.1 + 0.2

        #expect(
            value.isApproximatelyEqual(
                to: 0.3,
                absoluteTolerance: 1e-10
            ) == true
        )
        #expect(
            value.isApproximatelyEqual(
                to: 0.3,
                absoluteTolerance: 0
            ) == false
        )
        #expect((value == 0.3) == false)
    }

    @Test("Approximate equality is not transitive")
    internal func approximateEqualityIsNotTransitive() {
        #expect(
            1.0.isApproximatelyEqual(
                to: 1.25,
                absoluteTolerance: 0.25
            ) == true
        )
        #expect(
            1.25.isApproximatelyEqual(
                to: 1.5,
                absoluteTolerance: 0.25
            ) == true
        )
        #expect(
            1.0.isApproximatelyEqual(
                to: 1.5,
                absoluteTolerance: 0.25
            ) == false
        )
    }
}

// MARK: - Greatest Finite Magnitude

extension DoubleApproximatelyEquatableTests {
    @Test("Greatest finite magnitude comparison handles overflow")
    internal func greatestFiniteMagnitudeComparisonHandlesOverflow() {
        let value: Double = .greatestFiniteMagnitude

        #expect(
            value.isApproximatelyEqual(
                to: -value,
                absoluteTolerance: value
            ) == false
        )
        #expect(
            value.isApproximatelyEqual(
                to: value,
                absoluteTolerance: 0
            ) == true
        )
    }
}

// MARK: - NaN

extension DoubleApproximatelyEquatableTests {
    @Test(
        "NaN approximate equality follows floating-point rules",
        arguments: [
            (Double.nan, Double.nan, false),
            (Double.nan, 1.0, false),
            (1.0, Double.nan, false)
        ]
    )
    internal func nanApproximateEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        result: Bool
    ) {
        #expect(
            lhs.isApproximatelyEqual(
                to: rhs,
                absoluteTolerance: 0.25,
                relativeTolerance: 0
            ) == result
        )
    }
}

// MARK: - Negative Infinity

extension DoubleApproximatelyEquatableTests {
    @Test(
        "Negative Infinity approximate equality follows floating-point rules",
        arguments: [
            (Double.negativeInfinity, Double.negativeInfinity, true),
            (Double.negativeInfinity, Double.infinity, false)
        ]
    )
    internal func negativeInfinityApproximateEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        result: Bool
    ) {
        #expect(
            lhs.isApproximatelyEqual(
                to: rhs,
                absoluteTolerance: 0.25,
                relativeTolerance: 0
            ) == result
        )
    }
}

// MARK: - Negative Zero

extension DoubleApproximatelyEquatableTests {
    @Test(
        "Negative Zero approximate equality follows floating-point rules",
        arguments: [
            (Double.negativeZero, Double.negativeZero, true),
            (Double.negativeZero, Double.zero, true),
            (Double.negativeZero, -1.0, false)
        ]
    )
    internal func negativeZeroApproximateEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        result: Bool
    ) {
        #expect(
            lhs.isApproximatelyEqual(
                to: rhs,
                absoluteTolerance: 0,
                relativeTolerance: 0
            ) == result
        )
    }
}

// MARK: - Least Nonzero Magnitude

extension DoubleApproximatelyEquatableTests {
    @Test("Least nonzero magnitude respects the tolerance boundary")
    internal func leastNonzeroMagnitudeRespectsToleranceBoundary() {
        let value: Double = .leastNonzeroMagnitude

        #expect(
            value.isApproximatelyEqual(
                to: 0,
                absoluteTolerance: value
            ) == true
        )
        #expect(
            value.isApproximatelyEqual(
                to: 0,
                absoluteTolerance: 0
            ) == false
        )
    }
}

// MARK: - Positive Infinity

extension DoubleApproximatelyEquatableTests {
    @Test(
        "Positive Infinity approximate equality follows floating-point rules",
        arguments: [
            (Double.infinity, Double.infinity, true),
            (Double.infinity, Double.negativeInfinity, false)
        ]
    )
    internal func positiveInfinityApproximateEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        result: Bool
    ) {
        #expect(
            lhs.isApproximatelyEqual(
                to: rhs,
                absoluteTolerance: 0.25,
                relativeTolerance: 0
            ) == result
        )
    }
}

// MARK: - Positive Zero

extension DoubleApproximatelyEquatableTests {
    @Test(
        "Positive Zero approximate equality follows floating-point rules",
        arguments: [
            (Double.zero, Double.zero, true),
            (Double.zero, Double.negativeZero, true),
            (Double.zero, 1.0, false)
        ]
    )
    internal func positiveZeroApproximateEqualityFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        result: Bool
    ) {
        #expect(
            lhs.isApproximatelyEqual(
                to: rhs,
                absoluteTolerance: 0,
                relativeTolerance: 0
            ) == result
        )
    }
}
