// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 RepresentableByMin Tests")
internal struct UInt4RepresentableByMinTests {
    @Test(
        "Is min",
        arguments: [
            (0, true),
            (15, false)
        ] as Array<(UInt4, Bool)>
    )
    internal func isMin(
        value: UInt4,
        result: Bool
    ) {
        #expect(value.isMin == result)
    }

    @Test("Min returns min")
    internal func minReturnsMin() {
        #expect(UInt4.min == UInt4.zero)
    }
}
