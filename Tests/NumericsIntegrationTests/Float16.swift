// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Numerics
import NumericsExtended

// Test-only conformance: Apple's existing method satisfies the protocol without a replacement overload.
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(iOS 14, macCatalyst 14, macOS 11, tvOS 14, watchOS 7, *)
extension Float16: ApproximatelyEquatable {
    public typealias AbsoluteTolerance = Self
    public typealias RelativeTolerance = Self
}
#endif
