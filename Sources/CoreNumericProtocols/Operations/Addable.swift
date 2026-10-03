// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that supports addition.
public protocol Addable: Equatable {
    /// The type used to represent addends.
    associatedtype Addend

    /// Returns the sum of adding the two specified values.
    ///
    /// - Parameters:
    ///   - lhs: The augend.
    ///   - rhs: The addend.
    /// - Returns: The sum.
    static func + (
        _ lhs: Self,
        _ rhs: Self.Addend
    ) -> Self

    /// Returns the sum of this value and the specified value.
    ///
    /// - Parameter addend: The addend.
    /// - Returns: The sum.
    /// - Throws: An error if the conforming type cannot perform the addition.
    func adding(_ addend: Self.Addend) throws -> Self
}

extension Addable {
    /// Adds the two specified values and stores the sum in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The augend.
    ///   - rhs: The addend.
    public static func += (
        _ lhs: inout Self,
        _ rhs: Self.Addend
    ) {
        let sum: Self = lhs + rhs
        lhs = sum
    }

    /// Returns the sum of this value and the specified value.
    ///
    /// - Parameter addend: The addend.
    /// - Returns: The sum.
    /// - Throws: An error if the conforming type cannot perform the addition.
    public func adding(_ addend: Self.Addend) throws -> Self {
        return self + addend
    }

    /// Adds the specified value to this value.
    ///
    /// - Parameter addend: The addend.
    /// - Throws: An error if the conforming type cannot perform the addition.
    public mutating func add(_ addend: Self.Addend) throws  {
        self = try self.adding(addend)
    }
}
