// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 FixedWidthInteger Tests")
internal struct UInt4FixedWidthIntegerTests {
    @Test("Has four bits")
    internal func hasFourBits() {
        #expect(UInt4.bitWidth == 4)
    }

    @Test("Is unsigned")
    internal func isUnsigned() {
        #expect(UInt4.isSigned == false)
    }

    @Test(
        "Nonzero bit count succeeds",
        arguments: [
            (UInt4.min, 0),
            (1, 1),
            (2, 1),
            (3, 2),
            (4, 1),
            (5, 2),
            (6, 2),
            (7, 3),
            (8, 1),
            (9, 2),
            (10, 2),
            (11, 3),
            (12, 2),
            (13, 3),
            (14, 3),
            (UInt4.max, 4)
        ] as Array<(UInt4, Int)>
    )
    internal func nonzeroBitCountSucceeds(
        value: UInt4,
        count: Int
    ) {
        #expect(value.nonzeroBitCount == count)
    }

    @Test(
        "Leading zero bit count succeeds",
        arguments: [
            (UInt4.min, 4),
            (0b0001, 3),
            (0b0010, 2),
            (0b0011, 2),
            (0b0100, 1),
            (0b0101, 1),
            (0b0110, 1),
            (0b0111, 1),
            (0b1000, 0),
            (0b1001, 0),
            (0b1010, 0),
            (0b1011, 0),
            (0b1100, 0),
            (0b1101, 0),
            (0b1110, 0),
            (UInt4.max, 0)
        ] as Array<(UInt4, Int)>
    )
    internal func leadingZeroBitCountSucceeds(
        value: UInt4,
        count: Int
    ) {
        #expect(value.leadingZeroBitCount == count)
    }

    @Test(
        "Byte swapped succeeds",
        arguments: [
            UInt4.min,
            8,
            UInt4.max
        ] as Array<UInt4>
    )
    internal func byteSwappedSucceeds(value: UInt4) {
        #expect(value.byteSwapped == value)
    }

    @Test(
        "Initialized truncating if needed succeeds",
        arguments: [
            (-2, 14),
            (-1, UInt4.max),
            (0, UInt4.min),
            (1, 1),
            (14, 14),
            (15, UInt4.max),
            (16, UInt4.min),
            (17, 1)
        ] as Array<(Int, UInt4)>
    )
    internal func initializedTruncatingIfNeededSucceeds(
        source: Int,
        value: UInt4
    ) {
        #expect(UInt4(truncatingIfNeeded: source) == value)
    }

    @Test(
        "Initialized clamping succeeds",
        arguments: [
            (-1, UInt4.min),
            (0, UInt4.min),
            (1, 1),
            (14, 14),
            (15, UInt4.max),
            (16, UInt4.max)
        ] as Array<(Int, UInt4)>
    )
    internal func initializedClampingSucceeds(
        source: Int,
        value: UInt4
    ) {
        #expect(UInt4(clamping: source) == value)
    }

    @Test(
        "Multiplied full width succeeds",
        arguments: [
            (2, 3, 0, 6),
            (3, 4, 0, 12),
            (4, 4, 1, 0),
            (7, 7, 3, 1)
        ] as Array<(UInt4, UInt4, UInt4, UInt4)>
    )
    internal func multipliedFullWidthSucceeds(
        lhs: UInt4,
        rhs: UInt4,
        high: UInt4,
        low: UInt4
    ) {
        let result = lhs.multipliedFullWidth(by: rhs)

        #expect(result.high == high)
        #expect(result.low == low)
    }

    @Test(
        "Dividing full width succeeds",
        arguments: [
            (2, 0, 6, 3, 0),
            (3, 0, 6, 2, 0),
            (2, 0, 7, 3, 1),
            (4, 1, 0, 4, 0),
            (7, 3, 1, 7, 0)
        ] as Array<(UInt4, UInt4, UInt4, UInt4, UInt4)>
    )
    internal func dividingFullWidthSucceeds(
        divisor: UInt4,
        high: UInt4,
        low: UInt4,
        quotient: UInt4,
        remainder: UInt4
    ) {
        let result = divisor.dividingFullWidth((high: high, low: low))

        #expect(result.quotient == quotient)
        #expect(result.remainder == remainder)
    }
}
