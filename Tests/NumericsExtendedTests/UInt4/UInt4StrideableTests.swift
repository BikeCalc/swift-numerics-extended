// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Strideable Tests")
internal struct UInt4StrideableTests {
    @Test(
        "Advanced by succeeds",
        arguments: [
            (1, 3, 4),
            (2, 3, 5),
            (4, -3, 1),
            (5, -3, 2)
        ] as Array<(UInt4, UInt4.Stride, UInt4)>
    )
    internal func advancedBySucceeds(
        value: UInt4,
        amount: UInt4.Stride,
        result: UInt4
    ) {
        #expect(value.advanced(by: amount) == result)
    }

    @Test(
        "Distance to succeeds",
        arguments: [
            (1, 4, 3),
            (2, 5, 3),
            (4, 1, -3),
            (5, 2, -3)
        ] as Array<(UInt4, UInt4, UInt4.Stride)>
    )
    internal func distanceToSucceeds(
        value: UInt4,
        other: UInt4,
        result: UInt4.Stride
    ) {
        #expect(value.distance(to: other) == result)
    }
}

// MARK: - Positive Zero

extension UInt4StrideableTests {
    @Test(
        "Advancing by positive zero preserves value",
        arguments: [
            1,
            2
        ] as Array<UInt4>
    )
    internal func advancingByPositiveZeroPreservesValue(value: UInt4) {
        #expect(value.advanced(by: Int.zero) == value)
    }

    @Test(
        "Distance to self returns positive zero",
        arguments: [
            1,
            2
        ] as Array<UInt4>
    )
    internal func distanceToSelfReturnsPositiveZero(value: UInt4) {
        #expect(value.distance(to: value) == Int.zero)
    }
}
