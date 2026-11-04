// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 Invertible Tests")
internal struct Int4InvertibleTests {
    internal init() {}

    @Test(
        "Reciprocal",
        arguments: [
            (1, 1),
            (-1, -1),
            (2, nil),
            (-2, nil)
        ] as Array<(Int4, Int4.Reciprocal?)>
    )
    internal func reciprocal(
        dividend: Int4,
        expected: Int4.Reciprocal?
    ) {
        #expect(dividend.reciprocal == expected)
    }

    @Test(
        "Is invertible",
        arguments: [
            (1, true),
            (-1, true),
            (2, false),
            (-2, false)
        ] as Array<(Int4, Bool)>
    )
    internal func isInvertible(
        dividend: Int4,
        expected: Bool
    ) {
        let result: Bool = dividend.isInvertible
        #expect(result == expected)
    }
}

// MARK: - Negative One

extension Int4InvertibleTests {
    @Test(
        "Negative one invertibility follows integer rules",
        arguments: [
            (-1, true),
            (-2, false)
        ] as Array<(Int4, Bool)>
    )
    internal func negativeOneInvertibilityFollowsIntegerRules(
        dividend: Int4,
        expected: Bool
    ) {
        #expect(dividend.isInvertible == expected)
    }
}

// MARK: - Negative Zero

extension Int4InvertibleTests {
    @Test(
        "Negative zero is not invertible",
        arguments: [
            0,
            -0
        ] as Array<Int4>
    )
    internal func negativeZeroIsNotInvertible(dividend: Int4) {
        #expect(dividend.isInvertible == false)
    }
}

// MARK: - Positive One

extension Int4InvertibleTests {
    @Test(
        "Positive one invertibility follows integer rules",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(Int4, Bool)>
    )
    internal func positiveOneInvertibilityFollowsIntegerRules(
        dividend: Int4,
        expected: Bool
    ) {
        #expect(dividend.isInvertible == expected)
    }
}

// MARK: - Positive Zero

extension Int4InvertibleTests {
    @Test(
        "Positive zero is not invertible",
        arguments: [
            0,
            -0
        ] as Array<Int4>
    )
    internal func positiveZeroIsNotInvertible(dividend: Int4) {
        #expect(dividend.isInvertible == false)
    }
}
