// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "EncryptingSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "EncryptingSwift",
            targets: ["EncryptingSwift"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/sublabdev/common-swift.git", exact: "1.0.0"),
        .package(url: "https://github.com/sublabdev/hashing-swift.git", exact: "1.0.0"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", exact: "0.1.4"),
        .package(url: "https://github.com/pebble8888/ed25519swift.git", exact: "1.2.8"),
        .package(url: "https://github.com/tesseract-one/Sr25519.swift.git", exact: "0.1.3"),
        .package(url: "https://github.com/tesseract-one/Bip39.swift.git", exact: "0.1.1")
    ],
    targets: [
        .target(
            name: "EncryptingSwift",
            dependencies: [
                .productItem(name: "CommonSwift", package: "common-swift"),
                .productItem(name: "HashingSwift", package: "hashing-swift"),
                .productItem(name: "secp256k1", package: "secp256k1.swift"),
                .productItem(name: "ed25519swift", package: "ed25519swift"),
                .productItem(name: "Sr25519", package: "Sr25519.swift"),
                .productItem(name: "Bip39", package: "Bip39.swift"),
            ]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)

