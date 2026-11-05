// Shim target for the DouYin (抖音) share platform.
// Carries the adapter + DouyinOpenSDK + BytedanceOpenPlatformSDK binaries,
// BytedanceOpenPlatformSDK.bundle, and the required system frameworks.
// No public API is exposed.
import Foundation

/// The SwiftPM resource bundle that contains `BytedanceOpenPlatformSDK.bundle`.
public enum UMShareDouYinResources {
    public static let bundle: Bundle = Bundle.module
}
