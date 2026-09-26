// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Subtractable Tests")
internal struct RomanSubtractableTests {
    private static let subtractionArguments: [(Roman, Roman, Roman)] = [
        (3, 2, 1),
        (5, 3, 2)
    ]

    @Test(
        "Subtraction succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionSucceeds(
        minuend: Roman,
        subtrahend: Roman,
        difference: Roman
    ) {
        #expect(minuend - subtrahend == difference)
    }

    @Test(
        "Subtraction equal succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionEqualSucceeds(
        minuend: Roman,
        subtrahend: Roman,
        difference: Roman
    ) {
        var runningDifference: Roman = minuend
        runningDifference -= subtrahend
        #expect(runningDifference == difference)
    }

    @Test(
        "Subtracting succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractingSucceeds(
        minuend: Roman,
        subtrahend: Roman,
        difference: Roman
    ) {
        #expect(minuend.subtracting(subtrahend) == difference)
    }

    @Test(
        "Subtract succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractSucceeds(
        minuend: Roman,
        subtrahend: Roman,
        difference: Roman
    ) {
        var runningDifference: Roman = minuend
        runningDifference.subtract(subtrahend)
        #expect(runningDifference == difference)
    }
}

extension RomanSubtractableTests {
    @Test(
        "Subtraction is not commutative",
        arguments: Self.subtractionArguments
    )
    internal func subtractionIsNotCommutative(
        minuend: Roman,
        subtrahend: Roman,
        difference: Roman
    ) {
        let reversedDifferenceReport: Roman.OverflowReport = subtrahend.subtractingReportingOverflow(minuend)

        #expect(minuend - subtrahend == difference)
        #expect(reversedDifferenceReport.partialValue != difference)
        #expect(reversedDifferenceReport.overflow == true)
    }
}

// MARK: - Positive Zero

extension RomanSubtractableTests {
    @Test(
        "Subtracting positive zero preserves minuend",
        arguments: [
            3,
            5
        ] as Array<Roman>
    )
    internal func subtractingPositiveZeroPreservesMinuend(minuend: Roman) {
        #expect(minuend - Roman.zero == minuend)
    }

    @Test(
        "Subtracting self returns positive zero",
        arguments: [
            3,
            5
        ] as Array<Roman>
    )
    internal func subtractingSelfReturnsPositiveZero(value: Roman) {
        #expect(value - value == Roman.zero)
    }
}
