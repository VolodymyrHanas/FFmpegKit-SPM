// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "6.0"

let frameworks = ["ffmpegkit": "3cd11a6c3bd328313d14dcc5fc1517e807fd572110aa1223aebf1ef4a9e518a6", "libavcodec": "195eea685bba23ab1f9d2f0f8ab6617290af67eaebdee41bd748ce3c1a4d428a", "libavdevice": "c3ad56e04069c24fc5e313bfed35a80cd43e7ea8a84fd0de05bfbd9bf1a0f070", "libavfilter": "b997645db06b0b7281f6a603d6119082998fc2f6c1a1aa5b58632b3f75daaa6c", "libavformat": "845558180776d21118ba94933bfa21218ecd3e0ae3e4ebe5cf884423d32abd2a", "libavutil": "6a5fcfbd713ba194ef1182bcf1941406da21025eb0597d83caa3bbe23eda4586", "libswresample": "16342c72b0fb9d52ef2cf6d3b5a34c9aed2b5e823829692d4f1afe3a07c9b68e", "libswscale": "772e0e2be9c74620521e9134b6ab4e251e9c19779c4af5b31f017b2408b03909"]

func xcframework(_ package: Dictionary<String, String>.Element) -> Target {
    let url = "https://github.com/VolodymyrHanas/FFmpegKit-SPM/releases/download/\(release)/\(package.key).xcframework.zip"
    return .binaryTarget(name: package.key, url: url, checksum: package.value)
}

let linkerSettings: [LinkerSetting] = [
    .linkedFramework("AudioToolbox"),
    .linkedFramework("AVFoundation"),
    .linkedFramework("CoreMedia"),
    .linkedFramework("VideoToolbox")
]

let libAVFrameworks = frameworks.filter({ $0.key != "ffmpegkit" })

let package = Package(
    name: "FFmpegKit-SPM",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "FFmpeg-Kit",
            targets: ["FFmpeg-Kit", "ffmpegkit"]),
        .library(
            name: "FFmpeg",
            targets: ["FFmpeg"] + libAVFrameworks.map { $0.key })
    ] + libAVFrameworks.map { .library(name: $0.key, targets: [$0.key]) },
    dependencies: [],
    targets: [
        .target(
            name: "FFmpeg-Kit",
            dependencies: frameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings),
        .target(
            name: "FFmpeg",
            dependencies: libAVFrameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings)
    ] + frameworks.map { xcframework($0) }
)
