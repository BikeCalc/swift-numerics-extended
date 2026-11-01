// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Raisable Tests")
internal struct CanonicalizedFractionRaisableTests {
    internal init() {}

    private static let exponentiationArguments: [(Fraction<Int>, Fraction<Int>.Exponent, Fraction<Int>)] = [
        (.init(2, 3), 2, .init(4, 9)),
        (.init(2, 3), 3, .init(8, 27)),
        (.init(2, 3), -2, .init(9, 4)),
        (.init(2, 3), -3, .init(27, 8)),
        (.init(-2, 3), 2, .init(4, 9)),
        (.init(-2, 3), 3, .init(-8, 27)),
        (.init(-2, 3), -2, .init(9, 4)),
        (.init(-2, 3), -3, .init(-27, 8)),
        (.init(1, 1), -2, .init(1, 1)),
        (.init(1, 1), -3, .init(1, 1)),
        (.init(-1, 1), -2, .init(1, 1)),
        (.init(-1, 1), -3, .init(-1, 1))
    ]

    private static let squaringArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(2, 3), .init(4, 9)),
        (.init(3, 4), .init(9, 16)),
        (.init(-2, 3), .init(4, 9)),
        (.init(-3, 4), .init(9, 16))
    ]

    private static let cubingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(2, 3), .init(8, 27)),
        (.init(3, 4), .init(27, 64)),
        (.init(-2, 3), .init(-8, 27)),
        (.init(-3, 4), .init(-27, 64))
    ]

    @Test(
        "Exponentiation succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationSucceeds(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        @Canonicalized var result: Fraction<Int> = base
        result **= exponent
        #expect(result == power)
    }

    @Test(
        "Raise succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raiseSucceeds(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) throws {
        @Canonicalized var result: Fraction<Int> = base
        try result.raise(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Square canonicalizes result",
        arguments: Self.squaringArguments
    )
    internal func squareCanonicalizesResult(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        @Canonicalized var value: Fraction<Int> = base
        value.square()
        #expect(value == power)
    }

    @Test(
        "Cube canonicalizes result",
        arguments: Self.cubingArguments
    )
    internal func cubeCanonicalizesResult(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        @Canonicalized var value: Fraction<Int> = base
        value.cube()
        #expect(value == power)
    }
}
