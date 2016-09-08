////
///  ImagePickerSheetConfig.swift
//

import ImagePickerSheetController


struct ImagePickerSheetConfig {
    var cameraAction = InterfaceString.ImagePicker.TakePhoto
    var photoLibrary = InterfaceString.ImagePicker.PhotoLibrary
    var mediaType: ImagePickerMediaType = .Image
    var addImage: (Int) -> String = { count in
        return NSString.localizedStringWithFormat(InterfaceString.ImagePicker.AddImagesTemplate, count) as String
    }
}
