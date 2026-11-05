// Shim target for the UMSocial core (UMShare.framework).
//
// Binary targets in SwiftPM cannot declare dependencies or linker settings,
// so this target carries:
//   * the transitive dependency on UMCommon (via umcommon-ios-spm), and
//   * the system libraries/frameworks UMShare.framework needs at link time.
// No public API is exposed to consumers; `import UMShare` still resolves to
// the binary framework's module.
import Foundation
