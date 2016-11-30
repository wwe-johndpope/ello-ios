////
///  CategoryCardView.swift
//

public class CategoryCardView: UIView {

    let info: CategoryCardListView.CategoryInfo

    let overlay = UIView()
    public let button = UIButton()

    private static let selectedAlpha: CGFloat = 0.8
    private static let normalAlpha: CGFloat = 0.6

    private var _selected = false
    var selected: Bool {
        set {
            _selected = newValue
            animate {
                self.overlay.alpha = newValue ? CategoryCardView.selectedAlpha : CategoryCardView.normalAlpha
            }
        }
        get { return _selected }
    }

    public init(frame: CGRect, info: CategoryCardListView.CategoryInfo) {
        self.info = info

        super.init(frame: frame)
        style()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        backgroundColor = .blackColor()

        overlay.backgroundColor = .blackColor()
        overlay.alpha = CategoryCardView.normalAlpha

        button.titleLabel?.numberOfLines = 0
        let attributedString = NSAttributedString(info.title, color: .whiteColor(), alignment: .Center)
        button.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }

    private func arrange() {
        if let url = info.imageURL {
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .ScaleAspectFill
            imageView.pin_setImageFromURL(url)
            addSubview(imageView)
            imageView.snp_makeConstraints { $0.edges.equalTo(self) }
        }

        addSubview(overlay)
        addSubview(button)

        overlay.snp_makeConstraints { $0.edges.equalTo(self) }
        button.snp_makeConstraints { $0.edges.equalTo(self).inset(5) }
    }
}
