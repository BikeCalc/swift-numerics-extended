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

@Suite("Int4 Decodable Tests")
internal struct Int4DecodableTests {
    @Test(
        "Decode from JSON succeeds",
        arguments: [
            ("-8", -8),
            ("-1", -1),
            ("1", 1),
            ("7", 7)
        ] as Array<(String, Int4)>
    )
    internal func decodeFromJSONSucceeds(
        json: String,
        value: Int4
    ) throws {
        let data: Data = try #require(json.data(using: .utf8))
        let result: Int4 = try JSONDecoder().decode(
            Int4.self,
            from: data
        )

        #expect(result == value)
    }

    @Test(
        "Decode from JSON throws",
        arguments: [
            "-9",
            "8",
            "\"1\"",
            "true"
        ]
    )
    internal func decodeFromJSONThrows(json: String) throws {
        let data: Data = try #require(json.data(using: .utf8))

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                Int4.self,
                from: data
            )
        }
    }
}

// MARK: - Negative Zero

extension Int4DecodableTests {
    @Test("Negative zero decodes from JSON")
    internal func negativeZeroDecodesFromJSON() throws {
        let data: Data = try #require("-0".data(using: .utf8))
        let result: Int4 = try JSONDecoder().decode(
            Int4.self,
            from: data
        )

        #expect(result == .negativeZero)
    }
}

// MARK: - Positive Zero

extension Int4DecodableTests {
    @Test("Positive zero decodes from JSON")
    internal func positiveZeroDecodesFromJSON() throws {
        let data: Data = try #require("0".data(using: .utf8))
        let result: Int4 = try JSONDecoder().decode(
            Int4.self,
            from: data
        )

        #expect(result == .zero)
    }
}
#endif
