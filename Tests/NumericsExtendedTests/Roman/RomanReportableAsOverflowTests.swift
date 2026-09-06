// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman ReportableAsOverflow Tests")
internal struct RomanReportableAsOverflowTests {
    @Test(
        "Adding reporting overflow",
        arguments: [
            (2, 3, 5, false),
            (3, 4, 7, false),
            (Roman.max - 1, 1, Roman.max, false),
            (Roman.max, 1, Roman.min, true),
            (Roman.max, 2, Roman.min + 1, true)
        ] as Array<(Roman, Roman, Roman, Bool)>
    )
    internal func addingReportingOverflow(
        augend: Roman,
        addend: Roman,
        partialValue: Roman,
        overflow: Bool
    ) {
        let report: Roman.OverflowReport = augend.addingReportingOverflow(addend)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Subtracting reporting overflow",
        arguments: [
            (3, 2, 1, false),
            (5, 3, 2, false),
            (Roman.min + 1, 1, Roman.min, false),
            (Roman.min, 1, Roman.max, true),
            (Roman.min, 2, Roman.max - 1, true)
        ] as Array<(Roman, Roman, Roman, Bool)>
    )
    internal func subtractingReportingOverflow(
        minuend: Roman,
        subtrahend: Roman,
        partialValue: Roman,
        overflow: Bool
    ) {
        let report: Roman.OverflowReport = minuend.subtractingReportingOverflow(subtrahend)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Multiplied reporting overflow",
        arguments: [
            (2, 3, 6, false),
            (3, 4, 12, false),
            (Roman.max, 1, Roman.max, false),
            (Roman.max, 2, Roman.max - 1, true),
            (2_000, 2, 0, true),
            (1_000, 4, 0, true),
            (Roman.max, Roman.max, 1, true)
        ] as Array<(Roman, Roman, Roman, Bool)>
    )
    internal func multipliedReportingOverflow(
        multiplicand: Roman,
        multiplier: Roman,
        partialValue: Roman,
        overflow: Bool
    ) {
        let report: Roman.OverflowReport = multiplicand.multipliedReportingOverflow(by: multiplier)

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
            (Roman.max, 1, Roman.max, false),
            (Roman.min, 1, Roman.min, false),
            (Roman.max, 0, Roman.max, true)
        ] as Array<(Roman, Roman, Roman, Bool)>
    )
    internal func dividedReportingOverflow(
        dividend: Roman,
        divisor: Roman,
        partialValue: Roman,
        overflow: Bool
    ) {
        let report: Roman.OverflowReport = dividend.dividedReportingOverflow(by: divisor)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Remainder reporting overflow",
        arguments: [
            (6, 2, 0, false),
            (7, 2, 1, false),
            (0, 1, 0, false),
            (Roman.max, 1, Roman.min, false),
            (Roman.min, 1, Roman.min, false),
            (Roman.max, Roman.max, Roman.min, false),
            (Roman.max, 0, Roman.max, true)
        ] as Array<(Roman, Roman, Roman, Bool)>
    )
    internal func remainderReportingOverflow(
        dividend: Roman,
        divisor: Roman,
        partialValue: Roman,
        overflow: Bool
    ) {
        let report: Roman.OverflowReport = dividend.remainderReportingOverflow(dividingBy: divisor)

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
            (Roman.max, 1, Roman.max, false),
            (Roman.max, 2, 1, true),
            (Roman.max, 3, 1, true),
            (16, 3, 96, true)
        ] as Array<(Roman, Roman.Exponent, Roman, Bool)>
    )
    internal func raisedReportingOverflow(
        base: Roman,
        exponent: Roman.Exponent,
        partialValue: Roman,
        overflow: Bool
    ) {
        let report: Roman.OverflowReport = base.raisedReportingOverflow(to: exponent)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }
}
