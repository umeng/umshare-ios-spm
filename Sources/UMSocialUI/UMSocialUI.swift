// Shim target for the UMSocial UI component (UShareUI.framework).
// Carries the UMSocialSDKResources.bundle and the QuartzCore link flag.
// See README "资源加载说明" for how UMSocialSDKResources.bundle is resolved.
import Foundation

/// The SwiftPM resource bundle that contains `UMSocialSDKResources.bundle`.
public enum UMSocialUIResources {
    public static let bundle: Bundle = Bundle.module
}
