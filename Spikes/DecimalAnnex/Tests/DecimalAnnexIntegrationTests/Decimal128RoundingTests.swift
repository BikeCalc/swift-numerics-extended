// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import DecimalAnnexIntegration
import DecimalCore
import NumericsExtended
import Testing

@Suite("Decimal128 decimal-place adjustments", .enabled(if: Decimal128Availability.isSupported))
internal struct Decimal128RoundingTests {
    @Test("Rounding uses ties away from zero", arguments: [("1.235", "1.24"), ("-1.235", "-1.24"), ("1.234", "1.23")])
    internal func roundingUsesTiesAwayFromZero(input: String, expected: String) throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let value: Decimal128 = try #require(.init(input))
        #expect(Self.rounded(value, to: 2) == Decimal128(expected))
    }

    @Test("Truncation rounds toward zero", arguments: [("1.239", "1.23"), ("-1.239", "-1.23")])
    internal func truncationRoundsTowardZero(input: String, expected: String) throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let value: Decimal128 = try #require(.init(input))
        #expect(Self.truncated(value, to: 2) == Decimal128(expected))
    }

    @Test("Large values do not acquire an unrepresentable quantum")
    internal func largeValuesRetainTheirValue() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let value: Decimal128 = try #require(.init("1e6144"))
        var flags: DecimalFloatingPointStatusFlags = []
        let raw: Decimal128 = value.quantized(by: 1, rounding: .toNearestOrEven, &flags)
        #expect(raw.isNaN == true)
        #expect(flags.contains(.invalid) == true)
        #expect(Self.rounded(value, to: 2) == value)
        #expect(Self.truncated(value, to: 2) == value)
        #expect(Self.rounded(Decimal128.greatestFiniteMagnitude, to: 100) == .greatestFiniteMagnitude)
    }

    @Test("Maximum precision requests preserve finite values")
    internal func maximumPrecisionRequestsPreserveValues() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let value: Decimal128 = try #require(.init("1.234"))
        #expect(Self.rounded(value, to: UInt.max) == value)
        #expect(Self.truncated(value, to: UInt.max) == value)
        #expect(Self.rounded(Decimal128.leastNonzeroMagnitude, to: 6_176) == .leastNonzeroMagnitude)
        #expect(Self.rounded(Decimal128.leastNonzeroMagnitude, to: 6_175).isZero == true)
    }

    @Test("Adjustments preserve special values and negative zero")
    internal func specialValuesArePreserved() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let negativeZero: Decimal128 = try #require(.init("-0.00"))
        #expect(Self.rounded(negativeZero, to: 0).sign == .minus)
        #expect(Self.truncated(negativeZero, to: 0).sign == .minus)
        #expect(Self.rounded(Decimal128.infinity, to: 2) == .infinity)
        #expect(Self.truncated(-Decimal128.infinity, to: 2) == -.infinity)
        #expect(Self.rounded(Decimal128.nan, to: 2).isNaN == true)
    }

    @Test("Mutating generic adjustments dispatch to the decimal implementations")
    internal func mutatingAdjustmentsDispatchToDecimalImplementations() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let value: Decimal128 = try #require(.init("1.235"))
        #expect(Self.roundedInPlace(value, to: 2) == Decimal128("1.24"))
        #expect(Self.truncatedInPlace(value, to: 2) == Decimal128("1.23"))
    }

    @available(anyAppleOS 26.0, *)
    private static func rounded<Value>(_ value: Value, to places: UInt) -> Value
    where Value: Roundable, Value.DecimalPlace == UInt {
        return value.rounded(to: places)
    }

    @available(anyAppleOS 26.0, *)
    private static func truncated<Value>(_ value: Value, to places: UInt) -> Value
    where Value: Truncatable, Value.DecimalPlace == UInt {
        return value.truncated(to: places)
    }

    @available(anyAppleOS 26.0, *)
    private static func roundedInPlace<Value>(_ value: Value, to places: UInt) -> Value
    where Value: Roundable, Value.DecimalPlace == UInt {
        var result: Value = value
        result.round(to: places)
        return result
    }

    @available(anyAppleOS 26.0, *)
    private static func truncatedInPlace<Value>(_ value: Value, to places: UInt) -> Value
    where Value: Truncatable, Value.DecimalPlace == UInt {
        var result: Value = value
        result.truncate(to: places)
        return result
    }
}
