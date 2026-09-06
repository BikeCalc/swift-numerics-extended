// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 BinaryInteger Tests")
internal struct UInt4BinaryIntegerTests {
    @Test(
        "Words succeeds",
        arguments: [
            (0, 0),
            (7, 7),
            (15, 15)
        ] as Array<(UInt4, UInt)>
    )
    internal func wordsSucceeds(
        value: UInt4,
        word: UInt
    ) {
        #expect(value.words.count == 1)
        #expect(value.words.startIndex == UInt4.zero)
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
            (8, 3)
        ] as Array<(UInt4, Int)>
    )
    internal func trailingZeroBitCountSucceeds(
        value: UInt4,
        count: Int
    ) {
        #expect(value.trailingZeroBitCount == count)
    }

    @Test(
        "Bitwise and equal succeeds",
        arguments: [
            (0b0110, 0b0011, 0b0010),
            (0b1010, 0b1100, 0b1000)
        ] as Array<(UInt4, UInt4, UInt4)>
    )
    internal func bitwiseAndEqualSucceeds(
        value: UInt4,
        mask: UInt4,
        result: UInt4
    ) {
        var maskedValue: UInt4 = value
        maskedValue &= mask
        #expect(maskedValue == result)
    }

    @Test(
        "Bitwise or equal succeeds",
        arguments: [
            (0b0010, 0b0101, 0b0111),
            (0b1010, 0b0101, 0b1111)
        ] as Array<(UInt4, UInt4, UInt4)>
    )
    internal func bitwiseOrEqualSucceeds(
        value: UInt4,
        mask: UInt4,
        result: UInt4
    ) {
        var maskedValue: UInt4 = value
        maskedValue |= mask
        #expect(maskedValue == result)
    }

    @Test(
        "Bitwise xor equal succeeds",
        arguments: [
            (0b0110, 0b0011, 0b0101),
            (0b1010, 0b1100, 0b0110)
        ] as Array<(UInt4, UInt4, UInt4)>
    )
    internal func bitwiseXorEqualSucceeds(
        value: UInt4,
        mask: UInt4,
        result: UInt4
    ) {
        var maskedValue: UInt4 = value
        maskedValue ^= mask
        #expect(maskedValue == result)
    }
}
