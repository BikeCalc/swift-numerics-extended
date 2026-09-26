// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman ExpressibleByIntegerLiteral Tests")
internal struct RomanExpressibleByIntegerLiteralTests {
    @Test(
        "Integer literal initialization succeeds",
        arguments: [
            (0, 0),
            (1, 1),
            (3_999, 3_999)
        ] as [(Roman, Int)]
    )
    internal func integerLiteralInitializationSucceeds(
        value: Roman,
        integer: Int
    ) throws {
        let expected: Roman = try #require(Roman(exactly: integer))

        #expect(value == expected)
    }
}
