// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Testing

@Suite("Generic Overflow Report Tests")
internal struct GenericOverflowReportTests {
    private struct Operand: ReportableAsOverflow {
        fileprivate typealias Addend = Int8
        fileprivate typealias Sum = Int8
        fileprivate typealias Subtrahend = Int16
        fileprivate typealias Difference = Int16
        fileprivate typealias Multiplier = Int32
        fileprivate typealias Product = Int32
        fileprivate typealias Divisor = Int64
        fileprivate typealias Quotient = Int64
        fileprivate typealias RemainderDivisor = UInt16
        fileprivate typealias Remainder = UInt16
        fileprivate typealias Exponent = UInt32
        fileprivate typealias Power = UInt32

        fileprivate let value: Int

        fileprivate init(_ value: Int) {
            self.value = value
        }

        fileprivate var reciprocal: Self? {
            return self.isInvertible ? self : nil
        }

        fileprivate var isInvertible: Bool {
            return self.value == 1
        }

        fileprivate func isDivisible(by other: Self) -> Bool {
            return self.value.isDivisible(by: other.value)
        }

        fileprivate func isMultiple(of other: Self) -> Bool {
            return self.value.isMultiple(of: other.value)
        }

        fileprivate func isPower(of other: Self) -> Bool {
            return self.value.isPower(of: other.value)
        }

        fileprivate static func + (
            _ lhs: Self,
            _ rhs: Self.Addend
        ) -> Self.Sum {
            return Int8(lhs.value) + rhs
        }

        fileprivate func addingReportingOverflow(_ rhs: Self.Addend) -> Self.OverflowReport<Self.Sum> {
            return Int8(self.value).addingReportingOverflow(rhs)
        }

        fileprivate static func - (
            _ lhs: Self,
            _ rhs: Self.Subtrahend
        ) -> Self.Difference {
            return Int16(lhs.value) - rhs
        }

        fileprivate func subtractingReportingOverflow(_ rhs: Self.Subtrahend) -> Self.OverflowReport<Self.Difference> {
            return Int16(self.value).subtractingReportingOverflow(rhs)
        }

        fileprivate static func * (
            _ lhs: Self,
            _ rhs: Self.Multiplier
        ) -> Self.Product {
            return Int32(lhs.value) * rhs
        }

        fileprivate func multipliedReportingOverflow(by rhs: Self.Multiplier) -> Self.OverflowReport<Self.Product> {
            return Int32(self.value).multipliedReportingOverflow(by: rhs)
        }

        fileprivate static func / (
            _ lhs: Self,
            _ rhs: Self.Divisor
        ) -> Self.Quotient {
            return Int64(lhs.value) / rhs
        }

        fileprivate func dividedReportingOverflow(by rhs: Self.Divisor) -> Self.OverflowReport<Self.Quotient> {
            return Int64(self.value).dividedReportingOverflow(by: rhs)
        }

        fileprivate static func % (
            _ lhs: Self,
            _ rhs: Self.RemainderDivisor
        ) -> Self.Remainder {
            return UInt16(lhs.value) % rhs
        }

        fileprivate func remainderReportingOverflow(
            dividingBy rhs: Self.RemainderDivisor
        ) -> Self.OverflowReport<Self.Remainder> {
            return UInt16(self.value).remainderReportingOverflow(dividingBy: rhs)
        }

        fileprivate static func ** (
            _ lhs: Self,
            _ rhs: Self.Exponent
        ) -> Self.Power {
            return UInt32(lhs.value) ** rhs
        }

        fileprivate func raisedReportingOverflow(to rhs: Self.Exponent) -> Self.OverflowReport<Self.Power> {
            return UInt32(self.value).raisedReportingOverflow(to: rhs)
        }
    }

    @Test("Each operation reports its own result type")
    internal func distinctResults() {
        let value = Operand(12)
        let sum: Operand.OverflowReport<Operand.Sum> = value.addingReportingOverflow(120)
        #expect(sum.partialValue == -124)
        #expect(sum.overflow == true)

        let difference: Operand.OverflowReport<Operand.Difference> = value.subtractingReportingOverflow(2)
        #expect(difference.partialValue == 10)
        #expect(difference.overflow == false)

        let product: Operand.OverflowReport<Operand.Product> = value.multipliedReportingOverflow(by: 3)
        #expect(product.partialValue == 36)
        #expect(product.overflow == false)

        let quotient: Operand.OverflowReport<Operand.Quotient> = value.dividedReportingOverflow(by: 3)
        #expect(quotient.partialValue == 4)
        #expect(quotient.overflow == false)

        let remainder: Operand.OverflowReport<Operand.Remainder> = value.remainderReportingOverflow(dividingBy: 5)
        #expect(remainder.partialValue == 2)
        #expect(remainder.overflow == false)

        let power: Operand.OverflowReport<Operand.Power> = value.raisedReportingOverflow(to: 2)
        #expect(power.partialValue == 144)
        #expect(power.overflow == false)
    }
}
