// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import DecimalAnnexIntegration
import DecimalCore
import Foundation
import NumericsExtended
import Testing

@Suite("Decimal128 measurement precision", .enabled(if: Decimal128Availability.isSupported))
internal struct Decimal128PrecisionTests {
    @Test("Large decimal unit conversions preserve the input")
    internal func largeUnitConversionPreservesInput() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let metres: Decimal128 = try #require(.init("9007199254740993"))
        let coefficient: Decimal128 = try #require(.init("0.001"))
        let expected: Decimal128 = try #require(.init("9007199254740.993"))
        let kilometres: Decimal128 = try Self.scaled(metres, by: coefficient)
        #expect(kilometres == expected)
        #expect(try Self.divided(kilometres, by: coefficient) == metres)
        #expect(Decimal128(nearest: Double(9_007_199_254_740_993 as Int64)) != metres)
    }

    @Test("Finite precision limits report inexact arithmetic")
    internal func finitePrecisionReportsInexactArithmetic() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let large: Decimal128 = try #require(.init("1e30"))
        let retained: Decimal128 = try #require(.init("0.001"))
        let lost: Decimal128 = try #require(.init("0.0001"))
        var flags: DecimalFloatingPointStatusFlags = []
        #expect(large.adding(retained, rounding: .toNearestOrEven, &flags) != large)
        #expect(flags.isEmpty == true)
        #expect(large.adding(lost, rounding: .toNearestOrEven, &flags) == large)
        #expect(flags.contains(.inexact) == true)
    }

    @Test("Nonterminating conversions remain rounded")
    internal func nonterminatingConversionsRemainRounded() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        var flags: DecimalFloatingPointStatusFlags = []
        let third: Decimal128 = Decimal128(1).divided(by: 3, rounding: .toNearestOrEven, &flags)
        #expect(third * 3 != 1)
        #expect(flags.contains(.inexact) == true)
        flags = []
        let coefficient: Decimal128 = try #require(.init("3.6"))
        #expect(Decimal128(36).divided(by: coefficient, rounding: .toNearestOrEven, &flags) == 10)
        #expect(flags.isEmpty == true)
        _ = Decimal128(1).divided(by: coefficient, rounding: .toNearestOrEven, &flags)
        #expect(flags.contains(.inexact) == true)
    }

    @Test("Decimal text avoids binary input rounding")
    internal func textAvoidsBinaryInputRounding() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let expected: Decimal128 = try #require(.init("0.1"))
        #expect(Decimal128(nearest: Double(0.1)) != expected)
        #expect(Decimal128(shortest: Double(0.1)) == expected)
        #expect(Decimal128(exactly: Double(0.1)) == nil)
    }

    @Test("Preferred quantum survives string and Codable round trips")
    internal func quantumSurvivesRoundTrips() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let first: Decimal128 = try #require(.init("1.0"))
        let second: Decimal128 = try #require(.init("1.00"))
        #expect(first == second)
        #expect(first.hasSameQuantum(as: second) == false)
        #expect(Set([first, second]).count == 1)
        let encoded: Data = try JSONEncoder().encode(second)
        let decoded: Decimal128 = try JSONDecoder().decode(Decimal128.self, from: encoded)
        #expect(decoded.bitPattern == second.bitPattern)
        #expect(second.description == "1.00")
        #expect(MemoryLayout<Decimal128>.size == 16)
    }

    @Test("Special results expose explicit status flags")
    internal func specialResultsExposeStatusFlags() {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        var flags: DecimalFloatingPointStatusFlags = []
        #expect(Decimal128(1).divided(by: 0, rounding: .toNearestOrEven, &flags) == .infinity)
        #expect(flags.contains(.divisionByZero) == true)
        flags = []
        #expect(Decimal128.zero.divided(by: 0, rounding: .toNearestOrEven, &flags).isNaN == true)
        #expect(flags.contains(.invalid) == true)
        flags = []
        let overflow: Decimal128 = .greatestFiniteMagnitude.multiplied(by: 10, rounding: .toNearestOrEven, &flags)
        #expect(overflow.isInfinite == true)
        #expect(flags.contains(.overflowInexact) == true)
        flags = []
        let underflow: Decimal128 = .leastNonzeroMagnitude.divided(by: 10, rounding: .toNearestOrEven, &flags)
        #expect(underflow.isZero == true)
        #expect(flags.contains(.underflowInexact) == true)
    }

    @available(anyAppleOS 26.0, *)
    private static func scaled<Value>(_ value: Value, by coefficient: Value) throws -> Value
    where Value: Multipliable, Value.Multiplier == Value, Value.Product == Value {
        return try value.multiplying(by: coefficient)
    }

    @available(anyAppleOS 26.0, *)
    private static func divided<Value>(_ value: Value, by coefficient: Value) throws -> Value
    where Value: Divisible, Value.Divisor == Value, Value.Quotient == Value {
        return try value.dividing(by: coefficient)
    }
}
