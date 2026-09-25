// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "RunnerJamsCore",
    platforms: [
        .iOS(.v17),
        // macOS lets `swift test` run on a Mac and in CI without a simulator.
        .macOS(.v14),
    ],
    products: [
        .library(name: "RunnerJamsCore", targets: ["RunnerJamsCore"]),
    ],
    targets: [
        .target(name: "RunnerJamsCore"),
        .testTarget(name: "RunnerJamsCoreTests", dependencies: ["RunnerJamsCore"]),
    ]
)
