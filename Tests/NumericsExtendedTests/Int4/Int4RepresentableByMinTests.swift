// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 RepresentableByMin Tests")
internal struct Int4RepresentableByMinTests {
    @Test(
        "Is min",
        arguments: [
            (-8, true),
            (7, false)
        ] as Array<(Int4, Bool)>
    )
    internal func isMin(
        value: Int4,
        result: Bool
    ) {
        #expect(value.isMin == result)
    }

    @Test("Min returns min")
    internal func minReturnsMin() {
        #expect(Int4.min == -8)
    }
}
