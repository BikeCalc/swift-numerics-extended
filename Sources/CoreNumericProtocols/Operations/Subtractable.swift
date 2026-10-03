// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that supports subtraction.
public protocol Subtractable: Equatable {
    /// The type used to represent subtrahends.
    associatedtype Subtrahend

    /// Returns the difference of subtracting the second specified value from the first.
    ///
    /// - Parameters:
    ///   - lhs: The minuend.
    ///   - rhs: The subtrahend.
    /// - Returns: The difference.
    static func - (
        _ lhs: Self,
        _ rhs: Self.Subtrahend
    ) -> Self

    /// Returns the difference of this value and the specified value.
    ///
    /// - Parameter subtrahend: The subtrahend.
    /// - Returns: The difference.
    /// - Throws: An error if the conforming type cannot perform the subtraction.
    func subtracting(_ subtrahend: Self.Subtrahend) throws -> Self
}

extension Subtractable {
    /// Subtracts the second specified value from the first and stores the difference in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The minuend.
    ///   - rhs: The subtrahend.
    public static func -= (
        _ lhs: inout Self,
        _ rhs: Self.Subtrahend
    ) {
        let difference: Self = lhs - rhs
        lhs = difference
    }

    /// Returns the difference of this value and the specified value.
    ///
    /// - Parameter subtrahend: The subtrahend.
    /// - Returns: The difference.
    /// - Throws: An error if the conforming type cannot perform the subtraction.
    public func subtracting(_ subtrahend: Self.Subtrahend) throws -> Self {
        return self - subtrahend
    }

    /// Subtracts the specified value from this value.
    ///
    /// - Parameter subtrahend: The subtrahend.
    /// - Throws: Any error thrown by `subtracting(_:)`.
    /// - Throws: An error if the conforming type cannot perform the subtraction.
    public mutating func subtract(_ subtrahend: Self.Subtrahend) throws {
        self = try self.subtracting(subtrahend)
    }
}
