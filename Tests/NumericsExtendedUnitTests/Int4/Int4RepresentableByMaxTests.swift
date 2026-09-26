// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 RepresentableByMax Tests")
internal struct Int4RepresentableByMaxTests {
    @Test(
        "Is max",
        arguments: [
            (-8, false),
            (7, true)
        ] as Array<(Int4, Bool)>
    )
    internal func isMax(
        value: Int4,
        result: Bool
    ) {
        #expect(value.isMax == result)
    }

    @Test("Max returns max")
    internal func maxReturnsMax() {
        #expect(Int4.max == 7)
    }
}
