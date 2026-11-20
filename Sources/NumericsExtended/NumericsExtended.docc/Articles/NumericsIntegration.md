# Numerics Integration

Use Swift Numerics types with Numerics Extended protocols.

## Overview

Numerics Integration adds Numerics Extended protocol conformances to Apple's `Complex` type. These conformances let
complex values participate in generic algorithms that require individual numeric capabilities.

## Using the Integration

Add the `NumericsExtended` and Swift Numerics `Numerics` products to your target's dependencies. Import
`NumericsExtended` to make the conformances available, and import `Numerics` to use Apple's types and APIs. No separate
integration product or import is required.

Swift Numerics is included as a package dependency of Numerics Extended. Its APIs are not re-exported by
`NumericsExtended`.

## Supported Capabilities

`Complex` conforms to the following protocols:

- ``/CoreNumericProtocols/Addable`` and ``/CoreNumericProtocols/Subtractable`` for addition and subtraction.
- ``/CoreNumericProtocols/Negateable`` for negation.
- ``/CoreNumericProtocols/RepresentableByZero`` for the additive identity.
- ``/CoreNumericProtocols/ApproximatelyEquatable`` for approximate comparisons.
- ``/CoreNumericProtocols/Invertible`` for optional reciprocals and reciprocal availability.

The conformances reuse Swift Numerics' implementations of arithmetic, approximate comparison, and reciprocals.

## Behavior and Limitations

Approximate comparisons use `Complex`'s maximum-component magnitude and Swift Numerics' tolerance and nonfinite-value
rules. `isInvertible` is true when Swift Numerics returns a non-nil reciprocal; it does not impose a separate
invertibility rule.

The integration does not add `Multipliable`, `Divisible`, or `Raisable` conformances to `Complex`. Those protocols
require additional operations, such as multiple checking, remainders, or power checking, beyond Apple's arithmetic
operators. Swift Numerics' own multiplication, division, and power APIs remain available.
