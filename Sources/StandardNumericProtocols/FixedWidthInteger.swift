// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericOperators
import CoreNumericProtocols

extension FixedWidthInteger {
    /// The high and low components of a full-width product.
    ///
    /// The `high` component contains the upper half of the product, while `low` contains its lower half.
    public typealias FullWidthProduct = (
        high: Self,
        low: Self.Magnitude
    )

    /// The high and low components of a full-width dividend.
    ///
    /// The `high` component contains the upper half of the dividend, while `low` contains its lower half.
    public typealias FullWidthDividend = (
        high: Self,
        low: Self.Magnitude
    )

    /// The quotient and remainder produced by an integer division operation.
    ///
    /// The `quotient` component contains the result of the division, while `remainder` contains the value left over.
    public typealias QuotientAndRemainder = (
        quotient: Self,
        remainder: Self
    )
}

extension FixedWidthInteger
where Self: ReportableAsOverflow {
    public func raisedReportingOverflow(to rhs: Self.Exponent) -> Self.OverflowReport
    where Self.Exponent: BinaryInteger, Self.Power == Self {
        switch rhs {
        case ..<0 where self == 0:
            return (
                partialValue: 0,
                overflow: true
            )
        case ..<0:
            return (
                partialValue: self ** rhs,
                overflow: false
            )
        case 0:
            return (
                partialValue: 1,
                overflow: false
            )
        case 1:
            return (
                partialValue: self,
                overflow: false
            )
        default:
            var result: Self = self
            var exponent: Self.Exponent = 1

            while exponent < rhs {
                let report: Self.OverflowReport = result.multipliedReportingOverflow(by: self)

                guard report.overflow == false else {
                    return report
                }

                result = report.partialValue
                exponent += 1
            }

            return (
                partialValue: result,
                overflow: false
            )
        }
    }
}
