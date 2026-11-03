// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols

extension SignedInteger
where Self: Divisible, Self.Reciprocal == Self {
    /// Returns the reciprocal of this instance.
    public var reciprocal: Self.Reciprocal? {
        guard self.isInvertible == true else {
            return nil
        }

        return self
    }
}

extension SignedInteger
where Self: Divisible {
    /// A boolean value indicating whether this instance is invertible.
    public var isInvertible: Bool {
        return self == 1
            || self == -1
    }
}
