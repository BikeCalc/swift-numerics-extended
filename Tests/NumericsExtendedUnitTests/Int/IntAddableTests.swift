// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Addable Tests")
internal struct IntAddableTests {
    internal init() {}

    private static let additionArguments: [(Int, Int.Addend, Int)] = [
        (2, 3, 5),
        (3, 4, 7),
        (-2, 3, 1),
        (-3, -4, -7)
    ]

    @Test(
        "Addition succeeds",
        arguments: Self.additionArguments
    )
    internal func additionSucceeds(
        augend: Int,
        addend: Int.Addend,
        sum: Int
    ) {
        let result: Int = augend + addend
        #expect(result == sum)
    }

    @Test(
        "Addition equal succeeds",
        arguments: Self.additionArguments
    )
    internal func additionEqualSucceeds(
        augend: Int,
        addend: Int.Addend,
        sum: Int
    ) {
        var result: Int = augend
        result += addend
        #expect(result == sum)
    }

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: Int,
        addend: Int.Addend,
        sum: Int
    ) throws {
        let result: Int = try augend.adding(addend)
        #expect(result == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: Int,
        addend: Int.Addend,
        sum: Int
    ) throws {
        var result: Int = augend
        try result.add(addend)
        #expect(result == sum)
    }
}

extension IntAddableTests {
    @Test(
        "Addition is commutative",
        arguments: Self.additionArguments
    )
    internal func additionIsCommutative(
        augend: Int,
        addend: Int.Addend,
        sum _: Int
    ) {
        let result: Int = augend + addend
        #expect(result == addend + augend)
    }
}

// MARK: - Negative Zero

extension IntAddableTests {
    @Test(
        "Adding negative zero preserves augend",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func addingNegativeZeroPreservesAugend(augend: Int) {
        let result: Int = augend + Int.negativeZero
        #expect(result == augend)
    }
}

// MARK: - Positive Zero

extension IntAddableTests {
    @Test(
        "Adding opposite values returns positive zero",
        arguments: [
            (2, -2),
            (3, -3),
            (-2, 2),
            (-3, 3)
        ] as Array<(Int, Int.Addend)>
    )
    internal func addingOppositeValuesReturnsPositiveZero(
        augend: Int,
        addend: Int.Addend
    ) {
        let result: Int = augend + addend
        #expect(result == Int.zero)
    }

    @Test(
        "Adding positive zero preserves augend",
        arguments: [
            2,
            3,
            -2,
            -3
        ] as Array<Int>
    )
    internal func addingPositiveZeroPreservesAugend(augend: Int) {
        let result: Int = augend + Int.zero
        #expect(result == augend)
    }
}
