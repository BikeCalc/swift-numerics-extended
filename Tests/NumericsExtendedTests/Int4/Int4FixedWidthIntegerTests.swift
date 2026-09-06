// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 FixedWidthInteger Tests")
internal struct Int4FixedWidthIntegerTests {
    @Test("Has four bits")
    internal func hasFourBits() {
        #expect(Int4.bitWidth == 4)
    }

    @Test("Is signed")
    internal func isSigned() {
        #expect(Int4.isSigned == true)
    }

    @Test(
        "Nonzero bit count succeeds",
        arguments: [
            (Int4.min, 1),
            (-7, 2),
            (-6, 2),
            (-5, 3),
            (-4, 2),
            (-3, 3),
            (-2, 3),
            (-1, 4),
            (0, 0),
            (1, 1),
            (2, 1),
            (3, 2),
            (4, 1),
            (5, 2),
            (6, 2),
            (Int4.max, 3)
        ] as Array<(Int4, Int)>
    )
    internal func nonzeroBitCountSucceeds(
        value: Int4,
        count: Int
    ) {
        #expect(value.nonzeroBitCount == count)
    }

    @Test(
        "Leading zero bit count succeeds",
        arguments: [
            (Int4.min, 0),
            (-7, 0),
            (-6, 0),
            (-5, 0),
            (-4, 0),
            (-3, 0),
            (-2, 0),
            (-1, 0),
            (0, 4),
            (1, 3),
            (2, 2),
            (3, 2),
            (4, 1),
            (5, 1),
            (6, 1),
            (Int4.max, 1)
        ] as Array<(Int4, Int)>
    )
    internal func leadingZeroBitCountSucceeds(
        value: Int4,
        count: Int
    ) {
        #expect(value.leadingZeroBitCount == count)
    }

    @Test(
        "Byte swapped succeeds",
        arguments: [
            Int4.min,
            0,
            Int4.max
        ] as Array<Int4>
    )
    internal func byteSwappedSucceeds(value: Int4) {
        #expect(value.byteSwapped == value)
    }

    @Test(
        "Initialized truncating if needed succeeds",
        arguments: [
            (-10, 6),
            (-9, Int4.max),
            (-8, Int4.min),
            (-7, -7),
            (6, 6),
            (7, Int4.max),
            (8, Int4.min),
            (9, -7)
        ] as Array<(Int, Int4)>
    )
    internal func initializedTruncatingIfNeededSucceeds(
        source: Int,
        value: Int4
    ) {
        #expect(Int4(truncatingIfNeeded: source) == value)
    }

    @Test(
        "Initialized clamping succeeds",
        arguments: [
            (-9, Int4.min),
            (-8, Int4.min),
            (-7, -7),
            (6, 6),
            (7, Int4.max),
            (8, Int4.max)
        ] as Array<(Int, Int4)>
    )
    internal func initializedClampingSucceeds(
        source: Int,
        value: Int4
    ) {
        #expect(Int4(clamping: source) == value)
    }

    @Test(
        "Multiplied full width succeeds",
        arguments: [
            (2, 3, 0, 6),
            (3, 4, 0, 12),
            (4, 4, 1, 0),
            (7, 7, 3, 1),
            (-2, 3, -1, 10),
            (-3, -4, 0, 12)
        ] as Array<(Int4, Int4, Int4, UInt4)>
    )
    internal func multipliedFullWidthSucceeds(
        lhs: Int4,
        rhs: Int4,
        high: Int4,
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
            (7, 3, 1, 7, 0),
            (2, -1, 10, -3, 0),
            (-3, -1, 10, 2, 0),
            (2, -1, 9, -3, -1)
        ] as Array<(Int4, Int4, UInt4, Int4, Int4)>
    )
    internal func dividingFullWidthSucceeds(
        divisor: Int4,
        high: Int4,
        low: UInt4,
        quotient: Int4,
        remainder: Int4
    ) {
        let result = divisor.dividingFullWidth((high: high, low: low))

        #expect(result.quotient == quotient)
        #expect(result.remainder == remainder)
    }
}
