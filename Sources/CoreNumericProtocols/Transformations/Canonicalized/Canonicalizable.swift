// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that can be converted to its canonical representation.
///
/// A canonical representation is the single preferred representation among multiple equivalent representations of a
/// value. The specific rules that determine this representation belong to the conforming type.
public protocol Canonicalizable {
    /// A boolean value indicating whether this value can be converted to its canonicalized representation.
    ///
    /// This property is `true` when canonicalization can be performed safely, including when the value is already
    /// canonicalized and the operation leaves it unchanged.
    var isCanonicalizable: Bool { get }

    /// A boolean value indicating whether this value is in its canonicalized representation.
    var isCanonicalized: Bool { get }

    /// Returns the canonicalized representation of this value.
    func canonicalized() -> Self
}

extension Canonicalizable {
    /// Replaces this value with its canonicalized representation.
    public mutating func canonicalize() {
        self = self.canonicalized()
    }
}
