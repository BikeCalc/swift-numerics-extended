// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols

/// A bounded integer value expressed through a symbolic textual notation.
///
/// A symbolic integer represents exact, discrete values without promising a binary representation or bit-level
/// operations. Conforming types provide a lossless textual notation, define their lower and upper bounds, support
/// arithmetic with overflow reporting, and advance across their representable values by a stride.
///
/// The storage used by a conforming type is an implementation detail. A symbolic integer may use a binary integer
/// internally while presenting a nonpositional notation publicly.
public protocol SymbolicInteger:
    Comparable,
    LosslessStringConvertible,
    Numeric,
    ReportableAsOverflow,
    RepresentableByMax,
    RepresentableByMin,
    RepresentableByZero,
    Strideable {}
