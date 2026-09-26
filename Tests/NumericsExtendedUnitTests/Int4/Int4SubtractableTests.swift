// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 Subtractable Tests")
internal struct Int4SubtractableTests {
    private static let subtractionArguments: [(Int4, Int4, Int4)] = [
        (3, 2, 1),
        (5, 3, 2),
        (-3, 2, -5),
        (-5, -3, -2)
    ]

    @Test(
        "Subtraction succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionSucceeds(
        minuend: Int4,
        subtrahend: Int4,
        difference: Int4
    ) {
        #expect(minuend - subtrahend == difference)
    }

    @Test(
        "Subtraction equal succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionEqualSucceeds(
        minuend: Int4,
        subtrahend: Int4,
        difference: Int4
    ) {
        var runningDifference: Int4 = minuend
        runningDifference -= subtrahend
        #expect(runningDifference == difference)
    }

    @Test(
        "Subtracting succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractingSucceeds(
        minuend: Int4,
        subtrahend: Int4,
        difference: Int4
    ) {
        #expect(minuend.subtracting(subtrahend) == difference)
    }

    @Test(
        "Subtract succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractSucceeds(
        minuend: Int4,
        subtrahend: Int4,
        difference: Int4
    ) {
        var runningDifference: Int4 = minuend
        runningDifference.subtract(subtrahend)
        #expect(runningDifference == difference)
    }
}

extension Int4SubtractableTests {
    @Test(
        "Subtraction is not commutative",
        arguments: Self.subtractionArguments
    )
    internal func subtractionIsNotCommutative(
        minuend: Int4,
        subtrahend: Int4,
        difference _: Int4
    ) {
        #expect(minuend - subtrahend != subtrahend - minuend)
    }
}

// MARK: - Negative Zero

extension Int4SubtractableTests {
    @Test(
        "Subtracting negative zero preserves minuend",
        arguments: [
            3,
            5,
            -3,
            -5
        ] as Array<Int4>
    )
    internal func subtractingNegativeZeroPreservesMinuend(minuend: Int4) {
        #expect(minuend - Int4.negativeZero == minuend)
    }
}

// MARK: - Positive Zero

extension Int4SubtractableTests {
    @Test(
        "Subtracting positive zero preserves minuend",
        arguments: [
            3,
            5,
            -3,
            -5
        ] as Array<Int4>
    )
    internal func subtractingPositiveZeroPreservesMinuend(minuend: Int4) {
        #expect(minuend - Int4.zero == minuend)
    }

    @Test(
        "Subtracting self returns positive zero",
        arguments: [
            3,
            5,
            -3,
            -5
        ] as Array<Int4>
    )
    internal func subtractingSelfReturnsPositiveZero(value: Int4) {
        #expect(value - value == Int4.zero)
    }
}
