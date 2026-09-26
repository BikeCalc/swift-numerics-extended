// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction ExpressibleByIntegerLiteral Tests")
internal struct FractionExpressibleByIntegerLiteralTests {
    @Test(
        "Integer literal initialization succeeds",
        arguments: [
            (-1, -1),
            (0, 0),
            (1, 1)
        ] as [(Fraction<Int>, Int)]
    )
    internal func integerLiteralInitializationSucceeds(
        value: Fraction<Int>,
        integer: Int
    ) throws {
        let expected: Fraction<Int> = try #require(Fraction<Int>(exactly: integer))

        #expect(value == expected)
    }
}
