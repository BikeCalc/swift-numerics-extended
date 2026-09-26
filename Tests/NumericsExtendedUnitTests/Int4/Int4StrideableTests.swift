// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 Strideable Tests")
internal struct Int4StrideableTests {
    @Test(
        "Advanced by succeeds",
        arguments: [
            (1, 3, 4),
            (2, 3, 5),
            (4, -3, 1),
            (5, -3, 2),
            (-1, -3, -4),
            (-2, -3, -5),
            (-4, 3, -1)
        ] as Array<(Int4, Int4.Stride, Int4)>
    )
    internal func advancedBySucceeds(
        value: Int4,
        amount: Int4.Stride,
        result: Int4
    ) {
        #expect(value.advanced(by: amount) == result)
    }

    @Test(
        "Distance to succeeds",
        arguments: [
            (1, 4, 3),
            (2, 5, 3),
            (4, 1, -3),
            (5, 2, -3),
            (-4, -1, 3),
            (-5, -2, 3),
            (-1, -4, -3)
        ] as Array<(Int4, Int4, Int4.Stride)>
    )
    internal func distanceToSucceeds(
        value: Int4,
        other: Int4,
        result: Int4.Stride
    ) {
        #expect(value.distance(to: other) == result)
    }
}

// MARK: - Negative Zero

extension Int4StrideableTests {
    @Test(
        "Advancing by negative zero preserves value",
        arguments: [
            1,
            2,
            -1,
            -2
        ] as Array<Int4>
    )
    internal func advancingByNegativeZeroPreservesValue(value: Int4) {
        #expect(value.advanced(by: Int.negativeZero) == value)
    }
}

// MARK: - Positive Zero

extension Int4StrideableTests {
    @Test(
        "Advancing by positive zero preserves value",
        arguments: [
            1,
            2,
            -1,
            -2
        ] as Array<Int4>
    )
    internal func advancingByPositiveZeroPreservesValue(value: Int4) {
        #expect(value.advanced(by: Int.zero) == value)
    }

    @Test(
        "Distance to self returns positive zero",
        arguments: [
            1,
            2,
            -1,
            -2
        ] as Array<Int4>
    )
    internal func distanceToSelfReturnsPositiveZero(value: Int4) {
        #expect(value.distance(to: value) == Int.zero)
    }
}
