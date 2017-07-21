////
///  StreamKindSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Moya


class StreamKindSpec: QuickSpec {

    override func spec() {

        describe("StreamKind") {

            // TODO: convert these tests to the looping input/output style used on other enums

            describe("name") {

                it("is correct for all cases") {
                    expect(StreamKind.discover(type: .featured).name) == "Discover"
                    expect(StreamKind.following.name) == "Following"
                    expect(StreamKind.notifications(category: "").name) == "Notifications"
                    expect(StreamKind.postDetail(postParam: "param").name) == ""
                    expect(StreamKind.currentUserStream.name) == "Profile"
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").name) == "meat"
                    expect(StreamKind.unknown.name) == ""
                    expect(StreamKind.userStream(userParam: "n/a").name) == ""
                }
            }

            describe("cacheKey") {

                it("is correct for all cases") {
                    expect(StreamKind.discover(type: .featured).cacheKey) == "CategoryPosts"
                    expect(StreamKind.category(slug: "art").cacheKey) == "CategoryPosts"
                    expect(StreamKind.following.cacheKey) == "Following"
                    expect(StreamKind.notifications(category: "").cacheKey) == "Notifications"
                    expect(StreamKind.postDetail(postParam: "param").cacheKey) == "PostDetail"
                    expect(StreamKind.currentUserStream.cacheKey) == "Profile"
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").cacheKey) == "SearchForPosts"
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForUsers(terms: "meat"), title: "meat").cacheKey) == "SimpleStream.meat"
                    expect(StreamKind.unknown.cacheKey) == "unknown"
                    expect(StreamKind.userStream(userParam: "NA").cacheKey) == "UserStream"
                }
            }

