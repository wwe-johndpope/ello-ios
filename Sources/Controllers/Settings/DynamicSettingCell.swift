////
///  DynamicSettingCell.swift
//

public protocol DynamicSettingCellDelegate: class {
    func toggleSetting(setting: DynamicSetting, value: Bool)
    func deleteAccount()
}

public class DynamicSettingCell: UITableViewCell {
    @IBOutlet public weak var titleLabel: StyledLabel!
    public weak var descriptionLabel: StyledLabel!
    @IBOutlet public weak var toggleButton: ElloToggleButton!
    @IBOutlet public weak var deleteButton: ElloToggleButton!

    public weak var delegate: DynamicSettingCellDelegate?
    public var setting: DynamicSetting?

    @IBAction public func toggleButtonTapped() {
        if let setting = setting {
            delegate?.toggleSetting(setting, value: !toggleButton.value)
            toggleButton.value = !toggleButton.value
        }
    }

    @IBAction public func deleteButtonTapped() {
        delegate?.deleteAccount()
    }
}
