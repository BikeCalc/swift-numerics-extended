// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Invertible Tests")
internal struct UInt4InvertibleTests {
    internal init() {}

    @Test(
        "Reciprocal",
        arguments: [
            (1, 1),
            (2, nil)
        ] as Array<(UInt4, UInt4.Reciprocal?)>
    )
    internal func reciprocal(
        dividend: UInt4,
        expected: UInt4.Reciprocal?
    ) {
        #expect(dividend.reciprocal == expected)
    }

    @Test(
        "Is invertible",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(UInt4, Bool)>
    )
    internal func isInvertible(
        dividend: UInt4,
        expected: Bool
    ) {
        let result: Bool = dividend.isInvertible
        #expect(result == expected)
    }
}

// MARK: - Positive One

extension UInt4InvertibleTests {
    @Test(
        "Positive one invertibility follows unsigned integer rules",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(UInt4, Bool)>
    )
    internal func positiveOneInvertibilityFollowsUnsignedIntegerRules(
        dividend: UInt4,
        expected: Bool
    ) {
        #expect(dividend.isInvertible == expected)
    }
}

// MARK: - Positive Zero

extension UInt4InvertibleTests {
    @Test("Positive zero is not invertible")
    internal func positiveZeroIsNotInvertible() {
        #expect(UInt4.zero.isInvertible == false)
    }
}
