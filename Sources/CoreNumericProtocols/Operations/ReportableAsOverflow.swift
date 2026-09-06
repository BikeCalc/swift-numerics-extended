// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that can report whether arithmetic operations overflow.
public protocol ReportableAsOverflow: Operatable, Raisable {
    /// Returns the sum after adding the specified value to this instance, along with a boolean value indicating whether
    /// overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to add to this instance.
    /// - Returns: A tuple containing the result of the addition along with a boolean value indicating whether overflow
    ///   occurred.
    func addingReportingOverflow(_ rhs: Self) -> Self.OverflowReport

    /// Returns the difference after subtracting the specified value from this instance, along with a boolean value
    /// indicating whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to subtract from this instance.
    /// - Returns: A tuple containing the result of the subtraction along with a boolean value indicating whether
    ///   overflow occurred.
    func subtractingReportingOverflow(_ rhs: Self) -> Self.OverflowReport

    /// Returns the product after multiplying this instance by the specified value, along with a boolean value
    /// indicating whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to multiply this instance by.
    /// - Returns: A tuple containing the result of the multiplication along with a boolean value indicating whether
    ///   overflow occurred.
    func multipliedReportingOverflow(by rhs: Self) -> Self.OverflowReport

    /// Returns the quotient after dividing this instance by the specified value, along with a boolean value indicating
    /// whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to divide this instance by.
    /// - Returns: A tuple containing the result of the division along with a boolean value indicating whether overflow
    ///   occurred.
    func dividedReportingOverflow(by rhs: Self) -> Self.OverflowReport

    /// Returns the remainder after dividing this instance by the specified value, along with a boolean value indicating
    /// whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to divide this instance by.
    /// - Returns: A tuple containing the result of the division along with a boolean value indicating whether overflow
    ///   occurred.
    func remainderReportingOverflow(dividingBy rhs: Self) -> Self.OverflowReport

    /// Returns the power after raising this instance to the specified value, along with a boolean value indicating
    /// whether overflow occurred in the operation.
    ///
    /// - Parameter rhs: The value to raise this instance to.
    /// - Returns: A tuple containing the result of the exponentiation along with a boolean value indicating whether
    ///   overflow occurred.
    func raisedReportingOverflow(to rhs: Self.Exponent) -> Self.OverflowReport
}

extension ReportableAsOverflow {
    /// The partial value and overflow status produced by an overflow-reporting operation.
    public typealias OverflowReport = (
        partialValue: Self,
        overflow: Bool
    )
}
