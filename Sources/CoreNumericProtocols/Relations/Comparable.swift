// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

extension Comparable {
    /// Returns a boolean value indicating whether this value is less than the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether this value is less than the specified value.
    /// - Throws: An error if the conforming type cannot perform the comparison.
    public func isLess(than rhs: Self) throws -> Bool {
        return self < rhs
    }

    /// Returns a boolean value indicating whether this value is less than or equal to the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether this value is less than or equal to the specified value.
    /// - Throws: An error if the conforming type cannot perform the comparison.
    public func isLessThanOrEqual(to rhs: Self) throws -> Bool {
        return self <= rhs
    }

    /// Returns a boolean value indicating whether this value is greater than the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether this value is greater than the specified value.
    /// - Throws: An error if the conforming type cannot perform the comparison.
    public func isGreater(than rhs: Self) throws -> Bool {
        return self > rhs
    }

    /// Returns a boolean value indicating whether this value is greater than or equal to the specified value.
    ///
    /// - Parameter rhs: Another value to compare.
    /// - Returns: A boolean indicating whether this value is greater than or equal to the specified value.
    /// - Throws: An error if the conforming type cannot perform the comparison.
    public func isGreaterThanOrEqual(to rhs: Self) throws -> Bool {
        return self >= rhs
    }

    /// Returns a boolean value indicating whether this value is within a specified closed range.
    ///
    /// - Parameter closedRange: An interval from a lower bound up to, and including, an upper bound.
    /// - Returns: A boolean value.
    /// - Throws: An error if the conforming type cannot perform the comparison.
    public func isWithin(_ closedRange: ClosedRange<Self>) throws -> Bool {
        return try self.isGreaterThanOrEqual(to: closedRange.lowerBound)
            && self.isLessThanOrEqual(to: closedRange.upperBound)
    }

    /// Returns a boolean value indicating whether this value is within two specified values.
    ///
    /// - Parameters:
    ///   - lowerBound: The lower bound value.
    ///   - upperBound: The upper bound value.
    /// - Returns: A boolean value.
    /// - Throws: An error if the conforming type cannot perform the comparison.
    /// - Precondition: `lowerBound` must be less than `upperBound`.
    public func isWithin(
        _ lowerBound: Self,
        _ upperBound: Self
    ) throws -> Bool {
        let boundsAreOrdered: Bool = try lowerBound.isLess(than: upperBound)
        precondition(
            boundsAreOrdered,
            "Lower bound must be less than upper bound."
        )

        return try self.isGreaterThanOrEqual(to: lowerBound)
            && self.isLessThanOrEqual(to: upperBound)
    }

    /// Returns a boolean value indicating whether this value is between two specified values.
    ///
    /// - Parameters:
    ///   - lowerBound: The lower bound value.
    ///   - upperBound: The upper bound value.
    /// - Returns: A boolean value.
    /// - Throws: An error if the conforming type cannot perform the comparison.
    /// - Precondition: `lowerBound` must be less than `upperBound`.
    public func isBetween(
        _ lowerBound: Self,
        _ upperBound: Self
    ) throws -> Bool {
        let boundsAreOrdered: Bool = try lowerBound.isLess(than: upperBound)
        precondition(
            boundsAreOrdered,
            "Lower bound must be less than upper bound."
        )

        return try lowerBound.isLess(than: self)
            && self.isLess(than: upperBound)
    }
}
