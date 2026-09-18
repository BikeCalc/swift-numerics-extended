![](Assets/GitHubBanner.png)

# Swift Numerics Extended

A Swift package extending numeric protocols, standard numeric types, and experimental numeric types.

## Overview

Numerics Extended provides a layered set of numeric protocols and utilities for Swift. It includes core numeric
operators, core numeric protocols, extensions for standard library numeric protocols, standard numeric type
conformances, experimental numeric constants, experimental numeric protocols, and experimental numeric types such as
`Fraction`, `Roman`, `Int4`, and `UInt4`.

Experimental numeric types are included for exploration and documentation, and their APIs may evolve across major
releases.

## Requirements

- Swift 6.3+

Numerics Extended is written in Swift and avoids platform-specific APIs where possible.

## Installation

1. Add Numerics Extended to the dependencies in your `Package.swift` file:

    ```swift
    let package: Package = .init(
        ...
        dependencies: [
            .package(
                url: "https://github.com/bikecalc/swift-numerics-extended.git",
                from: "2.0.0"
            )
        ],
        ...
    )
    ```

2. Add the `NumericsExtended` product to the dependencies of the target that will import it. Replace `YourTarget` with
   the name of that target:

    ```swift
    let package: Package = .init(
        ...
        targets: [
            .target(
                name: "YourTarget",
                dependencies: [
                    .product(
                        name: "NumericsExtended",
                        package: "swift-numerics-extended"
                    )
                ]
            )
        ],
        ...
    )
    ```

3. Import the package in your source code:

    ```swift
    import NumericsExtended
    ```

## Demonstration

Keep a fraction in canonical form while doing arithmetic:

```swift
@Canonicalized
var value: Fraction<Int> = .init(2, 4)
print(value)
// Prints "1/2"

value += .init(1, 4)
print(value)
// Prints "3/4"

value *= .init(2, 3)
print(value)
// Prints "1/2"
```

`Fraction` conforms to `Rational`, which builds on Swift's numeric protocols. Beyond the operations shown here, it 
supports subtraction, division, exponentiation, and comparisons.

## Documentation

You can read more about this package by visiting the
[documentation](https://bikecalc.github.io/swift-numerics-extended/documentation/numericsextended).

## Contributing

Everyone is welcome to contribute to Numerics Extended. See the [contribution guidelines](CONTRIBUTING.md) for branch
conventions, pull request expectations, and testing instructions.

If you find a bug, please create an [issue](https://github.com/bikecalc/swift-numerics-extended/issues). Security
vulnerabilities should be reported using the [security policy](SECURITY.md).

## Code of Conduct

This project follows a [code of conduct](CODE_OF_CONDUCT.md).

## License

Distributed under Apache License v2.0 with Runtime Library Exception. See the [license](LICENSE.md) for more information.
