# UMShare (UMSocial) iOS SDK · Swift Package Manager

友盟+ 社会化分享组件 UMSocial（UMShare）v6.11.1 的 Swift Package Manager 分发仓库。

本仓库按平台拆分为多个 library product，集成方按需添加。核心 `UMShare` 依赖友盟基础组件
UMCommon，已通过 [`umcommon-ios-spm`](https://github.com/umeng/umcommon-ios-spm) 声明，
**无需**再单独添加 UMCommon 包。

## Product 一览

| Product | 说明 | 依赖 |
| --- | --- | --- |
| `UMShare` | 分享核心（必选） | UMCommon |
| `UShareUI` | 分享 UI 面板 + `UMSocialSDKResources.bundle` | UMShare |
| `UMShareWeChat` | 微信分享/登录 | UMShare |
| `UMShareSina` | 新浪微博 | UMShare |
| `UMShareQQ` | QQ / QQ 空间 | UMShare |
| `UMShareAlipay` | 支付宝 | UMShare |
| `UMShareDingDing` | 钉钉 | UMShare |
| `UMShareDouYin` | 抖音 | UMShare |

> 每个平台 product 已内置对应的友盟适配器 + 第三方平台 SDK 二进制 + 资源包，
> 集成方只需添加对应 product，无需再手动引入微信/QQ 等原生 SDK。

## 版本对应关系

| SwiftPM tag | UMShare | UMCommon | UMDevice |
| --- | --- | --- | --- |
| `6.11.1` | `6.11.1` | `7.7.0` | `3.6.0` |

## 环境要求

- iOS 12.0 及以上。
- Xcode 14.0 及以上（Package.swift 使用 Swift tools 5.7）。
- 真机 arm64；模拟器 **仅 x86_64**。

## 集成步骤

1. **File → Add Package Dependencies**，输入：

   ```text
   https://github.com/umeng/umshare-ios-spm.git
   ```

2. 依赖规则选 **Exact Version**，填 `6.11.1`。
3. 按需勾选 product：至少选 `UMShare`；需要分享面板再选 `UShareUI`；
   需要哪个平台就选哪个 `UMShare<平台>`。

或在 `Package.swift` 中：

```swift
dependencies: [
    .package(url: "https://github.com/umeng/umshare-ios-spm.git", exact: "6.11.1")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "UMShare", package: "umshare-ios-spm"),
        .product(name: "UShareUI", package: "umshare-ios-spm"),
        .product(name: "UMShareWeChat", package: "umshare-ios-spm"),
        // ... 其它按需平台
    ])
]
```

代码中：

```objc
@import UMCommon;
@import UMShare;
```

```swift
import UMCommon
import UMShare
```

初始化与平台配置请参考 [友盟分享官方文档](https://devs.umeng.com/docs/128606/detail/193653)。

## ⚠️ 集成必读（三项关键配置）

### 1. 必须添加 `-ObjC` 链接标志

UMShare 及各平台适配器均为**静态库**，其中包含大量 Objective-C 分类（Category）。
请在 App Target 的 **Build Settings → Other Linker Flags** 中添加 `-ObjC`，
否则分类方法不会被加载，运行时会出现 `unrecognized selector` 或平台 handler 找不到。
（CocoaPods 会自动加此标志，SwiftPM 不会，需手动添加。）

### 2. 模拟器架构（Apple Silicon）

所依赖的第三方平台 SDK（微信/QQ/微博/抖音等）为旧版 fat 二进制，**不含 arm64 模拟器切片**。
因此模拟器切片仅提供 x86_64。在 Apple Silicon Mac 上请二选一：

- Xcode 中用 Rosetta 运行模拟器；或
- 在 App 的 Build Settings 设置 `EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64`
  （与原 podspec 行为一致）。

真机（arm64）不受影响。

### 3. 资源 Bundle 加载说明

`UMSocialSDKResources.bundle`、`WeiboSDK.bundle`、`TencentOpenApi_IOS_Bundle.bundle`、
`BytedanceOpenPlatformSDK.bundle` 已随对应 product 通过 SwiftPM 资源机制打包。

但需注意：UMSocial 源码通过 **主 Bundle 根目录** 查找资源，例如：

```objc
NSString *p = [[[NSBundle mainBundle] resourcePath]
    stringByAppendingPathComponent:@"UMSocialSDKResources.bundle"];
```

而 SwiftPM 会把资源放进带命名空间的资源包
（`App.app/umshare-ios-spm_UMSocialUI.bundle/UMSocialSDKResources.bundle`），
两者路径不一致。**若发现分享面板图标/多语言缺失**，请手动把下列 bundle 拖入 App Target
的 **Copy Bundle Resources**（仓库内已提供，位于各 `Sources/<平台>/` 目录）：

- `UMSocialSDKResources.bundle`（UShareUI 面板必需）
- `WeiboSDK.bundle`（微博）
- `TencentOpenApi_IOS_Bundle.bundle`（QQ）
- `BytedanceOpenPlatformSDK.bundle`（抖音）

## 仓库结构

```
umshare-ios-spm/
├── Package.swift
├── Frameworks/                      # 15 个已签名 xcframework
│   ├── UMShare.xcframework          # 核心
│   ├── UShareUI.xcframework         # UI
│   ├── UMSocial<平台>Adapter.xcframework  # 6 个友盟适配器
│   └── WeChatSDK/WeiboSDK/TencentOpenAPI/AlipaySDK/DTShareKit/
│       DouyinOpenSDK/BytedanceOpenPlatformSDK.xcframework  # 第三方 SDK
└── Sources/                         # 8 个 shim target（承载依赖/资源/linker 设置）
    ├── UMShareCore/  UMSocialUI/
    └── UMShare{WeChat,Sina,QQ,Alipay,DingDing,DouYin}/
```

> `binaryTarget` 无法声明依赖、资源与 linker 设置，故每个二进制都配一个 shim Swift target
> 承载这些能力（详见 `Package.swift` 注释）。

## 许可

SDK 为友盟版权所有的闭源二进制组件；各第三方平台 SDK 版权归对应平台所有，
使用须遵循友盟及第三方 SDK 相关协议。
