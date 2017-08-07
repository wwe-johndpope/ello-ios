////
///  ImagePickerSheetConfig.swift
//

import ImagePickerSheetController


struct ImagePickerSheetConfig {
    var cameraAction = InterfaceString.ImagePicker.TakePhoto
    var photoLibrary = InterfaceString.ImagePicker.PhotoLibrary
    var mediaType: ImagePickerMediaType = .image
    var addImage: (Int) -> String = { count in
        return InterfaceString.ImagePicker.AddImages(count)
    }
}
