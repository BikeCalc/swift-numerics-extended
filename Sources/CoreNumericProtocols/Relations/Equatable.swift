// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

extension Equatable {
    /// Returns a boolean value indicating whether this value is equal to the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether the two values are equal.
    public func isEqual(to rhs: Self) -> Bool {
        return self == rhs
    }

    /// Returns a boolean value indicating whether this value is unequal to the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether the two values are unequal.
    public func isUnequal(to rhs: Self) -> Bool {
        return self != rhs
    }
}
