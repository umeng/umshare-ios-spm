// swift-tools-version:5.7

import PackageDescription

// NOTE: UMSocial ships prebuilt static frameworks/libraries. SwiftPM binary
// targets cannot declare dependencies, resources or linker settings, so every
// binary is paired with a lightweight "shim" Swift target that carries:
//   * the transitive dependency on UMCommon / UMShare core,
//   * required system frameworks & libraries (from the original podspec), and
//   * any resource bundle.
// The simulator slices are x86_64 only (the bundled third-party SDKs have no
// arm64-simulator slice); on Apple Silicon run the simulator under Rosetta or
// set EXCLUDED_ARCHS[sdk=iphonesimulator*]=arm64, matching the podspec.
let package = Package(
    name: "UMShare",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "UMShare", targets: ["UMShareCore"]),
        .library(name: "UShareUI", targets: ["UMSocialUI"]),
        .library(name: "UMShareWeChat", targets: ["UMShareWeChat"]),
        .library(name: "UMShareSina", targets: ["UMShareSina"]),
        .library(name: "UMShareQQ", targets: ["UMShareQQ"]),
        .library(name: "UMShareAlipay", targets: ["UMShareAlipay"]),
        .library(name: "UMShareDingDing", targets: ["UMShareDingDing"]),
        .library(name: "UMShareDouYin", targets: ["UMShareDouYin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/umeng/umcommon-ios-spm.git", exact: "7.7.0"),
    ],
    targets: [
        // MARK: - Core
        .binaryTarget(name: "UMShare", path: "Frameworks/UMShare.xcframework"),
        .target(
            name: "UMShareCore",
            dependencies: [
                "UMShare",
                .product(name: "UMCommon", package: "umcommon-ios-spm"),
            ],
            path: "Sources/UMShareCore",
            linkerSettings: [
                .linkedLibrary("sqlite3"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("WebKit"),
            ]
        ),

        // MARK: - UI
        .binaryTarget(name: "UShareUI", path: "Frameworks/UShareUI.xcframework"),
        .target(
            name: "UMSocialUI",
            dependencies: ["UShareUI", "UMShareCore"],
            path: "Sources/UMSocialUI",
            resources: [.copy("UMSocialSDKResources.bundle")],
            linkerSettings: [
                .linkedFramework("QuartzCore"),
            ]
        ),

        // MARK: - WeChat (微信)
        .binaryTarget(name: "UMSocialWeChatAdapter", path: "Frameworks/UMSocialWeChatAdapter.xcframework"),
        .binaryTarget(name: "WeChatSDK", path: "Frameworks/WeChatSDK.xcframework"),
        .target(
            name: "UMShareWeChat",
            dependencies: ["UMSocialWeChatAdapter", "WeChatSDK", "UMShareCore"],
            path: "Sources/UMShareWeChat",
            linkerSettings: [
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("CoreTelephony"),
                .linkedLibrary("sqlite3"),
                .linkedLibrary("c++"),
                .linkedLibrary("z"),
            ]
        ),

        // MARK: - Sina Weibo (新浪微博)
        .binaryTarget(name: "UMSocialSinaAdapter", path: "Frameworks/UMSocialSinaAdapter.xcframework"),
        .binaryTarget(name: "WeiboSDK", path: "Frameworks/WeiboSDK.xcframework"),
        .target(
            name: "UMShareSina",
            dependencies: ["UMSocialSinaAdapter", "WeiboSDK", "UMShareCore"],
            path: "Sources/UMShareSina",
            resources: [.copy("WeiboSDK.bundle")],
            linkerSettings: [
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("ImageIO"),
                .linkedFramework("Photos"),
                .linkedFramework("Security"),
                .linkedFramework("CoreText"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("WebKit"),
                .linkedLibrary("sqlite3"),
                .linkedLibrary("z"),
            ]
        ),

        // MARK: - QQ
        .binaryTarget(name: "UMSocialQQAdapter", path: "Frameworks/UMSocialQQAdapter.xcframework"),
        .binaryTarget(name: "TencentOpenAPI", path: "Frameworks/TencentOpenAPI.xcframework"),
        .target(
            name: "UMShareQQ",
            dependencies: ["UMSocialQQAdapter", "TencentOpenAPI", "UMShareCore"],
            path: "Sources/UMShareQQ",
            resources: [.copy("TencentOpenApi_IOS_Bundle.bundle")],
            linkerSettings: [
                .linkedFramework("SystemConfiguration"),
                .linkedLibrary("c++"),
            ]
        ),

        // MARK: - Alipay (支付宝)
        .binaryTarget(name: "UMSocialAlipayAdapter", path: "Frameworks/UMSocialAlipayAdapter.xcframework"),
        .binaryTarget(name: "AlipaySDK", path: "Frameworks/AlipaySDK.xcframework"),
        .target(
            name: "UMShareAlipay",
            dependencies: ["UMSocialAlipayAdapter", "AlipaySDK", "UMShareCore"],
            path: "Sources/UMShareAlipay"
        ),

        // MARK: - DingDing (钉钉)
        .binaryTarget(name: "UMSocialDingDingAdapter", path: "Frameworks/UMSocialDingDingAdapter.xcframework"),
        .binaryTarget(name: "DTShareKit", path: "Frameworks/DTShareKit.xcframework"),
        .target(
            name: "UMShareDingDing",
            dependencies: ["UMSocialDingDingAdapter", "DTShareKit", "UMShareCore"],
            path: "Sources/UMShareDingDing"
        ),

        // MARK: - DouYin (抖音)
        .binaryTarget(name: "UMSocialDouYinAdapter", path: "Frameworks/UMSocialDouYinAdapter.xcframework"),
        .binaryTarget(name: "DouyinOpenSDK", path: "Frameworks/DouyinOpenSDK.xcframework"),
        .binaryTarget(name: "BytedanceOpenPlatformSDK", path: "Frameworks/BytedanceOpenPlatformSDK.xcframework"),
        .target(
            name: "UMShareDouYin",
            dependencies: ["UMSocialDouYinAdapter", "DouyinOpenSDK", "BytedanceOpenPlatformSDK", "UMShareCore"],
            path: "Sources/UMShareDouYin",
            resources: [.copy("BytedanceOpenPlatformSDK.bundle")],
            linkerSettings: [
                .linkedFramework("WebKit"),
                .linkedFramework("Security"),
                .linkedFramework("Photos"),
            ]
        ),
    ]
)
