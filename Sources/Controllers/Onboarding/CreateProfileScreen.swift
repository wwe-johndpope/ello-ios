////
///  CreateProfileScreen.swift
//

import Photos
import SnapKit
import ImagePickerSheetController


public class CreateProfileScreen: Screen {
    private enum Uploading {
        case CoverImage
        case Avatar
    }

    struct Size {
        static let insets: CGFloat = 10
        static let headerHeight: CGFloat = 77
        static let promptOffset: CGFloat = 10
        static let avatarOffset: CGFloat = 20
        static let fieldsTopOffset: CGFloat = 40
        static let fieldsInnerOffset: CGFloat = 20
        static let fieldHeight: CGFloat = 30
        static let avatarHeight: CGFloat = 220
        static let lineHeight: CGFloat = 1
        static let uploadSize = CGSize(width: 130, height: 40)
    }

    weak var delegate: CreateProfileDelegate?
    private var uploading: Uploading?

    private let scrollView = UIScrollView()
    private var scrollViewWidth: Constraint!
    private let headerLabel = UILabel()

    private let coverImage = FLAnimatedImageView()
    private let uploadCoverImageButton = GreenElloButton()
    private let uploadCoverImagePrompt = UILabel()

    private let avatarImage = FLAnimatedImageView()
    private let uploadAvatarButton = GreenElloButton()
    private let uploadAvatarPrompt = UILabel()

    private let nameField = UITextField()
    private let nameLine = UIView()
    private let bioField = UITextField()
    private let bioLine = UIView()
    private let linksField = UITextField()
    private let linksLine = UIView()

    override func style() {
        headerLabel.numberOfLines = 0

        coverImage.backgroundColor = .greyE5()
        coverImage.contentMode = .ScaleAspectFill
        uploadCoverImagePrompt.textAlignment = .Center
        uploadCoverImagePrompt.textColor = .greyA()
        uploadCoverImagePrompt.font = UIFont.defaultFont(12)
        uploadCoverImagePrompt.numberOfLines = 2

        avatarImage.backgroundColor = .greyE5()
        avatarImage.layer.masksToBounds = true
        avatarImage.contentMode = .ScaleAspectFill
        uploadAvatarPrompt.textAlignment = .Center
        uploadAvatarPrompt.textColor = .greyA()
        uploadAvatarPrompt.font = UIFont.defaultFont(12)
        uploadAvatarPrompt.numberOfLines = 2

        nameField.textColor = .blackColor()
        nameLine.backgroundColor = .greyE5()
        bioField.textColor = .blackColor()
        bioLine.backgroundColor = .greyE5()
        linksField.textColor = .blackColor()
        linksLine.backgroundColor = .greyE5()
    }

    override func bindActions() {
        uploadCoverImageButton.addTarget(self, action: #selector(uploadCoverImageAction), forControlEvents: .TouchUpInside)
        uploadAvatarButton.addTarget(self, action: #selector(uploadAvatarAction), forControlEvents: .TouchUpInside)
    }

    override func setText() {
        uploadCoverImageButton.setTitle(InterfaceString.Onboard.UploadCoverButton, forState: .Normal)
        uploadAvatarButton.setTitle(InterfaceString.Onboard.UploadAvatarButton, forState: .Normal)
        headerLabel.attributedText = NSAttributedString(
            primaryHeader: InterfaceString.Onboard.PickCategoriesPrimary,
            secondaryHeader: InterfaceString.Onboard.PickCategoriesSecondary
            )
        uploadCoverImagePrompt.text = InterfaceString.Onboard.UploadCoverImagePrompt
        uploadAvatarPrompt.text = InterfaceString.Onboard.UploadAvatarPrompt
        nameField.placeholder = InterfaceString.Onboard.NamePlaceholder
        bioField.placeholder = InterfaceString.Onboard.BioPlaceholder
        linksField.placeholder = InterfaceString.Onboard.LinksPlaceholder
    }

    override func arrange() {
        addSubview(scrollView)

        let widthAnchor = UIView()
        scrollView.addSubview(widthAnchor)
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(coverImage)
        scrollView.addSubview(uploadCoverImageButton)
        scrollView.addSubview(uploadCoverImagePrompt)
        scrollView.addSubview(avatarImage)
        scrollView.addSubview(uploadAvatarButton)
        scrollView.addSubview(uploadAvatarPrompt)
        scrollView.addSubview(nameField)
        scrollView.addSubview(nameLine)
        scrollView.addSubview(bioField)
        scrollView.addSubview(bioLine)
        scrollView.addSubview(linksField)
        scrollView.addSubview(linksLine)

        scrollView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }

        widthAnchor.snp_makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            scrollViewWidth = make.width.equalTo(bounds.size.width).priorityRequired().constraint
        }

        headerLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        headerLabel.snp_makeConstraints { make in
            make.top.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView).inset(Size.insets)
            make.height.equalTo(Size.headerHeight)
        }

