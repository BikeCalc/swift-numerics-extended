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

@Suite("UInt4 Decodable Tests")
internal struct UInt4DecodableTests {
    @Test(
        "Decode from JSON succeeds",
        arguments: [
            ("1", 1),
            ("15", 15)
        ] as Array<(String, UInt4)>
    )
    internal func decodeFromJSONSucceeds(
        json: String,
        value: UInt4
    ) throws {
        let data: Data = try #require(json.data(using: .utf8))
        let result: UInt4 = try JSONDecoder().decode(
            UInt4.self,
            from: data
        )

        #expect(result == value)
    }

    @Test(
        "Decode from JSON throws",
        arguments: [
            "-1",
            "16",
            "\"1\"",
            "true"
        ]
    )
    internal func decodeFromJSONThrows(json: String) throws {
        let data: Data = try #require(json.data(using: .utf8))

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                UInt4.self,
                from: data
            )
        }
    }
}

// MARK: - Positive Zero

extension UInt4DecodableTests {
    @Test("Positive zero decodes from JSON")
    internal func positiveZeroDecodesFromJSON() throws {
        let data: Data = try #require("0".data(using: .utf8))
        let result: UInt4 = try JSONDecoder().decode(
            UInt4.self,
            from: data
        )

        #expect(result == .zero)
    }
}
#endif