            describe("lastViewedCreatedAtKey") {

                it("is correct for all cases") {
                    expect(StreamKind.discover(type: .featured).lastViewedCreatedAtKey) == "Discover_featured_createdAt"
                    expect(StreamKind.category(slug: "art").lastViewedCreatedAtKey) == "Category_art_createdAt"
                    expect(StreamKind.following.lastViewedCreatedAtKey) == "Following_createdAt"
                    expect(StreamKind.notifications(category: "").lastViewedCreatedAtKey) == "Notifications_createdAt"
                    expect(StreamKind.postDetail(postParam: "param").lastViewedCreatedAtKey).to(beNil())
                    expect(StreamKind.currentUserStream.lastViewedCreatedAtKey).to(beNil())
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").lastViewedCreatedAtKey).to(beNil())
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForUsers(terms: "meat"), title: "meat").lastViewedCreatedAtKey).to(beNil())
                    expect(StreamKind.unknown.lastViewedCreatedAtKey).to(beNil())
                    expect(StreamKind.userStream(userParam: "NA").lastViewedCreatedAtKey).to(beNil())
                }
            }

            describe("showsCategory") {
                let expectations: [(StreamKind, Bool)] = [
                    (.currentUserStream, false),
                    (.allCategories, false),
                    (.discover(type: .featured), true),
                    (.discover(type: .trending), false),
                    (.discover(type: .recent), false),
                    (.category(slug: "art"), false),
                    (.following, false),
                    (.notifications(category: nil), false),
                    (.notifications(category: "comments"), false),
                    (.postDetail(postParam: "postId"), false),
                    (.userStream(userParam: "userId"), false),
                    (.unknown, false),
                ]
                for (streamKind, expectedValue) in expectations {
                    it("\(streamKind) \(expectedValue ? "can" : "cannot") show category") {
                        expect(streamKind.showsCategory) == expectedValue
                    }
                }
            }

            describe("isProfileStream") {
                let expectations: [(StreamKind, Bool)] = [
                    (.discover(type: .featured), false),
                    (.category(slug: "art"), false),
                    (.following, false),
                    (.notifications(category: ""), false),
                    (.postDetail(postParam: "param"), false),
                    (.currentUserStream, true),
                    (.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat"), false),
                    (.unknown, false),
                    (.userStream(userParam: "NA"), true),
                ]
                for (streamKind, expected) in expectations {
                    it("is \(expected) for \(streamKind)") {
                        expect(streamKind.isProfileStream) == expected
                    }
                }
            }

            describe("endpoint") {

                it("is correct for all cases") {
                    expect(StreamKind.discover(type: .featured).endpoint.path) == "/api/\(ElloAPI.apiVersion)/categories/posts/recent"
                    expect(StreamKind.category(slug: "art").endpoint.path) == "/api/\(ElloAPI.apiVersion)/categories/art"
                    expect(StreamKind.following.endpoint.path) == "/api/\(ElloAPI.apiVersion)/following/posts/recent"
                    expect(StreamKind.notifications(category: "").endpoint.path) == "/api/\(ElloAPI.apiVersion)/notifications"
                    expect(StreamKind.postDetail(postParam: "param").endpoint.path) == "/api/\(ElloAPI.apiVersion)/posts/param"
                    expect(StreamKind.postDetail(postParam: "param").endpoint.parameters!["comment_count"] as? Int) == 10
                    expect(StreamKind.currentUserStream.endpoint.path) == "/api/\(ElloAPI.apiVersion)/profile"
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").endpoint.path) == "/api/\(ElloAPI.apiVersion)/posts"
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForUsers(terms: "meat"), title: "meat").endpoint.path) == "/api/\(ElloAPI.apiVersion)/users"
                    expect(StreamKind.unknown.endpoint.path) == "/api/\(ElloAPI.apiVersion)/notifications"
                    expect(StreamKind.userStream(userParam: "NA").endpoint.path) == "/api/\(ElloAPI.apiVersion)/users/NA"
                }
            }

            describe("relationship") {

                it("is correct for all cases") {
                    expect(StreamKind.discover(type: .featured).relationship) == RelationshipPriority.null
                    expect(StreamKind.category(slug: "art").relationship) == RelationshipPriority.null
                    expect(StreamKind.following.relationship) == RelationshipPriority.following
                    expect(StreamKind.notifications(category: "").relationship) == RelationshipPriority.null
                    expect(StreamKind.postDetail(postParam: "param").relationship) == RelationshipPriority.null
                    expect(StreamKind.currentUserStream.relationship) == RelationshipPriority.null
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").relationship) == RelationshipPriority.null
                    expect(StreamKind.unknown.relationship) == RelationshipPriority.null
                    expect(StreamKind.userStream(userParam: "NA").relationship) == RelationshipPriority.null
                }
            }

            describe("filter(_:viewsAdultContent:)") {
                // important but time consuming to implement this one, little by little!
                context("Discover") {

                    var postJsonables: [JSONAble] = []

                    beforeEach {
                        let post1 = Post.stub(["id": "post1", "isAdultContent": true])
                        let post2 = Post.stub(["id": "post2"])
                        let post3 = Post.stub(["id": "post3"])

                        postJsonables = [post1, post2, post3]
                    }

                    context("Discover(recommended)") {
                        it("returns the correct posts regardless of views adult content") {
                            let kind = StreamKind.discover(type: .featured)
                            var filtered = kind.filter(postJsonables, viewsAdultContent: false) as! [Post]

                            expect(filtered.count) == 3
                            expect(filtered[0].id) == "post1"
                            expect(filtered[1].id) == "post2"
                            expect(filtered[2].id) == "post3"

                            filtered = kind.filter(postJsonables, viewsAdultContent: true) as! [Post]

                            expect(filtered.count) == 3
                            expect(filtered[0].id) == "post1"
                            expect(filtered[1].id) == "post2"
                            expect(filtered[2].id) == "post3"
                        }
                    }

                    context("Discover(trending)") {
                        it("returns the correct posts regardless of views adult content") {
                            let kind = StreamKind.discover(type: .trending)
                            var filtered = kind.filter(postJsonables, viewsAdultContent: false) as! [Post]

                            expect(filtered.count) == 3
                            expect(filtered[0].id) == "post1"
                            expect(filtered[1].id) == "post2"
                            expect(filtered[2].id) == "post3"

                            filtered = kind.filter(postJsonables, viewsAdultContent: true) as! [Post]

                            expect(filtered.count) == 3
                            expect(filtered[0].id) == "post1"
                            expect(filtered[1].id) == "post2"
                            expect(filtered[2].id) == "post3"
                        }
                    }

                    context("Discover(recent)") {
                        it("returns the correct posts regardless of views adult content") {
                            let kind = StreamKind.discover(type: .recent)
                            var filtered = kind.filter(postJsonables, viewsAdultContent: false) as! [Post]

                            expect(filtered.count) == 3
                            expect(filtered[0].id) == "post1"
                            expect(filtered[1].id) == "post2"
                            expect(filtered[2].id) == "post3"

                            filtered = kind.filter(postJsonables, viewsAdultContent: true) as! [Post]

                            expect(filtered.count) == 3
                            expect(filtered[0].id) == "post1"
                            expect(filtered[1].id) == "post2"
                            expect(filtered[2].id) == "post3"
                        }
                    }
                }
            }

            describe("isGridView") {

                beforeEach {
                    StreamKind.discover(type: .featured).setIsGridView(false)
                    StreamKind.category(slug: "art").setIsGridView(false)
                    StreamKind.following.setIsGridView(false)
                    StreamKind.notifications(category: "").setIsGridView(false)
                    StreamKind.postDetail(postParam: "param").setIsGridView(false)
                    StreamKind.currentUserStream.setIsGridView(false)
                    StreamKind.following.setIsGridView(false)
                    StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").setIsGridView(false)
                    StreamKind.simpleStream(endpoint: ElloAPI.loves(userId: "123"), title: "123").setIsGridView(false)
                    StreamKind.unknown.setIsGridView(false)
                    StreamKind.userStream(userParam: "NA").setIsGridView(false)
                }


                it("is correct for all cases") {
                    StreamKind.discover(type: .featured).setIsGridView(true)
                    expect(StreamKind.discover(type: .featured).isGridView) == true

                    StreamKind.discover(type: .featured).setIsGridView(false)
                    expect(StreamKind.discover(type: .featured).isGridView) == false

                    StreamKind.category(slug: "art").setIsGridView(true)
                    expect(StreamKind.category(slug: "art").isGridView) == true

                    StreamKind.category(slug: "art").setIsGridView(false)
                    expect(StreamKind.category(slug: "art").isGridView) == false

                    StreamKind.following.setIsGridView(false)
                    expect(StreamKind.following.isGridView) == false

                    StreamKind.following.setIsGridView(true)
                    expect(StreamKind.following.isGridView) == true

                    expect(StreamKind.notifications(category: "").isGridView) == false
                    expect(StreamKind.postDetail(postParam: "param").isGridView) == false
                    expect(StreamKind.currentUserStream.isGridView) == false

                    StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").setIsGridView(true)
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").isGridView) == true

                    StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").setIsGridView(false)
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").isGridView) == false

                    StreamKind.simpleStream(endpoint: ElloAPI.loves(userId: "123"), title: "123").setIsGridView(true)
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.loves(userId: "123"), title: "123").isGridView) == true

                    StreamKind.simpleStream(endpoint: ElloAPI.loves(userId: "123"), title: "123").setIsGridView(false)
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.loves(userId: "123"), title: "123").isGridView) == false

                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForUsers(terms: "meat"), title: "meat").isGridView) == false
                    expect(StreamKind.unknown.isGridView) == false
                    expect(StreamKind.userStream(userParam: "NA").isGridView) == false
                }
            }

            describe("hasGridViewToggle") {

                it("is correct for all cases") {
                    expect(StreamKind.discover(type: .featured).hasGridViewToggle) == true
                    expect(StreamKind.category(slug: "art").hasGridViewToggle) == true
                    expect(StreamKind.following.hasGridViewToggle) == true
                    expect(StreamKind.notifications(category: "").hasGridViewToggle) == false
                    expect(StreamKind.postDetail(postParam: "param").hasGridViewToggle) == false
                    expect(StreamKind.currentUserStream.hasGridViewToggle) == false
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").hasGridViewToggle) == true
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.loves(userId: "123"), title: "123").hasGridViewToggle) == true
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForUsers(terms: "meat"), title: "meat").hasGridViewToggle) == false
                    expect(StreamKind.unknown.hasGridViewToggle) == false
                    expect(StreamKind.userStream(userParam: "NA").hasGridViewToggle) == false
                }
            }

            describe("isDetail") {

                it("is correct for all cases") {
                    expect(StreamKind.discover(type: .featured).isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.category(slug: "art").isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.following.isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.notifications(category: "").isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.postDetail(postParam: "param").isDetail(post: Post.stub(["token": "param"]))) == true
                    expect(StreamKind.postDetail(postParam: "param").isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.currentUserStream.isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForUsers(terms: "meat"), title: "meat").isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.unknown.isDetail(post: Post.stub([:]))) == false
                    expect(StreamKind.userStream(userParam: "NA").isDetail(post: Post.stub([:]))) == false
                }
            }

            describe("supportsLargeImages") {

                it("is correct for all cases") {
                    expect(StreamKind.discover(type: .featured).supportsLargeImages) == false
                    expect(StreamKind.category(slug: "art").supportsLargeImages) == false
                    expect(StreamKind.following.supportsLargeImages) == false
                    expect(StreamKind.notifications(category: "").supportsLargeImages) == false
                    expect(StreamKind.postDetail(postParam: "param").supportsLargeImages) == true
                    expect(StreamKind.currentUserStream.supportsLargeImages) == false
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForPosts(terms: "meat"), title: "meat").supportsLargeImages) == false
                    expect(StreamKind.simpleStream(endpoint: ElloAPI.searchForUsers(terms: "meat"), title: "meat").supportsLargeImages) == false
                    expect(StreamKind.unknown.supportsLargeImages) == false
                    expect(StreamKind.userStream(userParam: "NA").supportsLargeImages) == false
                }
            }
        }
    }
}