        coverImage.snp_makeConstraints { make in
            make.top.equalTo(headerLabel.snp_bottom)
            make.leading.trailing.equalTo(scrollView)
            make.height.equalTo(coverImage.snp_width).multipliedBy(0.625)
        }
        uploadCoverImageButton.snp_makeConstraints { make in
            make.centerX.centerY.equalTo(coverImage)
            make.size.equalTo(Size.uploadSize)
        }
        uploadCoverImagePrompt.snp_makeConstraints { make in
            make.centerX.equalTo(uploadCoverImageButton)
            make.top.equalTo(uploadCoverImageButton.snp_bottom).offset(Size.promptOffset)
        }

        avatarImage.snp_makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(coverImage.snp_bottom).offset(Size.avatarOffset)
            make.width.height.equalTo(Size.avatarHeight)
        }
        uploadAvatarButton.snp_makeConstraints { make in
            make.top.equalTo(avatarImage.snp_bottom).offset(Size.avatarOffset)
            make.centerX.equalTo(scrollView)
            make.size.equalTo(Size.uploadSize)
        }
        uploadAvatarPrompt.snp_makeConstraints { make in
            make.centerX.equalTo(uploadAvatarButton)
            make.top.equalTo(uploadAvatarButton.snp_bottom).offset(Size.promptOffset)
        }

        nameField.snp_makeConstraints { make in
            make.top.equalTo(uploadAvatarPrompt.snp_bottom).offset(Size.fieldsTopOffset)
            make.height.equalTo(Size.fieldHeight)
            make.leading.trailing.equalTo(scrollView).inset(Size.insets)
        }
        nameLine.snp_makeConstraints { make in
            make.leading.trailing.bottom.equalTo(nameField)
            make.height.equalTo(Size.lineHeight)
        }
        bioField.snp_makeConstraints { make in
            make.top.equalTo(nameField.snp_bottom).offset(Size.fieldsInnerOffset)
            make.height.equalTo(Size.fieldHeight)
            make.leading.trailing.equalTo(scrollView).inset(Size.insets)
        }
        bioLine.snp_makeConstraints { make in
            make.leading.trailing.bottom.equalTo(bioField)
            make.height.equalTo(Size.lineHeight)
        }
        linksField.snp_makeConstraints { make in
            make.top.equalTo(bioField.snp_bottom).offset(Size.fieldsInnerOffset)
            make.height.equalTo(Size.fieldHeight)
            make.leading.trailing.equalTo(scrollView).inset(Size.insets)
        }
        linksLine.snp_makeConstraints { make in
            make.leading.trailing.bottom.equalTo(linksField)
            make.height.equalTo(Size.lineHeight)
            make.bottom.equalTo(scrollView.snp_bottom).inset(Size.insets)
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        scrollViewWidth.updateOffset(bounds.size.width)
    }

    override public func resignFirstResponder() -> Bool {
        nameField.resignFirstResponder()
        bioField.resignFirstResponder()
        linksField.resignFirstResponder()
        return true
    }

}

extension CreateProfileScreen {
    func uploadCoverImageAction() {
        resignFirstResponder()
        uploading = .CoverImage
        var config = ImagePickerSheetConfig()
        config.addImage = { _ in return InterfaceString.ImagePicker.ChooseImage }
        let pickerSheet = UIImagePickerController.imagePickerSheetForImagePicker(
            config: config,
            callback: openImageSheet)
        pickerSheet.maximumSelection = 1
        delegate?.presentController(pickerSheet)
    }

    func uploadAvatarAction() {
        resignFirstResponder()
        uploading = .Avatar
        var config = ImagePickerSheetConfig()
        config.addImage = { _ in return InterfaceString.ImagePicker.ChooseImage }
        let pickerSheet = UIImagePickerController.imagePickerSheetForImagePicker(
            config: config,
            callback: openImageSheet)
        pickerSheet.maximumSelection = 1
        delegate?.presentController(pickerSheet)
    }
}

extension CreateProfileScreen: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerController(controller: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            delegate?.dismissController()
            return
        }

        if let url = info[UIImagePickerControllerReferenceURL] as? NSURL,
            asset = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil).firstObject as? PHAsset
        {
            processPHAssets([asset])
            delegate?.dismissController()
        }
        else {
            image.copyWithCorrectOrientationAndSize() { image in
                self.setImage(image)
                self.delegate?.dismissController()
            }
        }
    }

    public func imagePickerControllerDidCancel(controller: UIImagePickerController) {
        delegate?.dismissController()
    }

    func processPHAssets(assets: [PHAsset]) {
        AssetsToRegions.processPHAssets(assets) { (imageData: [ImageRegionData]) in
            for imageDatum in imageData {
                let (image, _, _) = (imageDatum.image, imageDatum.data, imageDatum.contentType)
                self.setImage(image)
                break
            }
        }
    }

    func setImage(image: UIImage) {
        guard let uploading = uploading else { return }

        switch uploading {
        case .CoverImage:
            coverImage.image = image
        case .Avatar:
            avatarImage.image = image
        }
    }

    func openImageSheet(imageSheetResult: ImagePickerSheetResult) {
        switch imageSheetResult {
        case let .Controller(imageController):
            imageController.delegate = self
            delegate?.presentController(imageController)
        case let .Images(assets):
            processPHAssets(assets)
        }
    }

}
