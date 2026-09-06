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

@Suite("Fraction Encodable Tests")
internal struct FractionEncodableTests {
    @Test(
        "Encode to JSON succeeds",
        arguments: [
            (Fraction<Int>(1, 2), #"{"den":2,"num":1}"#),
            (Fraction<Int>(2, 4), #"{"den":4,"num":2}"#),
            (Fraction<Int>(2, -4), #"{"den":-4,"num":2}"#)
        ]
    )
    internal func encodeToJSONSucceeds(
        value: Fraction<Int>,
        json: String
    ) throws {
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = .sortedKeys

        let result: Data = try encoder.encode(value)
        let expected: Data = try #require(json.data(using: .utf8))

        #expect(result == expected)
    }
}

// MARK: - NaN

extension FractionEncodableTests {
    @Test("NaN encodes to JSON")
    internal func nanEncodesToJSON() throws {
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = .sortedKeys

        let result: Data = try encoder.encode(Fraction<Int>.nan)
        let expected: Data = try #require(#"{"den":0,"num":0}"#.data(using: .utf8))

        #expect(result == expected)
    }
}

// MARK: - Negative Infinity

extension FractionEncodableTests {
    @Test("Negative infinity encodes to JSON")
    internal func negativeInfinityEncodesToJSON() throws {
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = .sortedKeys

        let result: Data = try encoder.encode(Fraction<Int>.negativeInfinity)
        let expected: Data = try #require(#"{"den":0,"num":-1}"#.data(using: .utf8))

        #expect(result == expected)
    }
}

// MARK: - Negative Zero

extension FractionEncodableTests {
    @Test("Negative zero encodes to JSON")
    internal func negativeZeroEncodesToJSON() throws {
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = .sortedKeys

        let result: Data = try encoder.encode(Fraction<Int>(0, -2))
        let expected: Data = try #require(#"{"den":-2,"num":0}"#.data(using: .utf8))

        #expect(result == expected)
    }
}

// MARK: - Positive Infinity

extension FractionEncodableTests {
    @Test("Positive infinity encodes to JSON")
    internal func positiveInfinityEncodesToJSON() throws {
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = .sortedKeys

        let result: Data = try encoder.encode(Fraction<Int>.infinity)
        let expected: Data = try #require(#"{"den":0,"num":1}"#.data(using: .utf8))

        #expect(result == expected)
    }
}

// MARK: - Positive Zero

extension FractionEncodableTests {
    @Test("Positive zero encodes to JSON")
    internal func positiveZeroEncodesToJSON() throws {
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = .sortedKeys

        let result: Data = try encoder.encode(Fraction<Int>(0, 2))
        let expected: Data = try #require(#"{"den":2,"num":0}"#.data(using: .utf8))

        #expect(result == expected)
    }
}
#endif
