// Shim target for the QQ share platform.
// Carries the adapter + TencentOpenAPI binaries, TencentOpenApi_IOS_Bundle.bundle,
// and the system frameworks/libraries required by the QQ SDK. No public API is exposed.
import Foundation

/// The SwiftPM resource bundle that contains `TencentOpenApi_IOS_Bundle.bundle`.
public enum UMShareQQResources {
    public static let bundle: Bundle = Bundle.module
}
