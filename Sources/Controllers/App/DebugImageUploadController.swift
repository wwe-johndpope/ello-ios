////
///  DebugImageUploadController.swift
//

import SnapKit


class DebugImageUploadController: UIViewController {

    struct Size {
        static let valueLabelTop: CGFloat = 150
        static let valueLabelHeight: CGFloat = 40
        static let sliderHeight: CGFloat = 40
        static let margin: CGFloat = 20
    }

    let valueLabel = StyledLabel(style: .black)
    let slider = UISlider()

    override func loadView() {
        super.loadView()

        style()
        bindActions()
        setText()
        arrange()
    }

    func style() {
        view.backgroundColor = .white
    }

    func bindActions() {
        slider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: .valueChanged)
    }

    func sliderValueChanged(slider: UISlider) {
        let rounded = Double(slider.value).roundTo()
        AppSetup.sharedState.imageQuality = CGFloat(slider.value)
        let percent = rounded * 100
        valueLabel.text = "\(percent)%"
    }

    func setText() {
        self.title = "Image Upload Quality"
        let stored = AppSetup.sharedState.imageQuality
        let rounded = Double(stored).roundTo()
        let percent = rounded * 100
        valueLabel.text = "\(percent)%"
        slider.value = Float(rounded)
    }

    func arrange() {
        view.addSubview(valueLabel)
        view.addSubview(slider)

        valueLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view).inset(Size.margin)
            make.top.equalTo(self.view).offset(Size.valueLabelTop)
            make.height.equalTo(Size.valueLabelHeight)
        }

        slider.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view).inset(Size.margin)
            make.top.equalTo(valueLabel.snp.bottom)
            make.height.equalTo(Size.sliderHeight)
        }
    }
}
