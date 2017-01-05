////
///  DebugTrackingController.swift
//

#if DEBUG

import SnapKit

class DebugTrackingController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    var tracker: DebugAgent! { return Tracker.shared.overrideAgent as! DebugAgent }

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Action")
        view.addSubview(tableView)

        tracker.logView.removeFromSuperview()

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracker.log.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tracking Events"
    }

    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Action")
        if let label = cell.textLabel, let log = tracker.log.safeValue(path.row) {
            let header = NSAttributedString(log.1, font: UIFont.defaultBoldFont())
            let type = NSAttributedString(" \(log.0)", font: UIFont.defaultFont())
            label.attributedText = header + type
            cell.detailTextLabel?.text = log.2 ?? ""
        }
        return cell
    }

}

class DebugAgent: AnalyticsAgent {
    typealias Entry = (String, String, String?)
    var log: [Entry] = []
    let logView = UITextView()

    init() {
        logView.font = .defaultFont()
        logView.textColor = .white
        logView.backgroundColor = .black
        logView.isUserInteractionEnabled = false
        logView.alpha = 0.5
    }

    private func describe(_ props: [AnyHashable: Any]) -> String {
        var retval = "{"
        var first = true
        for (key, value) in props {
            if !first {
                retval += "; "
            }
            retval += "\(key): \(value)"
            first = false
        }
        retval += "}"
        return retval
    }

    private func append(_ entry: Entry) {
        if logView.superview == nil {
            UIWindow.mainWindow.addSubview(logView)
            logView.frame = UIWindow.mainWindow.bounds.fromTop().grow(down: ElloTabBar.Size.height)
        }
        else {
            UIWindow.mainWindow.bringSubview(toFront: logView)
        }

        log.append(entry)
        var line = entry.1
        if let props = entry.2 {
            line += " \(props)"
        }
        logView.text = (logView.text ?? "") + "\n\(line)"
        let contentOffsetY: CGFloat = logView.contentSize.height - logView.frame.size.height
        if contentOffsetY > 0 {
            logView.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: true)
        }
    }

    func identify(_ userId: String!, traits: [AnyHashable: Any]!) {
        append(("User Id", userId, describe(traits)))
    }

    func track(_ event: String!) {
        append(("Event", event, nil))
    }

    func track(_ event: String!, properties: [AnyHashable: Any]!) {
        if let properties = properties {
            append(("Event", event, describe(properties)))
        }
        else {
            track(event)
        }
    }

    func screen(_ screenTitle: String!) {
        append(("Screen", screenTitle, nil))
    }

    func screen(_ screenTitle: String!, properties: [AnyHashable: Any]!) {
        if let properties = properties {
            append(("Screen", screenTitle, describe(properties)))
        }
        else {
            screen(screenTitle)
        }
    }
}

#endif
