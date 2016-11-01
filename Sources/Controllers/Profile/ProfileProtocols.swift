////
///  ProfileProtocols.swift
//

public protocol ProfileViewProtocol: class {}

public protocol ProfileScreenProtocol: StreamableScreenProtocol {
    func disableButtons()
    func enableButtons()
    func showNavBars()
    func hideNavBars(offset: CGPoint, isCurrentUser: Bool)
    func configureButtonsForCurrentUser()
    func configureButtonsForNonCurrentUser(isHireable isHireable: Bool, isCollaborateable: Bool)
    func resetCoverImage()
    func updateHeaderHeightConstraints(max max: CGFloat, scrollAdjusted: CGFloat)
    func updateRelationshipControl(user user: User)
    func updateRelationshipPriority(relationshipPriority: RelationshipPriority)
    var relationshipDelegate: RelationshipDelegate? { get set }
    var navBar: ElloNavigationBar { get }
    var profileButtonsContainer: UIView { get }
    var coverImage: UIImage? { get set }
    var coverImageURL: NSURL? { get set }
}

public protocol ProfileScreenDelegate: class {
    func mentionTapped()
    func hireTapped()
    func editTapped()
    func inviteTapped()
    func collaborateTapped()
}

