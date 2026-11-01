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
    internal init() {}

    private static let subtractionArguments: [(UInt4, UInt4.Subtrahend, UInt4)] = [
        (3, 2, 1),
        (5, 3, 2)
    ]

    @Test(
        "Subtraction succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionSucceeds(
        minuend: UInt4,
        subtrahend: UInt4.Subtrahend,
        difference: UInt4
    ) {
        let result: UInt4 = minuend - subtrahend
        #expect(result == difference)
    }

    @Test(
        "Subtraction equal succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionEqualSucceeds(
        minuend: UInt4,
        subtrahend: UInt4.Subtrahend,
        difference: UInt4
    ) {
        var result: UInt4 = minuend
        result -= subtrahend
        #expect(result == difference)
    }

    @Test(
        "Subtracting succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractingSucceeds(
        minuend: UInt4,
        subtrahend: UInt4.Subtrahend,
        difference: UInt4
    ) throws {
        let result: UInt4 = try minuend.subtracting(subtrahend)
        #expect(result == difference)
    }

    @Test(
        "Subtract succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractSucceeds(
        minuend: UInt4,
        subtrahend: UInt4.Subtrahend,
        difference: UInt4
    ) throws {
        var result: UInt4 = minuend
        try result.subtract(subtrahend)
        #expect(result == difference)
    }
}

extension UInt4SubtractableTests {
    @Test(
        "Subtraction is not commutative",
        arguments: Self.subtractionArguments
    )
    internal func subtractionIsNotCommutative(
        minuend: UInt4,
        subtrahend: UInt4.Subtrahend,
        difference: UInt4
    ) {
        let reversedDifferenceReport: UInt4.OverflowReport<UInt4.Difference> = subtrahend.subtractingReportingOverflow(
            minuend
        )
        let result: UInt4 = minuend - subtrahend
        #expect(result == difference)
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
        let result: UInt4 = minuend - UInt4.zero
        #expect(result == minuend)
    }

    @Test(
        "Subtracting self returns positive zero",
        arguments: [
            3,
            5
        ] as Array<UInt4>
    )
    internal func subtractingSelfReturnsPositiveZero(value: UInt4) {
        let result: UInt4 = value - value
        #expect(result == UInt4.zero)
    }
}
