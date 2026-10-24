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

@Suite("Int4 AtomicRepresentable Tests")
internal struct Int4AtomicRepresentableTests {
    internal init() {}

    @Test(
        "Representation round trip succeeds",
        arguments: [
            -8,
            -1,
            0,
            1,
            7
        ] as Array<Int4>
    )
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *)
    internal func representationRoundTripSucceeds(initialValue: Int4) {
        let representation: Int4.AtomicRepresentation = Int4.encodeAtomicRepresentation(initialValue)
        let decodedValue: Int4 = Int4.decodeAtomicRepresentation(representation)
        #expect(decodedValue == initialValue)
    }
}
