////
///  RelationshipController.swift
//

typealias RelationshipChangeClosure = (_ relationshipPriority: RelationshipPriority) -> Void
typealias RelationshipChangeCompletion = (_ status: RelationshipRequestStatus, _ relationship: Relationship?, _ isFinalValue: Bool) -> Void

class RelationshipRequestStatusWrapper: NSObject {
    let status: RelationshipRequestStatus
    init(status: RelationshipRequestStatus) { self.status = status }
}

enum RelationshipRequestStatus: String {
    case success = "success"
    case failure = "failure"
}

@objc
protocol RelationshipControllerResponder: class {
    func shouldSubmitRelationship(_ userId: String, relationshipPriority: RelationshipPriorityWrapper) -> Bool
    func relationshipChanged(_ userId: String, status: RelationshipRequestStatusWrapper, relationship: Relationship?)
}

protocol RelationshipDelegate: class {
    func relationshipTapped(_ userId: String, prev prevRelationshipPriority: RelationshipPriority, relationshipPriority: RelationshipPriority, complete: @escaping RelationshipChangeCompletion)
    func launchBlockModal(_ userId: String, userAtName: String, relationshipPriority: RelationshipPriority, changeClosure: @escaping RelationshipChangeClosure)
    func updateRelationship(_ currentUserId: String, userId: String, prev prevRelationshipPriority: RelationshipPriority, relationshipPriority: RelationshipPriority, complete: @escaping RelationshipChangeCompletion)
}

class RelationshipController: UIResponder {
    var currentUser: User?
    weak var presentingController: StreamViewController?

    required init(presentingController: StreamViewController) {
        self.presentingController = presentingController
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var next: UIResponder? {
        return presentingController?.nextAfterRelationshipController
    }

}

// MARK: RelationshipController: RelationshipDelegate
extension RelationshipController: RelationshipDelegate {
    func relationshipTapped(_ userId: String, prev prevRelationshipPriority: RelationshipPriority, relationshipPriority: RelationshipPriority, complete: @escaping RelationshipChangeCompletion) {
        Tracker.shared.relationshipButtonTapped(relationshipPriority, userId: userId)
        let responder = self.target(forAction: #selector(RelationshipControllerResponder.shouldSubmitRelationship(_:relationshipPriority:)), withSender: self) as? RelationshipControllerResponder
        if let shouldSubmit = responder?.shouldSubmitRelationship(userId, relationshipPriority: RelationshipPriorityWrapper(priority: relationshipPriority)), !shouldSubmit {
            let relationship = Relationship(id: UUID().uuidString, createdAt: Date(), ownerId: "", subjectId: userId)
            complete(.success, relationship, true)
            return
        }

        if let currentUserId = currentUser?.id {
            self.updateRelationship(currentUserId, userId: userId, prev: prevRelationshipPriority, relationshipPriority: relationshipPriority, complete: complete)
        }
    }

    func launchBlockModal(_ userId: String, userAtName: String, relationshipPriority: RelationshipPriority, changeClosure: @escaping RelationshipChangeClosure) {
        let vc = BlockUserModalViewController(config: BlockUserModalConfig(userId: userId, userAtName: userAtName, relationshipPriority: relationshipPriority, changeClosure: changeClosure))
        vc.currentUser = currentUser
        vc.relationshipDelegate = self
        presentingController?.present(vc, animated: true, completion: nil)
    }

    func updateRelationship(_ currentUserId: String, userId: String, prev prevPriority: RelationshipPriority, relationshipPriority newRelationshipPriority: RelationshipPriority, complete: @escaping RelationshipChangeCompletion) {
        var prevRelationshipPriority = prevPriority
        RelationshipService().updateRelationship(currentUserId: currentUserId, userId: userId, relationshipPriority: newRelationshipPriority,
            success: {[weak self] (data, responseConfig) in
                guard let `self` = self else { return }
                if let relationship = data as? Relationship {
                    complete(.success, relationship, responseConfig.isFinalValue)

                    let responder = self.target(forAction: #selector(RelationshipControllerResponder.relationshipChanged(_:status:relationship:)), withSender: self) as? RelationshipControllerResponder
                    responder?.relationshipChanged(userId, status: RelationshipRequestStatusWrapper(status: .success), relationship: relationship)
                    if responseConfig.isFinalValue {
                        if let owner = relationship.owner {
                            postNotification(RelationshipChangedNotification, value: owner)
                        }
                        if let subject = relationship.subject {
                            postNotification(RelationshipChangedNotification, value: subject)
                        }
                    }
                }
                else {
                    complete(.success, nil, responseConfig.isFinalValue)
                    let responder = self.target(forAction: #selector(RelationshipControllerResponder.relationshipChanged(_:status:relationship:)), withSender: self) as? RelationshipControllerResponder
                    responder?.relationshipChanged(userId, status: RelationshipRequestStatusWrapper(status: .success), relationship: nil)

                }

                if prevRelationshipPriority != newRelationshipPriority {
                    var blockDelta = 0
                    if prevRelationshipPriority == .block { blockDelta -= 1 }
                    if newRelationshipPriority == .block { blockDelta += 1 }
                    if blockDelta != 0 {
                        postNotification(BlockedCountChangedNotification, value: (userId, blockDelta))
                    }

                    var mutedDelta = 0
                    if prevRelationshipPriority == .mute { mutedDelta -= 1 }
                    if newRelationshipPriority == .mute { mutedDelta += 1 }
                    if mutedDelta != 0 {
                        postNotification(MutedCountChangedNotification, value: (userId, mutedDelta))
                    }

                    prevRelationshipPriority = newRelationshipPriority
                }
            },
            failure: {[weak self] (error, statusCode) in
                guard let `self` = self else { return }
                complete(.failure, nil, true)
                let responder = self.target(forAction: #selector(RelationshipControllerResponder.relationshipChanged(_:status:relationship:)), withSender: self) as? RelationshipControllerResponder
                responder?.relationshipChanged(userId, status: RelationshipRequestStatusWrapper(status: .failure), relationship: nil)
            })
    }
}
