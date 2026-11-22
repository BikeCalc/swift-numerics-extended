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

@Suite("Complex ApproximatelyEquatable Tests")
internal struct ComplexApproximatelyEquatableTests {
    internal init() {}

    @Test(
        "Approximate equality uses the protocol's tolerances",
        arguments: [
            (.init(1, 2), .init(1.25, 2.25), 0.5, 0, true),
            (.init(8, 16), .init(9, 18), 0, 0.25, true),
            (.init(1, 2), .init(2, 4), 0.125, 0.125, false)
        ] as Array<(Complex<Double>, Complex<Double>, Double, Double, Bool)>
    )
    internal func approximateEquality(
        lhs: Complex<Double>,
        rhs: Complex<Double>,
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

extension ComplexApproximatelyEquatableTests {
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
