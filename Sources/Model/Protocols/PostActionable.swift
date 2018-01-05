////
///  PostActionable.swift
//


protocol PostActionable: class {
    var postId: String { get }
    var post: Post? { get }
    var user: User? { get }
}
