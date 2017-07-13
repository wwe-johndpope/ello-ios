////
///  StreamGenerator.swift
//

protocol StreamGenerator {

    func load(reload: Bool)

    var currentUser: User? { get }
    var streamKind: StreamKind { get }
    weak var destination: StreamDestination? { get }
}

extension StreamGenerator {

    func parse(jsonables: [JSONAble], forceGrid: Bool = false) -> [StreamCellItem] {
        return StreamCellItemParser().parse(jsonables, streamKind: self.streamKind, forceGrid: forceGrid, currentUser: self.currentUser)
    }
}

protocol StreamDestination: class {
    func setPlaceholders(items: [StreamCellItem])
    func replacePlaceholder(type: StreamCellType.PlaceholderType, items: [StreamCellItem], completion: @escaping Block)
    func setPrimary(jsonable: JSONAble)
    func primaryJSONAbleNotFound()
    func setPagingConfig(responseConfig: ResponseConfig)
    var pagingEnabled: Bool { get set }
}
