import Foundation

public protocol StreamGenerator {

    func load(reload reload: Bool)

    var currentUser: User? { get }
    var streamKind: StreamKind { get }
    weak var destination: StreamDestination? { get }
}

extension StreamGenerator {

    func parse(jsonables: [JSONAble]) -> [StreamCellItem] {
        return StreamCellItemParser().parse(jsonables, streamKind: self.streamKind, currentUser: self.currentUser)
    }
}

public protocol StreamDestination: class {
    func setPlaceholders(items: [StreamCellItem])
    func replacePlaceholder(type: StreamCellType.PlaceholderType, @autoclosure items: () -> [StreamCellItem], completion: ElloEmptyCompletion)
    func setPrimaryJSONAble(jsonable: JSONAble)
    func primaryJSONAbleNotFound()
    func secondaryJSONAbleNotFound()
    func setPagingConfig(responseConfig: ResponseConfig)
    var pagingEnabled: Bool { get set }
}
