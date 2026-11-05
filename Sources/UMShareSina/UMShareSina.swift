// Shim target for the Sina Weibo (新浪微博) share platform.
// Carries the adapter + WeiboSDK binaries, WeiboSDK.bundle, and the system
// frameworks/libraries required by the Weibo SDK. No public API is exposed.
import Foundation

/// The SwiftPM resource bundle that contains `WeiboSDK.bundle`.
public enum UMShareSinaResources {
    public static let bundle: Bundle = Bundle.module
}
