// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Comparable Tests")
internal struct RomanComparableTests {
    internal init() {}

    private static let comparisonArguments: Array<(Roman, Roman, Bool, Bool, Bool, Bool)> = [
        (1, 1, false, true, false, true),
        (2, 3, true, true, false, false),
        (3, 2, false, false, true, true)
    ]

    private static let rangeArguments: Array<(Roman, Roman, Roman)> = [
        (1, 2, 4),
        (2, 2, 4),
        (3, 2, 4),
        (4, 2, 4),
        (5, 2, 4)
    ]

    @Test(
        "Is less than",
        arguments: Self.comparisonArguments
    )
    internal func isLessThan(
        lhs: Roman,
        rhs: Roman,
        isLessExpected: Bool,
        isLessThanOrEqualExpected _: Bool,
        isGreaterExpected _: Bool,
        isGreaterThanOrEqualExpected _: Bool
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let isLessResult: Bool = try lhs.isLess(than: rhs)
        #expect(isLessResult == isLessExpected)
    }

    @Test(
        "Is less than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isLessThanOrEqualTo(
        lhs: Roman,
        rhs: Roman,
        isLessExpected _: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected _: Bool,
        isGreaterThanOrEqualExpected _: Bool
    ) throws {
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let isLessThanOrEqualResult: Bool = try lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
    }

    @Test(
        "Is greater than",
        arguments: Self.comparisonArguments
    )
    internal func isGreaterThan(
        lhs: Roman,
        rhs: Roman,
        isLessExpected _: Bool,
        isLessThanOrEqualExpected _: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected _: Bool
    ) throws {
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let isGreaterResult: Bool = try lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
    }

    @Test(
        "Is greater than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isGreaterThanOrEqualTo(
        lhs: Roman,
        rhs: Roman,
        isLessExpected _: Bool,
        isLessThanOrEqualExpected _: Bool,
        isGreaterExpected _: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) throws {
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isGreaterThanOrEqualResult: Bool = try lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }

    @Test(
        "Is within closed range",
        arguments: Self.rangeArguments
    )
    internal func isWithinClosedRange(
        value: Roman,
        lowerBound: Roman,
        upperBound: Roman
    ) throws {
        let range: ClosedRange<Roman> = lowerBound ... upperBound
        let result: Bool = try value.isWithin(range)
        #expect(result == range.contains(value))
    }

    @Test(
        "Is within bounds",
        arguments: Self.rangeArguments
    )
    internal func isWithinBounds(
        value: Roman,
        lowerBound: Roman,
        upperBound: Roman
    ) throws {
        let result: Bool = try value.isWithin(lowerBound, upperBound) == true
        #expect(result == (value >= lowerBound && value <= upperBound))
    }

    @Test(
        "Is between bounds",
        arguments: Self.rangeArguments
    )
    internal func isBetweenBounds(
        value: Roman,
        lowerBound: Roman,
        upperBound: Roman
    ) throws {
        let result: Bool = try value.isBetween(lowerBound, upperBound) == true
        #expect(result == (value > lowerBound && value < upperBound))
    }
}
