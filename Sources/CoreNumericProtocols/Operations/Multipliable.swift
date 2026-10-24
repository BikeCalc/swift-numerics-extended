// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that supports multiplication.
public protocol Multipliable: Equatable {
    /// The type used to represent multipliers.
    associatedtype Multiplier

    /// The type used to represent the result of multiplication.
    associatedtype Product

    /// Returns a boolean value indicating whether this value is a multiple of the specified value.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is a multiple of the specified value, and `false` otherwise.
    func isMultiple(of other: Self) -> Bool

    /// Returns the product of multiplying the two specified values.
    ///
    /// - Parameters:
    ///   - lhs: The multiplicand.
    ///   - rhs: The multiplier.
    /// - Returns: The product.
    static func * (
        _ lhs: Self,
        _ rhs: Self.Multiplier
    ) -> Self.Product

    /// Returns the product of multiplying this value by the specified value.
    ///
    /// - Parameter multiplier: The multiplier.
    /// - Returns: The product.
    /// - Throws: An error if the conforming type cannot perform the multiplication.
    func multiplying(by multiplier: Self.Multiplier) throws -> Self.Product
}

extension Multipliable {
    /// Returns the product of multiplying this value by the specified value.
    ///
    /// - Parameter multiplier: The multiplier.
    /// - Returns: The product.
    /// - Throws: An error if the conforming type cannot perform the multiplication.
    public func multiplying(by multiplier: Self.Multiplier) throws -> Self.Product {
        return self * multiplier
    }
}

extension Multipliable
where Self.Product == Self {
    /// Multiplies the two specified values and stores the product in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The multiplicand.
    ///   - rhs: The multiplier.
    public static func *= (
        _ lhs: inout Self,
        _ rhs: Self.Multiplier
    ) {
        let product: Self.Product = lhs * rhs
        lhs = product
    }

    /// Multiplies this value by the specified value.
    ///
    /// - Parameter multiplier: The multiplier.
    /// - Throws: An error if the conforming type cannot perform the multiplication.
    public mutating func multiply(by multiplier: Self.Multiplier) throws {
        self = try self.multiplying(by: multiplier)
    }
}
