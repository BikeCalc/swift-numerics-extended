// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Strideable Tests")
internal struct RomanStrideableTests {
    @Test(
        "Advanced by succeeds",
        arguments: [
            (1, 3, 4),
            (2, 3, 5),
            (4, -3, 1),
            (5, -3, 2)
        ] as Array<(Roman, Roman.Stride, Roman)>
    )
    internal func advancedBySucceeds(
        value: Roman,
        amount: Roman.Stride,
        result: Roman
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
        ] as Array<(Roman, Roman, Roman.Stride)>
    )
    internal func distanceToSucceeds(
        value: Roman,
        other: Roman,
        result: Roman.Stride
    ) {
        #expect(value.distance(to: other) == result)
    }
}

// MARK: - Positive Zero

extension RomanStrideableTests {
    @Test(
        "Advancing by positive zero preserves value",
        arguments: [
            1,
            2
        ] as Array<Roman>
    )
    internal func advancingByPositiveZeroPreservesValue(value: Roman) {
        #expect(value.advanced(by: Int.zero) == value)
    }

    @Test(
        "Distance to self returns positive zero",
        arguments: [
            1,
            2
        ] as Array<Roman>
    )
    internal func distanceToSelfReturnsPositiveZero(value: Roman) {
        #expect(value.distance(to: value) == Int.zero)
    }
}
