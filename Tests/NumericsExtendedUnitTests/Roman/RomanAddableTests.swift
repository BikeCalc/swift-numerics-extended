// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Addable Tests")
internal struct RomanAddableTests {
    internal init() {}

    private static let additionArguments: [(Roman, Roman.Addend, Roman)] = [
        (2, 3, 5),
        (3, 4, 7)
    ]

    @Test(
        "Addition succeeds",
        arguments: Self.additionArguments
    )
    internal func additionSucceeds(
        augend: Roman,
        addend: Roman.Addend,
        sum: Roman
    ) {
        let result: Roman = augend + addend
        #expect(result == sum)
    }

    @Test(
        "Addition equal succeeds",
        arguments: Self.additionArguments
    )
    internal func additionEqualSucceeds(
        augend: Roman,
        addend: Roman.Addend,
        sum: Roman
    ) {
        var result: Roman = augend
        result += addend
        #expect(result == sum)
    }

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: Roman,
        addend: Roman.Addend,
        sum: Roman
    ) throws {
        let result: Roman = try augend.adding(addend)
        #expect(result == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: Roman,
        addend: Roman.Addend,
        sum: Roman
    ) throws {
        var result: Roman = augend
        try result.add(addend)
        #expect(result == sum)
    }
}

extension RomanAddableTests {
    @Test(
        "Addition is commutative",
        arguments: Self.additionArguments
    )
    internal func additionIsCommutative(
        augend: Roman,
        addend: Roman.Addend,
        sum _: Roman
    ) {
        let result: Roman = augend + addend
        #expect(result == addend + augend)
    }
}

// MARK: - Positive Zero

extension RomanAddableTests {
    @Test(
        "Adding positive zero preserves augend",
        arguments: [
            2,
            3
        ] as Array<Roman>
    )
    internal func addingPositiveZeroPreservesAugend(augend: Roman) {
        let result: Roman = augend + Roman.zero
        #expect(result == augend)
    }
}
