// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import DecimalAnnex
import Testing

@Suite("Decimal128 literal macro")
internal struct Decimal128LiteralTests {
    @Test("Decimal literals avoid binary intermediary rounding")
    internal func literalsPreserveDecimalValues() {
        #expect(#Decimal128(0.1) + #Decimal128(0.2) == #Decimal128(0.3))
        #expect(#Decimal128(9_007_199_254_740_993) == Decimal128("9007199254740993"))
    }

    @Test("Literal representation retains quantum and signed zero")
    internal func literalsPreserveRepresentation() {
        let first: Decimal128 = #Decimal128(1.0)
        let second: Decimal128 = #Decimal128(1.00)
        let negativeZero: Decimal128 = #Decimal128(-0.00)
        #expect(first == second)
        #expect(first.hasSameQuantum(as: second) == false)
        #expect(second.description == "1.00")
        #expect(negativeZero.isZero == true)
        #expect(negativeZero.sign == .minus)
    }
}
