// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navvy",
    platforms: [.iOS(.v13)],
    products: [.library(name: "Navvy", targets: ["Navvy"])],
    targets: [.target(name: "Navvy", dependencies: [])]
)
