////
///  DrawerViewDataSource.swift
//

struct DrawerItem {
    let name: String
    let type: DrawerItemType
    let tracking: String?

    init(name: String, type: DrawerItemType, tracking: String? = nil) {
        self.name = name
        self.type = type
        self.tracking = tracking
    }
}

enum DrawerItemType {
    case external(String)
    case invite
    case logout
    case version
    case debugger
}

class DrawerViewDataSource: NSObject {
    lazy var items: [DrawerItem] = self.drawerItems()

    // moved into a separate function to save compile time
    private func drawerItems() -> [DrawerItem] {
        var items: [DrawerItem] = [
            DrawerItem(name: InterfaceString.Drawer.Invite, type: .invite, tracking: "invite"),
            DrawerItem(name: InterfaceString.Drawer.Store, type: .external("http://store.ello.co/"), tracking: "store"),
            DrawerItem(name: InterfaceString.Drawer.Help, type: .external("https://ello.co/wtf/"), tracking: "help"),
            DrawerItem(name: InterfaceString.Drawer.Logout, type: .logout, tracking: "logout"),
        ]
        if AuthToken().isStaff {
            items.append(DrawerItem(name: "Show Debugger", type: .debugger))
        }
        items.append(DrawerItem(name: InterfaceString.Drawer.Version, type: .version))
        return items
    }

    func itemForIndexPath(_ indexPath: IndexPath) -> DrawerItem? {
        return items.safeValue(indexPath.row)
    }
}

// MARK: UITableViewDataSource
extension DrawerViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DrawerCell.reuseIdentifier, for: indexPath) as! DrawerCell
        if let item = items.safeValue(indexPath.row) {
            DrawerCellPresenter.configure(cell, item: item)
        }
        return cell
    }
}
