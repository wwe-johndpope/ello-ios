////
///  StreamableScreen.swift
//

public protocol StreamableScreenProtocol: class {
    var navigationBarTopConstraint: NSLayoutConstraint! { get }
    var navigationBar: ElloNavigationBar { get }
    var navigationItem: UINavigationItem? { get set }
}

public class StreamableScreen: Screen, StreamableScreenProtocol {
    public let navigationBar = ElloNavigationBar()
    public var navigationBarTopConstraint: NSLayoutConstraint!
    let streamContainer = UIView()

    public var navigationItem: UINavigationItem? {
        get { return navigationBar.items?.first }
        set {
            navigationBar.items = newValue.flatMap { [$0] }
        }
    }

    convenience init() {
        self.init(frame: UIScreen.mainScreen().bounds)
    }

    override func arrange() {
        super.arrange()

        addSubview(streamContainer)
        addSubview(navigationBar)

        navigationBar.snp_makeConstraints { make in
            let c = make.top.equalTo(self).constraint
            self.navigationBarTopConstraint = c.layoutConstraints.first!
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }
        streamContainer.snp_makeConstraints { make in
            make.edges.equalTo(self)
            streamContainer.frame = self.bounds
        }

        layoutIfNeeded()
    }
}
