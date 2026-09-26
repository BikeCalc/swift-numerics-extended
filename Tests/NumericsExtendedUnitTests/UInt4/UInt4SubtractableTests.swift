// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Subtractable Tests")
internal struct UInt4SubtractableTests {
    private static let subtractionArguments: [(UInt4, UInt4, UInt4)] = [
        (3, 2, 1),
        (5, 3, 2)
    ]

    @Test(
        "Subtraction succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionSucceeds(
        minuend: UInt4,
        subtrahend: UInt4,
        difference: UInt4
    ) {
        #expect(minuend - subtrahend == difference)
    }

    @Test(
        "Subtraction equal succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionEqualSucceeds(
        minuend: UInt4,
        subtrahend: UInt4,
        difference: UInt4
    ) {
        var runningDifference: UInt4 = minuend
        runningDifference -= subtrahend
        #expect(runningDifference == difference)
    }

    @Test(
        "Subtracting succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractingSucceeds(
        minuend: UInt4,
        subtrahend: UInt4,
        difference: UInt4
    ) {
        #expect(minuend.subtracting(subtrahend) == difference)
    }

    @Test(
        "Subtract succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractSucceeds(
        minuend: UInt4,
        subtrahend: UInt4,
        difference: UInt4
    ) {
        var runningDifference: UInt4 = minuend
        runningDifference.subtract(subtrahend)
        #expect(runningDifference == difference)
    }
}

extension UInt4SubtractableTests {
    @Test(
        "Subtraction is not commutative",
        arguments: Self.subtractionArguments
    )
    internal func subtractionIsNotCommutative(
        minuend: UInt4,
        subtrahend: UInt4,
        difference: UInt4
    ) {
        let reversedDifferenceReport: UInt4.OverflowReport = subtrahend.subtractingReportingOverflow(minuend)

        #expect(minuend - subtrahend == difference)
        #expect(reversedDifferenceReport.partialValue != difference)
        #expect(reversedDifferenceReport.overflow == true)
    }
}

// MARK: - Positive Zero

extension UInt4SubtractableTests {
    @Test(
        "Subtracting positive zero preserves minuend",
        arguments: [
            3,
            5
        ] as Array<UInt4>
    )
    internal func subtractingPositiveZeroPreservesMinuend(minuend: UInt4) {
        #expect(minuend - UInt4.zero == minuend)
    }

    @Test(
        "Subtracting self returns positive zero",
        arguments: [
            3,
            5
        ] as Array<UInt4>
    )
    internal func subtractingSelfReturnsPositiveZero(value: UInt4) {
        #expect(value - value == UInt4.zero)
    }
}
