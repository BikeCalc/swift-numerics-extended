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

@Suite("Roman Encodable Tests")
internal struct RomanEncodableTests {
    @Test(
        "Encode to JSON succeeds",
        arguments: [
            (1, "\"I\""),
            (4, "\"IV\""),
            (16, "\"XVI\""),
            (3_999, "\"MMMCMXCIX\"")
        ] as Array<(Roman, String)>
    )
    internal func encodeToJSONSucceeds(
        value: Roman,
        json: String
    ) throws {
        let result: Data = try JSONEncoder().encode(value)
        let expected: Data = try #require(json.data(using: .utf8))

        #expect(result == expected)
    }
}

// MARK: - Positive Zero

extension RomanEncodableTests {
    @Test("Positive zero encodes to JSON")
    internal func positiveZeroEncodesToJSON() throws {
        let result: Data = try JSONEncoder().encode(Roman.zero)
        let expected: Data = try #require("\"N\"".data(using: .utf8))

        #expect(result == expected)
    }
}
#endif
