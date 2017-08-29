////
///  AlertViewController.swift
//


class AlertViewController: UIViewController {

    struct Size {
        static let margins = UIEdgeInsets(top: 15, left: 20, bottom: 20, right: 20)
        static let cornerRadius: CGFloat = 10
        static let width: CGFloat = 300
        static let maxHeight = UIScreen.main.bounds.height - 20
    }

    // needs to be accessible for the AlertViewController keyboard extension
    let tableView = UITableView()

    fileprivate let headerView = AlertHeaderView()

    var keyboardWillShowObserver: NotificationObserver?
    var keyboardWillHideObserver: NotificationObserver?

    // assign a contentView to show a message or spinner.  The contentView frame
    // size must be set.
    var contentView: UIView? {
        willSet { willSetContentView() }
        didSet { didSetContentView() }
    }

    var modalBackgroundColor: UIColor = .dimmedModalBackground

    var desiredSize: CGSize {
        if let contentView = contentView {
            return contentView.frame.size
        }
        else {
            var contentHeight = totalVerticalPadding
            for action in actions {
                contentHeight += action.heightForWidth(Size.width)
            }
            let height = min(contentHeight, Size.maxHeight)
            return CGSize(width: Size.width, height: height)
        }
    }

    var isDismissable = true
    var shouldAutoDismiss = true

    fileprivate(set) var actions: [AlertAction] = []
    fileprivate var inputs: [String] = []
    var actionInputs: [String] {
        var retVals: [String] = []
        for (index, action) in actions.enumerated() where action.isInput {
            retVals.append(inputs[index])
        }
        return retVals
    }

    fileprivate let textAlignment: NSTextAlignment

    var message: String {
        get { return headerView.label.text ?? "" }
        set(text) {
            headerView.label.text = text
            tableView.reloadData()
        }
    }

    fileprivate var totalHorizontalPadding: CGFloat {
        return Size.margins.left + Size.margins.right
    }

    fileprivate var totalVerticalPadding: CGFloat {
        return Size.margins.top + Size.margins.bottom
    }

    init(message: String? = nil, buttonAlignment: NSTextAlignment = .center) {
        self.textAlignment = buttonAlignment
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        headerView.label.text = message

        view.layer.masksToBounds = true
        view.layer.cornerRadius = Size.cornerRadius
        view.backgroundColor = .white
        tableView.backgroundColor = .clear
        headerView.label.textColor = .black
        headerView.backgroundColor = .white
    }

    required init(coder: NSCoder) {
        fatalError("This isn't implemented")
    }

    convenience init(error: String, handler: AlertHandler? = nil) {
        self.init(message: error)
        let action = AlertAction(title: InterfaceString.OK, style: .dark, handler: handler)
        addAction(action)
    }
}

extension AlertViewController {
    override func loadView() {
        view = UIView()
        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Size.margins.top).isActive = true
        view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Size.margins.bottom).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Size.margins.left).isActive = true
        view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: Size.margins.right).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderHeight = 22
        tableView.sectionFooterHeight = 22
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AlertCell.nib(), forCellReuseIdentifier: AlertCell.reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resize()

        keyboardWillShowObserver = NotificationObserver(notification: Keyboard.Notifications.KeyboardWillShow, block: self.keyboardUpdateFrame)
        keyboardWillHideObserver = NotificationObserver(notification: Keyboard.Notifications.KeyboardWillHide, block: self.keyboardUpdateFrame)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isScrollEnabled = (view.frame.height == Size.maxHeight)
        resize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardWillShowObserver?.removeObserver()
        keyboardWillShowObserver = nil
        keyboardWillHideObserver?.removeObserver()
        keyboardWillHideObserver = nil
    }

    func dismiss(action: AlertAction? = nil) {
        self.dismiss(animated: true) {
            if let action = action, action.waitForDismiss {
                action.handler?(action)
            }
        }
    }
}

extension AlertViewController {
    func addAction(_ action: AlertAction) {
        actions.append(action)
        inputs.append(action.initial)

        tableView.reloadData()
    }

    func resetActions() {
        actions = []
        inputs = []

        tableView.reloadData()
    }
}

extension AlertViewController {
    fileprivate func willSetContentView() {
        if let contentView = contentView {
            contentView.removeFromSuperview()
        }
    }

    fileprivate func didSetContentView() {
        if let contentView = contentView {
            self.tableView.isHidden = true
            self.view.addSubview(contentView)
        }
        else {
            self.tableView.isHidden = false
        }

        resize()
    }

    func resize() {
        self.view.frame.size = self.desiredSize
        if let superview = self.view.superview {
            self.view.center = superview.center
        }
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension AlertViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard presented == self
            else { return .none }

        return AlertPresentationController(presentedViewController: presented, presentingViewController: presenting, backgroundColor: self.modalBackgroundColor)
    }
}

// MARK: UITableViewDelegate
extension AlertViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let action = actions.safeValue(indexPath.row),
            action.isTappable
        else { return }

        // apparently iOS (9?) has a bug where main-queue updates take a long time. WTF.
        nextTick {
            let action = self.actions.safeValue(indexPath.row)

            if self.shouldAutoDismiss {
                self.dismiss(action: action)
            }

            if let action = action, !action.isInput, !action.waitForDismiss {
                action.handler?(action)
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if message.characters.count == 0 {
            return nil
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if message.characters.count == 0 {
            return 0
        }
        let size = CGSize(width: Size.width - totalHorizontalPadding, height: .greatestFiniteMagnitude)
        let height = headerView.sizeThatFits(size).height
        return height
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let action = actions.safeValue(indexPath.row)
        else { return 0 }

        return action.heightForWidth(Size.width)
    }
}

// MARK: UITableViewDataSource
extension AlertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlertCell.reuseIdentifier, for: indexPath) as! AlertCell

        guard let action = actions.safeValue(indexPath.row),
            let input = inputs.safeValue(indexPath.row)
        else { return cell }

        action.configure(cell, action, textAlignment)

        cell.input.text = input
        cell.onInputChanged = { text in
            self.inputs[indexPath.row] = text
        }

        return cell
    }
}

extension AlertViewController: AlertCellResponder {

    func tappedOkButton() {
        let action = actions.find({ action in
            switch action.style {
            case .okCancel: return true
            default: return false
            }
        })

        dismiss(action: action)
        if let action = action, !action.waitForDismiss {
            action.handler?(action)
        }
    }

    func tappedCancelButton() {
        dismiss()
    }
}
