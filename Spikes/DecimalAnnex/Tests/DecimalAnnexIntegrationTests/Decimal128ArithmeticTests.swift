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

@Suite("Decimal128 generic arithmetic", .enabled(if: Decimal128Availability.isSupported))
internal struct Decimal128ArithmeticTests {
    @Test("Generic addition preserves decimal inputs")
    internal func additionPreservesDecimalInputs() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let values: Array<Decimal128> = [try #require(.init("0.1")), try #require(.init("0.2"))]
        let expected: Decimal128 = try #require(.init("0.3"))
        #expect(try Self.total(values) == expected)
    }

    @Test("Named arithmetic dispatches through core protocols")
    internal func namedArithmeticUsesCoreProtocols() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        #expect(try Self.difference(Decimal128(7), 4) == 3)
        #expect(try Self.product(Decimal128(7), 4) == 28)
        #expect(try Self.quotient(Decimal128(7), 4) == Decimal128("1.75"))
    }

    @Test("Remainder truncates the quotient toward zero", arguments: [(7, 4, 3), (-7, 4, -3), (7, -4, 3)])
    internal func remainderTruncatesQuotient(dividend: Int, divisor: Int, expected: Int) {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let value: Decimal128 = .init(dividend)
        let other: Decimal128 = .init(divisor)
        #expect(Self.remainder(value, other) == Decimal128(expected))
        if dividend == 7 && divisor == 4 {
            #expect(value.remainder(dividingBy: other) == -1)
        }
    }

    @Test(
        "Integer exponentiation supports positive, zero, and negative powers",
        arguments: [(2, 3, "8"), (2, 0, "1"), (2, -3, "0.125"), (-2, 3, "-8")]
    )
    internal func powersUseIntegerExponents(base: Int, exponent: Int, expected: String) throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let result: Decimal128 = try Self.power(.init(base), exponent)
        #expect(result == Decimal128(expected))
    }

    @Test("Reciprocal follows the existing floating-point representability policy")
    internal func reciprocalUsesExistingPolicy() {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        #expect(Self.reciprocal(Decimal128(2)) == Decimal128("0.5"))
        #expect(Self.reciprocal(Decimal128.zero) == .infinity)
        #expect(Self.reciprocal(-Decimal128.zero) == -.infinity)
        #expect(Self.reciprocal(Decimal128.infinity) == .zero)
        #expect(Self.reciprocal(Decimal128.nan)?.isNaN == true)
        #expect(Self.reciprocal(Decimal128.greatestFiniteMagnitude) == nil)
        #expect(Self.reciprocal(Decimal128.leastNonzeroMagnitude) == nil)
    }

    @Test("Negation and percentage adjustments use generic operations")
    internal func adjustmentsUseGenericOperations() {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        #expect(Self.opposite(Decimal128(2)) == -2)
        #expect(Self.increased(Decimal128(100), by: 10) == 110)
        #expect(Self.decreased(Decimal128(100), by: 10) == 90)
    }

    @Test("Generic representations and relations are available")
    internal func representationsAndRelationsAreAvailable() {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        #expect(Self.zero(Decimal128.self) == 0)
        #expect(Self.infinity(Decimal128.self).isInfinite == true)
        #expect(Self.nan(Decimal128.self).isNaN == true)
        #expect(Self.isDivisible(Decimal128(6), by: 3) == true)
        #expect(Self.isDivisible(Decimal128(7), by: 3) == false)
        #expect(Self.isDivisible(Decimal128(7), by: 0) == false)
        #expect(Self.isPower(Decimal128(8), of: 2) == true)
    }

    @Test("Approximate equality uses decimal tolerances through the core protocol")
    internal func approximateEqualityUsesDecimalTolerances() throws {
        guard #available(anyAppleOS 26.0, *) else {
            return
        }

        let value: Decimal128 = try #require(.init("1.001"))
        let tolerance: Decimal128 = try #require(.init("0.001"))
        #expect(Self.approximatelyEqual(value, 1, absoluteTolerance: tolerance) == true)
        #expect(Self.approximatelyEqual(value, 1, absoluteTolerance: 0) == false)
        #expect(Self.approximatelyEqual(Decimal128.nan, .nan, absoluteTolerance: tolerance) == false)
        #expect(Self.approximatelyEqual(Decimal128.infinity, .infinity, absoluteTolerance: tolerance) == true)
    }

    @available(anyAppleOS 26.0, *)
    private static func total<Value>(_ values: Array<Value>) throws -> Value
    where Value: Addable & RepresentableByZero, Value.Addend == Value, Value.Sum == Value {
        var result: Value = .zero
        for value in values {
            result = try result.adding(value)
        }
        return result
    }

    @available(anyAppleOS 26.0, *)
    private static func difference<Value>(_ lhs: Value, _ rhs: Value) throws -> Value
    where Value: Subtractable, Value.Subtrahend == Value, Value.Difference == Value {
        return try lhs.subtracting(rhs)
    }

    @available(anyAppleOS 26.0, *)
    private static func product<Value>(_ lhs: Value, _ rhs: Value) throws -> Value
    where Value: Multipliable, Value.Multiplier == Value, Value.Product == Value {
        return try lhs.multiplying(by: rhs)
    }

    @available(anyAppleOS 26.0, *)
    private static func quotient<Value>(_ lhs: Value, _ rhs: Value) throws -> Value
    where Value: Divisible, Value.Divisor == Value, Value.Quotient == Value {
        return try lhs.dividing(by: rhs)
    }

    @available(anyAppleOS 26.0, *)
    private static func remainder<Value>(_ lhs: Value, _ rhs: Value) -> Value
    where Value: Divisible, Value.RemainderDivisor == Value, Value.Remainder == Value {
        return lhs % rhs
    }

    @available(anyAppleOS 26.0, *)
    private static func power<Value>(_ value: Value, _ exponent: Int) throws -> Value
    where Value: Raisable, Value.Exponent == Int, Value.Power == Value {
        return try value.raising(to: exponent)
    }

    @available(anyAppleOS 26.0, *)
    private static func reciprocal<Value>(_ value: Value) -> Value.Reciprocal? where Value: Invertible {
        return value.reciprocal
    }

    @available(anyAppleOS 26.0, *)
    private static func opposite<Value>(_ value: Value) -> Value where Value: Negateable {
        return value.negating()
    }

    @available(anyAppleOS 26.0, *)
    private static func increased<Value>(_ value: Value, by percentage: Value) -> Value where Value: Increasable {
        return value.increasing(by: percentage)
    }

    @available(anyAppleOS 26.0, *)
    private static func decreased<Value>(_ value: Value, by percentage: Value) -> Value where Value: Decreasable {
        return value.decreasing(by: percentage)
    }

    @available(anyAppleOS 26.0, *)
    private static func zero<Value>(_: Value.Type) -> Value where Value: RepresentableByZero {
        return .zero
    }

    @available(anyAppleOS 26.0, *)
    private static func infinity<Value>(_: Value.Type) -> Value where Value: RepresentableByInfinity {
        return .infinity
    }

    @available(anyAppleOS 26.0, *)
    private static func nan<Value>(_: Value.Type) -> Value where Value: RepresentableByNaN {
        return .nan
    }

    @available(anyAppleOS 26.0, *)
    private static func isDivisible<Value>(_ value: Value, by other: Value) -> Bool where Value: Divisible {
        return value.isDivisible(by: other)
    }

    @available(anyAppleOS 26.0, *)
    private static func isPower<Value>(_ value: Value, of base: Value) -> Bool where Value: Raisable {
        return value.isPower(of: base)
    }

    @available(anyAppleOS 26.0, *)
    private static func approximatelyEqual<Value>(_ lhs: Value, _ rhs: Value, absoluteTolerance: Value) -> Bool
    where Value: ApproximatelyEquatable, Value.AbsoluteTolerance == Value, Value.RelativeTolerance == Value {
        return lhs.isApproximatelyEqual(to: rhs, absoluteTolerance: absoluteTolerance, relativeTolerance: 0)
    }
}
