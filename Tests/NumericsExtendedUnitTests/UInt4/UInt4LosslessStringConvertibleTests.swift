// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 LosslessStringConvertible Tests")
internal struct UInt4LosslessStringConvertibleTests {
    @Test(
        "String initialization succeeds",
        arguments: [
            ("1", 1),
            ("15", 15)
        ] as Array<(String, UInt4)>
    )
    internal func stringInitializationSucceeds(
        description: String,
        value: UInt4
    ) {
        #expect(UInt4(description) == value)
    }

    @Test(
        "String initialization fails",
        arguments: [
            "",
            "-1",
            "16",
            "abc",
            "1.0"
        ]
    )
    internal func stringInitializationFails(description: String) {
        #expect(UInt4(description) == nil)
    }
}

// MARK: - Positive Zero

extension UInt4LosslessStringConvertibleTests {
    @Test("Positive zero string initialization succeeds")
    internal func positiveZeroStringInitializationSucceeds() {
        #expect(UInt4("0") == .zero)
    }
}
