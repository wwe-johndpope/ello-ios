////
///  SearchStreamCell.swift
//

public class SearchStreamCell: UICollectionViewCell {
    static let reuseIdentifier = "SearchStreamCell"
    struct Size {
        static let insets: CGFloat = 10
    }

    private var debounced: ThrottledBlock = debounce(0.8)
    private let searchField = SearchTextField()
    public weak var delegate: SearchStreamDelegate?

    public var placeholder: String? {
        get { return searchField.placeholder }
        set { searchField.placeholder = newValue }
    }
    public var search: String? {
        get { return searchField.text }
        set { searchField.text = newValue }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()

        style()
        arrange()

        searchField.delegate = self
        searchField.addTarget(self, action: #selector(searchFieldDidChange), forControlEvents: .EditingChanged)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
    }

    private func arrange() {
        contentView.addSubview(searchField)

        searchField.snp_makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView).inset(Size.insets)
        }
    }
}

extension SearchStreamCell: DismissableCell {
    public func didEndDisplay() {
        searchField.resignFirstResponder()
    }
}

extension SearchStreamCell: UITextFieldDelegate {

    @objc
    public func searchFieldDidChange() {
        let text = searchField.text ?? ""
        if text.characters.count == 0 {
            clearSearch()
        }
        else {
            debounced { [unowned self] in
                self.searchForText()
            }
        }
    }

    @objc
    public func textFieldDidEndEditing(textField: UITextField) {
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
    }

    @objc
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func searchForText() {
        guard let
            text = searchField.text
        where
            text.characters.count > 0
        else { return }

        self.delegate?.searchFieldChanged(text)
    }

    private func clearSearch() {
        delegate?.searchFieldChanged("")
        debounced {}
    }
}
