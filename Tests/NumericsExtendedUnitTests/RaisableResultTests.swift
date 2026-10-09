// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Testing

@Suite("Raisable Result Tests")
internal struct RaisableResultTests {
    private struct Operand: Raisable {
        fileprivate typealias Exponent = Int
        fileprivate typealias Power = String

        fileprivate func isPower(of other: Self) -> Bool { return self.value.isPower(of: other.value) }
        fileprivate static func ** (
            _ lhs: Self,
            _ rhs: Self.Exponent
        ) -> Self.Power {
            return String(lhs.value ** rhs)
        }

        fileprivate let value: Int
        fileprivate init(_ value: Int) {
            self.value = value
        }
    }

    @Test("Nonmutating operations support distinct operand and result types")
    internal func distinctResult() throws {
        let value = Operand(4)
        #expect(value ** 3 == "64")
        #expect(try value.raising(to: 3) == "64")
    }
}
