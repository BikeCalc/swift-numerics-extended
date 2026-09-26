// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 CustomStringConvertible Tests")
internal struct UInt4CustomStringConvertibleTests {
    @Test(
        "Description succeeds",
        arguments: [
            (0, "0"),
            (00, "0"),
            (01, "1"),
            (1, "1")
        ] as Array<(UInt4, String)>
    )
    internal func descriptionSucceeds(
        value: UInt4,
        description: String
    ) {
        #expect(value.description == description)
    }
}
