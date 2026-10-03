// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericOperators
import CoreNumericProtocols

extension Numeric
where Self: Divisible, Self.Divisor: ExpressibleByIntegerLiteral {
    /// Returns this value halved.
    ///
    /// - Returns: The value halved.
    public func halved() -> Self {
        return self / 2
    }

    /// Halves this value.
    public mutating func halve() {
        self = self.halved()
    }
}

extension Numeric
where Self: Multipliable {
    /// Returns this value doubled.
    ///
    ///  - Returns: The value doubled.
    public func doubled() -> Self {
        return self * 2
    }

    /// Doubles this value.
    public mutating func double() {
        self = self.doubled()
    }
}

extension Numeric
where Self: Raisable {
    /// Returns the result of raising this value to its square.
    ///
    /// - Returns: The square.
    public func squared() -> Self
    where Self.Exponent: ExpressibleByIntegerLiteral {
        return self ** 2
    }

    /// Raises this value to its square.
    public mutating func square()
    where Self.Exponent: ExpressibleByIntegerLiteral {
        self **= 2
    }

    /// Returns the result of raising this value to its cube.
    ///
    /// - Returns: The cube.
    public func cubed() -> Self
    where Self.Exponent: ExpressibleByIntegerLiteral {
        return self ** 3
    }

    /// Raises this value to its cube.
    public mutating func cube()
    where Self.Exponent: ExpressibleByIntegerLiteral {
        self **= 3
    }
}
