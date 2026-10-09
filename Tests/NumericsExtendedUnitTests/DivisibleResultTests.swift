// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Testing

@Suite("Divisible Result Tests")
internal struct DivisibleResultTests {
    private struct Operand: Divisible {
        fileprivate typealias Divisor = Int
        fileprivate typealias Quotient = String
        fileprivate typealias RemainderDivisor = Int
        fileprivate typealias Remainder = Int

        fileprivate var reciprocal: Self? { return nil }
        fileprivate var isInvertible: Bool { return false }
        fileprivate func isDivisible(by other: Self) -> Bool {
            return other.value != 0 && self.value % other.value == 0
        }
        fileprivate static func / (
            _ lhs: Self,
            _ rhs: Self.Divisor
        ) -> Self.Quotient {
            return String(lhs.value / rhs)
        }
        fileprivate static func % (
            _ lhs: Self,
            _ rhs: Self.RemainderDivisor
        ) -> Self.Remainder {
            return lhs.value % rhs
        }

        fileprivate let value: Int
        fileprivate init(_ value: Int) {
            self.value = value
        }
    }

    @Test("Nonmutating operations support distinct operand and result types")
    internal func distinctResult() throws {
        let value = Operand(4)
        #expect(value / 3 == "1")
        #expect(value % 3 == 1)
        #expect(try value.dividing(by: 3) == "1")
    }
}
