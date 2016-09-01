////
///  ValidationState.swift
//

import UIKit


enum ValidationState {
    case Loading
    case Error
    case OK
    case OKSmall
    case None

    var imageRepresentation: UIImage? {
        switch self {
        case .Loading: return InterfaceImage.ValidationLoading.normalImage
        case .Error: return InterfaceImage.ValidationError.normalImage
        case .OK: return InterfaceImage.ValidationOK.normalImage
        case .OKSmall: return InterfaceImage.SmallCheck.normalImage
        case .None: return nil
        }
    }
}
