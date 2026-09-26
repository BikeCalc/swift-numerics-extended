// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 CustomDebugStringConvertible Tests")
internal struct UInt4CustomDebugStringConvertibleTests {
    @Test(
        "Debug description succeeds",
        arguments: [
            (0, "UInt4(0)"),
            (00, "UInt4(0)"),
            (01, "UInt4(1)"),
            (1, "UInt4(1)")
        ] as Array<(UInt4, String)>
    )
    internal func debugDescriptionSucceeds(
        value: UInt4,
        debugDescription: String
    ) {
        #expect(value.debugDescription == debugDescription)
    }
}
