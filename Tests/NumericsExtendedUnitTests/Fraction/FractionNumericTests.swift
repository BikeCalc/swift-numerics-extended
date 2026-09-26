// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Numeric Tests")
internal struct FractionNumericTests {
    @Test(
        "Initialized exactly succeeds",
        arguments: [
            (0, Fraction<Int>(0, 1)),
            (2, Fraction<Int>(2, 1)),
            (3, Fraction<Int>(3, 1)),
            (-2, Fraction<Int>(-2, 1)),
            (-3, Fraction<Int>(-3, 1))
        ] as Array<(Int, Fraction<Int>)>
    )
    internal func initializedExactlySucceeds(
        source: Int,
        value: Fraction<Int>
    ) {
        #expect(Fraction<Int>(exactly: source) == value)
    }

    @Test(
        "Magnitude succeeds",
        arguments: [
            (Fraction<Int>(0, 1), Fraction<Int>.Magnitude(0, 1)),
            (Fraction<Int>(2, 1), Fraction<Int>.Magnitude(2, 1)),
            (Fraction<Int>(3, 1), Fraction<Int>.Magnitude(3, 1)),
            (Fraction<Int>(-2, 1), Fraction<Int>.Magnitude(2, 1)),
            (Fraction<Int>(-3, 1), Fraction<Int>.Magnitude(3, 1)),
            (Fraction<Int>(1, -2), Fraction<Int>.Magnitude(1, 2)),
            (Fraction<Int>(-1, -2), Fraction<Int>.Magnitude(1, 2))
        ] as Array<(Fraction<Int>, Fraction<Int>.Magnitude)>
    )
    internal func magnitudeSucceeds(
        value: Fraction<Int>,
        magnitude: Fraction<Int>.Magnitude
    ) {
        #expect(value.magnitude == magnitude)
    }
}

// MARK: - IntMin

extension FractionNumericTests {
    @Test("Int minimum magnitude uses the unsigned term type")
    internal func intMinimumMagnitudeUsesUnsignedTerm() {
        let value: Fraction<Int> = .init(Int.min, 1)
        let magnitude: Fraction<UInt> = value.magnitude

        let expected: Fraction<UInt> = .init(UInt(Int.max) + 1, 1)

        #expect(magnitude == expected)
    }
}
