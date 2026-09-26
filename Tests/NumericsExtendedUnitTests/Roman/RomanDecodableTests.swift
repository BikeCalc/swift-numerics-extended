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

@Suite("Roman Decodable Tests")
internal struct RomanDecodableTests {
    @Test(
        "Decode from JSON string succeeds",
        arguments: [
            ("\"I\"", 1),
            ("\"IV\"", 4),
            ("\"XVI\"", 16),
            ("\"MMMCMXCIX\"", 3_999)
        ] as Array<(String, Roman)>
    )
    internal func decodeFromJSONStringSucceeds(
        json: String,
        value: Roman
    ) throws {
        let data: Data = try #require(json.data(using: .utf8))
        let result: Roman = try JSONDecoder().decode(
            Roman.self,
            from: data
        )

        #expect(result == value)
    }

    @Test(
        "Decode from JSON integer succeeds",
        arguments: [
            ("1", 1),
            ("4", 4),
            ("16", 16),
            ("3999", 3_999)
        ] as Array<(String, Roman)>
    )
    internal func decodeFromJSONIntegerSucceeds(
        json: String,
        value: Roman
    ) throws {
        let data: Data = try #require(json.data(using: .utf8))
        let result: Roman = try JSONDecoder().decode(
            Roman.self,
            from: data
        )

        #expect(result == value)
    }

    @Test(
        "Decode from JSON throws",
        arguments: [
            "\"\"",
            "\"-1\"",
            "\"4000\"",
            "\"IIII\"",
            "\"IXI\"",
            "\"ABC\"",
            "-1",
            "4000",
            "true"
        ]
    )
    internal func decodeFromJSONThrows(json: String) throws {
        let data: Data = try #require(json.data(using: .utf8))

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                Roman.self,
                from: data
            )
        }
    }
}

// MARK: - Positive Zero

extension RomanDecodableTests {
    @Test("Positive zero decodes from JSON string")
    internal func positiveZeroDecodesFromJSONString() throws {
        let data: Data = try #require("\"N\"".data(using: .utf8))
        let result: Roman = try JSONDecoder().decode(
            Roman.self,
            from: data
        )

        #expect(result == .zero)
    }

    @Test("Positive zero decodes from JSON integer")
    internal func positiveZeroDecodesFromJSONInteger() throws {
        let data: Data = try #require("0".data(using: .utf8))
        let result: Roman = try JSONDecoder().decode(
            Roman.self,
            from: data
        )

        #expect(result == .zero)
    }
}
#endif
