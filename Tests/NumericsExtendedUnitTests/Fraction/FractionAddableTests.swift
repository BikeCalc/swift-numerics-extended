// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Addable Tests")
internal struct FractionAddableTests {
    internal init() {}

    private static let additionArguments: [(Fraction<Int>, Fraction<Int>.Addend, Fraction<Int>)] = [
        (.init(1, 2), .init(1, 2), .init(2, 2)),
        (.init(1, 2), .init(2, 3), .init(7, 6)),
        (.init(-1, 2), .init(1, 2), .init(0, 2)),
        (.init(-1, 2), .init(-2, 3), .init(-7, 6))
    ]

    @Test(
        "Addition succeeds",
        arguments: Self.additionArguments
    )
    internal func additionSucceeds(
        augend: Fraction<Int>,
        addend: Fraction<Int>.Addend,
        sum: Fraction<Int>
    ) {
        let result: Fraction<Int> = augend + addend
        #expect(result == sum)
    }

    @Test(
        "Addition equal succeeds",
        arguments: Self.additionArguments
    )
    internal func additionEqualSucceeds(
        augend: Fraction<Int>,
        addend: Fraction<Int>.Addend,
        sum: Fraction<Int>
    ) {
        var result: Fraction<Int> = augend
        result += addend
        #expect(result == sum)
    }

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: Fraction<Int>,
        addend: Fraction<Int>.Addend,
        sum: Fraction<Int>
    ) throws {
        let result: Fraction<Int> = try augend.adding(addend)
        #expect(result == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: Fraction<Int>,
        addend: Fraction<Int>.Addend,
        sum: Fraction<Int>
    ) throws {
        var result: Fraction<Int> = augend
        try result.add(addend)
        #expect(result == sum)
    }
}

extension FractionAddableTests {
    @Test(
        "Addition is commutative",
        arguments: Self.additionArguments
    )
    internal func additionIsCommutative(
        augend: Fraction<Int>,
        addend: Fraction<Int>.Addend,
        sum _: Fraction<Int>
    ) {
        let result: Fraction<Int> = augend + addend
        #expect(result == addend + augend)
    }
}

// MARK: - NaN

extension FractionAddableTests {
    @Test("Adding positive infinity to negative infinity returns NaN")
    internal func addingPositiveInfinityToNegativeInfinityReturnsNaN() {
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity + .infinity
        #expect(result.isNaN == true)
    }

    @Test("Adding negative infinity to positive infinity returns NaN")
    internal func addingNegativeInfinityToPositiveInfinityReturnsNaN() {
        let result: Fraction<Int> = Fraction<Int>.infinity + .negativeInfinity
        #expect(result.isNaN == true)
    }

    @Test(
        "Adding to NaN returns NaN",
        arguments: [
            .nan,
            .zero,
            .negativeZero,
            .init(1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>.Addend>
    )
    internal func addingToNaNReturnsNaN(addend: Fraction<Int>.Addend) {
        let result: Fraction<Int> = Fraction<Int>.nan + addend
        #expect(result.isNaN == true)
    }

    @Test(
        "Adding NaN returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            .init(1, 1),
            .init(-1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
    )
    internal func addingNaNReturnsNaN(augend: Fraction<Int>) {
        let result: Fraction<Int> = augend + Fraction<Int>.nan
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionAddableTests {
    @Test(
        "Adding to negative infinity follows rational rules",
        arguments: [
            .negativeInfinity,
            .init(1, 1),
            .init(-1, 1)
        ] as Array<Fraction<Int>.Addend>
    )
    internal func addingToNegativeInfinityFollowsRationalRules(addend: Fraction<Int>.Addend) {
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity + addend
        #expect(result == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionAddableTests {
    @Test(
        "Adding to negative zero follows stored representation rules",
        arguments: [
            (.zero, .negativeZero),
            (.negativeZero, .negativeZero),
            (.init(1, 1), .init(-1, -1)),
            (.init(-1, 1), .init(1, -1))
        ] as Array<(Fraction<Int>.Addend, Fraction<Int>)>
    )
    internal func addingToNegativeZeroFollowsStoredRepresentationRules(
        addend: Fraction<Int>.Addend,
        sum: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.negativeZero + addend
        #expect(result == sum)
    }
}

// MARK: - Positive Infinity

extension FractionAddableTests {
    @Test(
        "Adding to positive infinity follows rational rules",
        arguments: [
            .infinity,
            .init(1, 1),
            .init(-1, 1)
        ] as Array<Fraction<Int>.Addend>
    )
    internal func addingToPositiveInfinityFollowsRationalRules(addend: Fraction<Int>.Addend) {
        let result: Fraction<Int> = Fraction<Int>.infinity + addend
        #expect(result == .infinity)
    }
}

// MARK: - Positive Zero

extension FractionAddableTests {
    @Test(
        "Adding opposite values returns positive zero",
        arguments: [
            (.init(1, 2), .init(-1, 2)),
            (.init(2, 3), .init(-2, 3)),
            (.init(-1, 2), .init(1, 2)),
            (.init(-2, 3), .init(2, 3))
        ] as Array<(Fraction<Int>, Fraction<Int>.Addend)>
    )
    internal func addingOppositeValuesReturnsPositiveZero(
        augend: Fraction<Int>,
        addend: Fraction<Int>.Addend
    ) {
        let result: Fraction<Int> = augend + addend
        #expect(result.isZero == true)
        #expect(result.denominator > 0)
    }

    @Test(
        "Adding positive zero preserves augend",
        arguments: [
            .init(1, 2),
            .init(2, 3),
            .init(-1, 2),
            .init(-2, 3)
        ] as Array<Fraction<Int>>
    )
    internal func addingPositiveZeroPreservesAugend(augend: Fraction<Int>) {
        let result: Fraction<Int> = augend + .zero
        #expect(result == augend)
    }

    @Test(
        "Adding to positive zero follows stored representation rules",
        arguments: [
            (.zero, .zero),
            (.negativeZero, .negativeZero),
            (.init(1, 1), .init(1, 1)),
            (.init(-1, 1), .init(-1, 1))
        ] as Array<(Fraction<Int>.Addend, Fraction<Int>)>
    )
    internal func addingToPositiveZeroFollowsStoredRepresentationRules(
        addend: Fraction<Int>.Addend,
        sum: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.zero + addend
        #expect(result == sum)
    }
}
