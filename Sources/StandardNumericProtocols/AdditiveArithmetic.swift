// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols

extension AdditiveArithmetic
where Self: Addable, Self.Sum == Self {
    public static func += (
        _ lhs: inout Self,
        _ rhs: Self.Addend
    ) {
        let sum: Self.Sum = lhs + rhs
        lhs = sum
    }
}

extension AdditiveArithmetic
where Self: Subtractable, Self.Difference == Self {
    public static func -= (
        _ lhs: inout Self,
        _ rhs: Self.Subtrahend
    ) {
        let difference: Self.Difference = lhs - rhs
        lhs = difference
    }
}
