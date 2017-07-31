////
///  CategoryCardView.swift
//

class CategoryCardView: UIView {

    let info: CategoryCardListView.CategoryInfo

    let overlay = UIView()
    let button = UIButton()

    static let selectedAlpha: CGFloat = 0.8
    static let normalAlpha: CGFloat = 0.6
    static let darkAlpha: CGFloat = 0.8

    fileprivate var _selected = false
    var isSelected: Bool {
        set {
            _selected = newValue
            let alpha: CGFloat
            if newValue {
                alpha = CategoryCardView.selectedAlpha
            }
            else if info.imageURL == nil {
                alpha = CategoryCardView.darkAlpha
            }
            else {
                alpha = CategoryCardView.normalAlpha
            }

            animate {
                self.overlay.alpha = alpha
            }
        }
        get { return _selected }
    }

    init(info: CategoryCardListView.CategoryInfo) {
        self.info = info

        super.init(frame: .zero)
        style()
        arrange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func style() {
        backgroundColor = .white

        overlay.backgroundColor = .black
        if info.imageURL == nil {
            overlay.alpha = CategoryCardView.darkAlpha
        }
        else {
            overlay.alpha = CategoryCardView.normalAlpha
        }

        button.titleLabel?.numberOfLines = 0
        let attributedString = NSAttributedString(info.title, color: .white, alignment: .center)
        button.setAttributedTitle(attributedString, for: .normal)
    }

    fileprivate func arrange() {
        if let url = info.imageURL {
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.pin_setImage(from: url as URL!)
            addSubview(imageView)
            imageView.snp.makeConstraints { $0.edges.equalTo(self) }
        }

        addSubview(overlay)
        addSubview(button)

        overlay.snp.makeConstraints { $0.edges.equalTo(self) }
        button.snp.makeConstraints { $0.edges.equalTo(self).inset(5) }
    }
}
