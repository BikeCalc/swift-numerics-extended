// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 LosslessStringConvertible Tests")
internal struct Int4LosslessStringConvertibleTests {
    @Test(
        "String initialization succeeds",
        arguments: [
            ("-8", -8),
            ("-1", -1),
            ("1", 1),
            ("7", 7)
        ] as Array<(String, Int4)>
    )
    internal func stringInitializationSucceeds(
        description: String,
        value: Int4
    ) {
        #expect(Int4(description) == value)
    }

    @Test(
        "String initialization fails",
        arguments: [
            "-9",
            "8",
            "A"
        ]
    )
    internal func stringInitializationFails(description: String) {
        #expect(Int4(description) == nil)
    }
}

// MARK: - Negative Zero

extension Int4LosslessStringConvertibleTests {
    @Test("Negative zero string initialization succeeds")
    internal func negativeZeroStringInitializationSucceeds() {
        #expect(Int4("-0") == .negativeZero)
    }
}

// MARK: - Positive Zero

extension Int4LosslessStringConvertibleTests {
    @Test("Positive zero string initialization succeeds")
    internal func positiveZeroStringInitializationSucceeds() {
        #expect(Int4("0") == .zero)
    }
}
