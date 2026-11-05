# Installation

Add Numerics Extended to a Swift package and import the public product.

## Overview

Numerics Extended is distributed as a Swift package. Add it as a dependency, attach the `NumericsExtended` product to
your target, and import the module in source files that use the protocols or experimental numeric types.

### Add the Package Dependency

Add the package to the dependencies in your `Package.swift` file.

```swift
let package: Package = .init(
    ...
    dependencies: [
        .package(
            url: "https://github.com/bikecalc/swift-numerics-extended.git",
            from: "3.0.0"
        )
    ],
    ...
)
```

### Attach the Product to a Target

Add the `NumericsExtended` product to the dependencies of the target that will import it. Replace `YourTarget` with the
name of that target.

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

### Import the Module

Import the package in your source code.

```swift
import NumericsExtended
```
