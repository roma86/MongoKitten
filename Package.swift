// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MongoKitten",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MongoKitten",
            targets: ["MongoKitten"]),
        .library(
            name: "GridFS",
            targets: ["GridFS"]),
    ],
    dependencies: [
        // 💾
        .package(url: "https://github.com/OpenKitten/BSON.git", .revision("develop/6.0/rewrite")),
        
        // 🚀
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.8.0"),
        
        // 🔑
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "1.1.1"),
        
        // 📝
        .package(url: "https://github.com/OpenKitten/NioDNS.git", .revision("f73be8acc4714fcb4555af2a58851b0e6df22710"))
    ],
    targets: [
        .target(
            name: "_MongoKittenCrypto",
            dependencies: []
        ),
        .target(
            name: "MongoKitten",
            dependencies: ["BSON", "_MongoKittenCrypto", "NioDNS", "NIO", "NIOOpenSSL"]),
        .target(
            name: "GridFS",
            dependencies: ["BSON", "MongoKitten", "NIO"]),
        .testTarget(
            name: "MongoKittenTests",
            dependencies: ["MongoKitten"]),
    ]
)
