////
///  ToNSData.swift
//

public protocol ToNSData {
    func toNSData() -> NSData?
}


extension NSData : ToNSData {
    public func toNSData() -> NSData? {
        return self
    }
}


extension String : ToNSData {
    public func toNSData() -> NSData? {
        return self.dataUsingEncoding(NSUTF8StringEncoding)
    }
}


extension UIImage : ToNSData {
    public func toNSData() -> NSData? {
        return UIImagePNGRepresentation(self)
    }
}
