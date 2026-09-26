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

@Suite("Fraction Decodable Tests")
internal struct FractionDecodableTests {
    @Test(
        "Decode from JSON succeeds",
        arguments: [
            (#"{"num":1,"den":2}"#, Fraction<Int>(1, 2)),
            (#"{"num":2,"den":4}"#, Fraction<Int>(2, 4)),
            (#"{"num":2,"den":-4}"#, Fraction<Int>(2, -4))
        ]
    )
    internal func decodeFromJSONSucceeds(
        json: String,
        value: Fraction<Int>
    ) throws {
        let data: Data = try #require(json.data(using: .utf8))
        let result: Fraction<Int> = try JSONDecoder().decode(
            Fraction<Int>.self,
            from: data
        )

        #expect(result == value)
    }

    @Test(
        "Decode from JSON throws",
        arguments: [
            #"{"num":1}"#,
            #"{"den":2}"#,
            #"{"num":"1","den":2}"#,
            #"[1,2]"#,
            #"true"#
        ]
    )
    internal func decodeFromJSONThrows(json: String) throws {
        let data: Data = try #require(json.data(using: .utf8))

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                Fraction<Int>.self,
                from: data
            )
        }
    }
}

// MARK: - NaN

extension FractionDecodableTests {
    @Test("NaN decodes from JSON")
    internal func nanDecodesFromJSON() throws {
        let json: String = #"{"num":0,"den":0}"#
        let data: Data = try #require(json.data(using: .utf8))
        let result: Fraction<Int> = try JSONDecoder().decode(
            Fraction<Int>.self,
            from: data
        )

        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionDecodableTests {
    @Test("Negative infinity decodes from JSON")
    internal func negativeInfinityDecodesFromJSON() throws {
        let json: String = #"{"num":-2,"den":0}"#
        let data: Data = try #require(json.data(using: .utf8))
        let result: Fraction<Int> = try JSONDecoder().decode(
            Fraction<Int>.self,
            from: data
        )

        #expect(result == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionDecodableTests {
    @Test("Negative zero decodes from JSON")
    internal func negativeZeroDecodesFromJSON() throws {
        let json: String = #"{"num":0,"den":-2}"#
        let data: Data = try #require(json.data(using: .utf8))
        let result: Fraction<Int> = try JSONDecoder().decode(
            Fraction<Int>.self,
            from: data
        )

        #expect(result == Fraction<Int>(0, -2))
    }
}

// MARK: - Positive Infinity

extension FractionDecodableTests {
    @Test("Positive infinity decodes from JSON")
    internal func positiveInfinityDecodesFromJSON() throws {
        let json: String = #"{"num":2,"den":0}"#
        let data: Data = try #require(json.data(using: .utf8))
        let result: Fraction<Int> = try JSONDecoder().decode(
            Fraction<Int>.self,
            from: data
        )

        #expect(result == .infinity)
    }
}

// MARK: - Positive Zero

extension FractionDecodableTests {
    @Test("Positive zero decodes from JSON")
    internal func positiveZeroDecodesFromJSON() throws {
        let json: String = #"{"num":0,"den":2}"#
        let data: Data = try #require(json.data(using: .utf8))
        let result: Fraction<Int> = try JSONDecoder().decode(
            Fraction<Int>.self,
            from: data
        )

        #expect(result == Fraction<Int>(0, 2))
    }
}
#endif
