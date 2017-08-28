////
///  ExtensionOverrides.swift
//


class Window {
    static func columnCountFor(width: CGFloat) -> Int { return 1 }
    static func isWide(_ width: Float) -> Bool { return false }
    static var width: Float { return 0 }
}

class DeviceScreen {
    static var isRetina: Bool { return true }
    static var scale: Float { return 2 }
}

extension String {

    // no need to include common crypto in
    // an app extension so we return an
    // unmodified string in ShareExtension
    var saltedSHA1String: String? {
        return self
    }

    var SHA1String: String? {
        return self
    }
}
