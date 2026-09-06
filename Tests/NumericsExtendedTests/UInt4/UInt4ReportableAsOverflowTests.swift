// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 ReportableAsOverflow Tests")
internal struct UInt4ReportableAsOverflowTests {
    @Test(
        "Adding reporting overflow",
        arguments: [
            (2, 3, 5, false),
            (3, 4, 7, false),
            (UInt4.max - 1, 1, UInt4.max, false),
            (UInt4.max, 1, UInt4.min, true),
            (UInt4.max, 2, UInt4.min + 1, true)
        ] as Array<(UInt4, UInt4, UInt4, Bool)>
    )
    internal func addingReportingOverflow(
        augend: UInt4,
        addend: UInt4,
        partialValue: UInt4,
        overflow: Bool
    ) {
        let report: UInt4.OverflowReport = augend.addingReportingOverflow(addend)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Subtracting reporting overflow",
        arguments: [
            (3, 2, 1, false),
            (5, 3, 2, false),
            (UInt4.min + 1, 1, UInt4.min, false),
            (UInt4.min, 1, UInt4.max, true),
            (UInt4.min, 2, UInt4.max - 1, true)
        ] as Array<(UInt4, UInt4, UInt4, Bool)>
    )
    internal func subtractingReportingOverflow(
        minuend: UInt4,
        subtrahend: UInt4,
        partialValue: UInt4,
        overflow: Bool
    ) {
        let report: UInt4.OverflowReport = minuend.subtractingReportingOverflow(subtrahend)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Multiplied reporting overflow",
        arguments: [
            (2, 3, 6, false),
            (3, 4, 12, false),
            (UInt4.max, 1, UInt4.max, false),
            (UInt4.max, 2, UInt4.max - 1, true),
            (8, 2, 0, true),
            (4, 4, 0, true),
            (UInt4.max, UInt4.max, 1, true)
        ] as Array<(UInt4, UInt4, UInt4, Bool)>
    )
    internal func multipliedReportingOverflow(
        multiplicand: UInt4,
        multiplier: UInt4,
        partialValue: UInt4,
        overflow: Bool
    ) {
        let report: UInt4.OverflowReport = multiplicand.multipliedReportingOverflow(by: multiplier)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Divided reporting overflow",
        arguments: [
            (6, 2, 3, false),
            (6, 3, 2, false),
            (7, 2, 3, false),
            (0, 1, 0, false),
            (UInt4.max, 1, UInt4.max, false),
            (UInt4.min, 1, UInt4.min, false),
            (UInt4.max, 0, UInt4.max, true)
        ] as Array<(UInt4, UInt4, UInt4, Bool)>
    )
    internal func dividedReportingOverflow(
        dividend: UInt4,
        divisor: UInt4,
        partialValue: UInt4,
        overflow: Bool
    ) {
        let report: UInt4.OverflowReport = dividend.dividedReportingOverflow(by: divisor)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Remainder reporting overflow",
        arguments: [
            (6, 2, 0, false),
            (7, 2, 1, false),
            (0, 1, 0, false),
            (UInt4.max, 1, UInt4.min, false),
            (UInt4.min, 1, UInt4.min, false),
            (UInt4.max, UInt4.max, UInt4.min, false),
            (UInt4.max, 0, UInt4.max, true)
        ] as Array<(UInt4, UInt4, UInt4, Bool)>
    )
    internal func remainderReportingOverflow(
        dividend: UInt4,
        divisor: UInt4,
        partialValue: UInt4,
        overflow: Bool
    ) {
        let report: UInt4.OverflowReport = dividend.remainderReportingOverflow(dividingBy: divisor)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Raised reporting overflow",
        arguments: [
            (2, 3, 8, false),
            (3, 2, 9, false),
            (0, 0, 1, false),
            (0, 1, 0, false),
            (1, 0, 1, false),
            (1, 1, 1, false),
            (UInt4.max, 1, UInt4.max, false),
            (UInt4.max, 2, 1, true),
            (UInt4.max, 3, 1, true),
            (4, 2, 0, true)
        ] as Array<(UInt4, UInt4.Exponent, UInt4, Bool)>
    )
    internal func raisedReportingOverflow(
        base: UInt4,
        exponent: UInt4.Exponent,
        partialValue: UInt4,
        overflow: Bool
    ) {
        let report: UInt4.OverflowReport = base.raisedReportingOverflow(to: exponent)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }
}
