////
///  CreateProfileProtocols.swift
//

protocol CreateProfileDelegate: class {
    func presentController(controller: UIViewController)
    func dismissController()

    func assignName(name: String?) -> ValidationState
    func assignBio(bio: String?) -> ValidationState
    func assignLinks(links: String?) -> ValidationState
    func assignCoverImage(image: ImageRegionData)
    func assignAvatar(image: ImageRegionData)
}

protocol CreateProfileScreenProtocol: class {
    var name: String? { get set }
    var bio: String? { get set }
    var links: String? { get set }
    var linksValid: Bool? { get set }
    var coverImage: ImageRegionData? { get set }
    var avatarImage: ImageRegionData? { get set }
}
