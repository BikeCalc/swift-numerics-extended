// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 ExpressibleByIntegerLiteral Tests")
internal struct Int4ExpressibleByIntegerLiteralTests {
    @Test(
        "Integer literal initialization succeeds",
        arguments: [
            (-8, -8),
            (-1, -1),
            (0, 0),
            (1, 1),
            (7, 7)
        ] as [(Int4, Int)]
    )
    internal func integerLiteralInitializationSucceeds(
        value: Int4,
        integer: Int
    ) throws {
        let expected: Int4 = try #require(Int4(exactly: integer))

        #expect(value == expected)
    }
}
