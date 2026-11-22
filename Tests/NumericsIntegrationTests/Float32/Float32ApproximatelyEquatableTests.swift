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

@Suite("Float32 ApproximatelyEquatable Tests")
internal struct Float32ApproximatelyEquatableTests {
    internal init() {}

    @Test(
        "Is approximately equal",
        arguments: [
            (1, 1.25, 0.5, 0, true),
            (8, 9, 0, 0.25, true),
            (1, 2, 0.125, 0.125, false)
        ] as Array<(Float32, Float32, Float32, Float32, Bool)>
    )
    internal func isApproximatelyEqual(
        lhs: Float32,
        rhs: Float32,
        absoluteTolerance: Float32,
        relativeTolerance: Float32,
        expected: Bool
    ) {
        let result: Bool = Self.genericApproximatelyEqual(
            lhs,
            rhs,
            absoluteTolerance: absoluteTolerance,
            relativeTolerance: relativeTolerance
        )
        #expect(result == expected)
    }

    private static func genericApproximatelyEqual<Value>(
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
