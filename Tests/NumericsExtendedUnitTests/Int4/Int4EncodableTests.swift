// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

#if canImport(Foundation)
import Foundation
import Testing

@testable import NumericsExtended

@Suite("Int4 Encodable Tests")
internal struct Int4EncodableTests {
    @Test(
        "Encode to JSON succeeds",
        arguments: [
            (-8, "-8"),
            (-1, "-1"),
            (1, "1"),
            (7, "7")
        ] as Array<(Int4, String)>
    )
    internal func encodeToJSONSucceeds(
        value: Int4,
        json: String
    ) throws {
        let result: Data = try JSONEncoder().encode(value)
        let expected: Data = try #require(json.data(using: .utf8))

        #expect(result == expected)
    }
}

// MARK: - Positive Zero

extension Int4EncodableTests {
    @Test("Positive zero encodes to JSON")
    internal func positiveZeroEncodesToJSON() throws {
        let result: Data = try JSONEncoder().encode(Int4.zero)
        let expected: Data = try #require("0".data(using: .utf8))

        #expect(result == expected)
    }
}
#endif
