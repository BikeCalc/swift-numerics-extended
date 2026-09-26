// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 BinaryInteger Tests")
internal struct Int4BinaryIntegerTests {
    @Test(
        "Words succeeds",
        arguments: [
            (0, 0),
            (7, 7),
            (-8, UInt(bitPattern: -8)),
            (-1, UInt(bitPattern: -1))
        ] as Array<(Int4, UInt)>
    )
    internal func wordsSucceeds(
        value: Int4,
        word: UInt
    ) {
        #expect(value.words.count == 1)
        #expect(value.words.startIndex == Int4.zero)
        #expect(value.words.endIndex == 1)
        #expect(value.words[value.words.startIndex] == word)
        #expect(Array(value.words) == [word])
    }

    @Test(
        "Trailing zero bit count succeeds",
        arguments: [
            (0, 4),
            (1, 0),
            (4, 2),
            (-8, 3)
        ] as Array<(Int4, Int)>
    )
    internal func trailingZeroBitCountSucceeds(
        value: Int4,
        count: Int
    ) {
        #expect(value.trailingZeroBitCount == count)
    }

    @Test(
        "Bitwise and equal succeeds",
        arguments: [
            (0b0110, 0b0011, 0b0010),
            (-6, -4, -8),
            (-1, 0b0101, 0b0101)
        ] as Array<(Int4, Int4, Int4)>
    )
    internal func bitwiseAndEqualSucceeds(
        value: Int4,
        mask: Int4,
        result: Int4
    ) {
        var maskedValue: Int4 = value
        maskedValue &= mask
        #expect(maskedValue == result)
    }

    @Test(
        "Bitwise or equal succeeds",
        arguments: [
            (0b0010, 0b0101, 0b0111),
            (-8, 0b0011, -5)
        ] as Array<(Int4, Int4, Int4)>
    )
    internal func bitwiseOrEqualSucceeds(
        value: Int4,
        mask: Int4,
        result: Int4
    ) {
        var maskedValue: Int4 = value
        maskedValue |= mask
        #expect(maskedValue == result)
    }

    @Test(
        "Bitwise xor equal succeeds",
        arguments: [
            (0b0110, 0b0011, 0b0101),
            (-6, -4, 0b0110),
            (-1, 0b0101, -6)
        ] as Array<(Int4, Int4, Int4)>
    )
    internal func bitwiseXorEqualSucceeds(
        value: Int4,
        mask: Int4,
        result: Int4
    ) {
        var maskedValue: Int4 = value
        maskedValue ^= mask
        #expect(maskedValue == result)
    }
}
