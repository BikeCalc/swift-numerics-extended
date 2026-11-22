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
    internal init() {}

    @Test(
        "Approximate equality uses the protocol's tolerances",
        arguments: [
            (1, 1.25, 0.5, 0, true),
            (8, 9, 0, 0.25, true),
            (1, 2, 0.125, 0.125, false)
        ] as Array<(Double, Double, Double, Double, Bool)>
    )
    internal func approximateEquality(
        lhs: Double,
        rhs: Double,
        absoluteTolerance: Double,
        relativeTolerance: Double,
        expected: Bool
    ) {
        let result: Bool = Self.approximatelyEqual(
            lhs,
            rhs,
            absoluteTolerance: absoluteTolerance,
            relativeTolerance: relativeTolerance
        )
        #expect(result == expected)
    }
}

// MARK: - Generic Protocol Calls

extension DoubleApproximatelyEquatableTests {
    private static func approximatelyEqual<Value>(
        _ lhs: Value,
        _ rhs: Value,
        absoluteTolerance: Value.AbsoluteTolerance,
        relativeTolerance: Value.RelativeTolerance
    ) -> Bool
    where Value: ApproximatelyEquatable {
        return lhs.isApproximatelyEqual(
            to: rhs,
            absoluteTolerance: absoluteTolerance,
            relativeTolerance: relativeTolerance
        )
    }
}
