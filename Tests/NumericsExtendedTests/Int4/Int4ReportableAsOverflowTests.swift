// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 ReportableAsOverflow Tests")
internal struct Int4ReportableAsOverflowTests {
    @Test(
        "Adding reporting overflow",
        arguments: [
            (2, 3, 5, false),
            (3, 4, 7, false),
            (-2, 3, 1, false),
            (-3, -4, -7, false),
            (Int4.max - 1, 1, Int4.max, false),
            (Int4.max, 1, Int4.min, true),
            (Int4.max, 2, Int4.min + 1, true),
            (Int4.min, -1, Int4.max, true),
            (Int4.min, -2, Int4.max - 1, true)
        ] as Array<(Int4, Int4, Int4, Bool)>
    )
    internal func addingReportingOverflow(
        augend: Int4,
        addend: Int4,
        partialValue: Int4,
        overflow: Bool
    ) {
        let report: Int4.OverflowReport = augend.addingReportingOverflow(addend)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Subtracting reporting overflow",
        arguments: [
            (3, 2, 1, false),
            (5, 3, 2, false),
            (-3, 2, -5, false),
            (-5, -3, -2, false),
            (Int4.min + 1, 1, Int4.min, false),
            (Int4.min, 1, Int4.max, true),
            (Int4.min, 2, Int4.max - 1, true),
            (Int4.max, -1, Int4.min, true),
            (Int4.max, -2, Int4.min + 1, true)
        ] as Array<(Int4, Int4, Int4, Bool)>
    )
    internal func subtractingReportingOverflow(
        minuend: Int4,
        subtrahend: Int4,
        partialValue: Int4,
        overflow: Bool
    ) {
        let report: Int4.OverflowReport = minuend.subtractingReportingOverflow(subtrahend)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Multiplied reporting overflow",
        arguments: [
            (2, 3, 6, false),
            (3, 4, -4, true),
            (-2, 3, -6, false),
            (-3, -4, -4, true),
            (Int4.max, 1, Int4.max, false),
            (Int4.min, 1, Int4.min, false),
            (Int4.max, 2, -2, true),
            (Int4.min, 2, 0, true),
            (Int4.min, -1, Int4.min, true)
        ] as Array<(Int4, Int4, Int4, Bool)>
    )
    internal func multipliedReportingOverflow(
        multiplicand: Int4,
        multiplier: Int4,
        partialValue: Int4,
        overflow: Bool
    ) {
        let report: Int4.OverflowReport = multiplicand.multipliedReportingOverflow(by: multiplier)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Divided reporting overflow",
        arguments: [
            (6, 2, 3, false),
            (6, 3, 2, false),
            (-6, 2, -3, false),
            (-6, -3, 2, false),
            (0, 1, 0, false),
            (Int4.max, 1, Int4.max, false),
            (Int4.min, 1, Int4.min, false),
            (Int4.max, 0, Int4.max, true),
            (Int4.min, -1, Int4.min, true)
        ] as Array<(Int4, Int4, Int4, Bool)>
    )
    internal func dividedReportingOverflow(
        dividend: Int4,
        divisor: Int4,
        partialValue: Int4,
        overflow: Bool
    ) {
        let report: Int4.OverflowReport = dividend.dividedReportingOverflow(by: divisor)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Remainder reporting overflow",
        arguments: [
            (6, 2, 0, false),
            (7, 2, 1, false),
            (-6, 2, 0, false),
            (-7, 2, -1, false),
            (0, 1, 0, false),
            (Int4.max, 1, 0, false),
            (Int4.min, 1, 0, false),
            (Int4.max, 0, Int4.max, true),
            (Int4.min, -1, 0, true)
        ] as Array<(Int4, Int4, Int4, Bool)>
    )
    internal func remainderReportingOverflow(
        dividend: Int4,
        divisor: Int4,
        partialValue: Int4,
        overflow: Bool
    ) {
        let report: Int4.OverflowReport = dividend.remainderReportingOverflow(dividingBy: divisor)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }

    @Test(
        "Raised reporting overflow",
        arguments: [
            (2, 3, -8, true),
            (3, 2, -7, true),
            (-2, 3, -8, false),
            (-2, 2, 4, false),
            (0, 0, 1, false),
            (0, 1, 0, false),
            (1, 0, 1, false),
            (1, 1, 1, false),
            (Int4.max, 1, Int4.max, false),
            (Int4.max, 2, 1, true),
            (Int4.max, 3, 1, true),
            (Int4.min, 1, Int4.min, false),
            (Int4.min, 2, 0, true)
        ] as Array<(Int4, Int4.Exponent, Int4, Bool)>
    )
    internal func raisedReportingOverflow(
        base: Int4,
        exponent: Int4.Exponent,
        partialValue: Int4,
        overflow: Bool
    ) {
        let report: Int4.OverflowReport = base.raisedReportingOverflow(to: exponent)

        #expect(report.partialValue == partialValue)
        #expect(report.overflow == overflow)
    }
}
