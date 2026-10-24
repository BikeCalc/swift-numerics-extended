// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import NumericsExtended
import Synchronization
import Testing

@Suite("UInt4 AtomicRepresentable Tests")
internal struct UInt4AtomicRepresentableTests {
    internal init() {}

    @Test(
        "Representation round trip succeeds",
        arguments: [
            0,
            1,
            15
        ] as Array<UInt4>
    )
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    internal func representationRoundTripSucceeds(initialValue: UInt4) {
        let representation: UInt4.AtomicRepresentation = UInt4.encodeAtomicRepresentation(initialValue)
        let decodedValue: UInt4 = UInt4.decodeAtomicRepresentation(representation)
        #expect(decodedValue == initialValue)
    }
}
