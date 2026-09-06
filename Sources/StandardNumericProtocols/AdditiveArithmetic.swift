// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols

extension AdditiveArithmetic
where Self: Addable {
    public static func += (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        let sum: Self = lhs + rhs
        lhs = sum
    }
}

extension AdditiveArithmetic
where Self: Subtractable {
    public static func -= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        let difference: Self = lhs - rhs
        lhs = difference
    }
}
