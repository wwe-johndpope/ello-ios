////
///  ElloAPISpec.swift
//

import Foundation

import Ello
import Quick
import Moya
import Nimble


class ElloAPISpec: QuickSpec {
    override func spec() {

        var provider: MoyaProvider<ElloAPI>!

        beforeEach {
            provider = ElloProvider.StubbingProvider()
        }

        afterEach {
            provider = ElloProvider.DefaultProvider()
        }

        describe("ElloAPI") {
            describe("paths") {

                context("are valid") {
                    let expectations: [(ElloAPI, String)] = [
                        (.AmazonCredentials, "/api/v2/assets/credentials"),
                        (.Auth(email: "", password: ""), "/api/oauth/token"),
                        (.Availability(content: [:]), "/api/v2/availability"),
                        (.Categories, "/api/v2/categories"),
                        (.Category(slug: "art"), "/api/v2/categories/art"),
                        (.CategoryPosts(slug: "art"), "/api/v2/categories/art/posts/recent"),
                        (.CreatePost(body: [:]), "/api/v2/posts"),
                        (.Discover(type: .Featured), "/api/v2/categories/posts/recent"),
                        (.Discover(type: .Trending), "/api/v2/discover/users/trending"),
                        (.Discover(type: .Recent), "/api/v2/discover/posts/recent"),
                        (.FlagComment(postId: "555", commentId: "666", kind: "some-string"), "/api/v2/posts/555/comments/666/flag/some-string"),
                        (.FlagPost(postId: "456", kind: "another-kind"), "/api/v2/posts/456/flag/another-kind"),
                        (.FindFriends(contacts: [:]), "/api/v2/profile/find_friends"),
                        (.FriendStream, "/api/v2/streams/friend"),
                        (.InviteFriends(contact: "someContact"), "/api/v2/invitations"),
                        (ElloAPI.InfiniteScroll(queryItems: []) { return ElloAPI.FriendStream }, "/api/v2/streams/friend"),
                        (.NoiseStream, "/api/v2/streams/noise"),
                        (.NotificationsStream(category: nil), "/api/v2/notifications"),
                        (.PostDetail(postParam: "some-param", commentCount: 10), "/api/v2/posts/some-param"),
                        (.PostComments(postId: "fake-id"), "/api/v2/posts/fake-id/comments"),
                        (.CurrentUserStream, "/api/v2/profile"),
                        (.ProfileUpdate(body: [:]), "/api/v2/profile"),
                        (.ProfileDelete, "/api/v2/profile"),
                        (.ReAuth(token: ""), "/api/oauth/token"),
                        (.Relationship(userId: "1234", relationship: "friend"), "/api/v2/users/1234/add/friend"),
                        (.UserCategories(categoryIds: ["1"]), "/api/v2/profile/followed_categories"),
                        (.UserStream(userParam: "999"), "/api/v2/users/999"),
                        (.UserStreamFollowers(userId: "321"), "/api/v2/users/321/followers"),
                        (.UserStreamFollowing(userId: "123"), "/api/v2/users/123/following"),
                        (.DeletePost(postId: "666"), "/api/v2/posts/666"),
                        (.DeleteComment(postId: "666", commentId: "777"), "/api/v2/posts/666/comments/777"),
                    ]
                    for (api, path) in expectations {
                        it("\(api).path is valid") {
                            expect(api.path) == path
                        }
                    }
                }
            }

            describe("mappingType") {

                let currentUserId = "123"

                let expectations: [(ElloAPI, MappingType)] = [
                    (.AmazonCredentials, .AmazonCredentialsType),
                    (.AnonymousCredentials, .ErrorType),
                    (.Auth(email: "", password: ""), .ErrorType),
                    (.Availability(content: ["":""]), .AvailabilityType),
                    (.CommentDetail(postId: "", commentId: ""), .CommentsType),
                    (.Categories, .CategoriesType),
                    (.CreateComment(parentPostId: "", body: ["": ""]), .CommentsType),
                    (.CreateLove(postId: ""), .LovesType),
                    (.CreatePost(body: ["": ""]), .PostsType),
                    (.CurrentUserProfile, .UsersType),
                    (.CurrentUserStream, .UsersType),
                    (.DeleteComment(postId: "", commentId: ""), .ErrorType),
                    (.DeleteLove(postId: ""), .NoContentType),
                    (.DeletePost(postId: ""), .ErrorType),
                    (.DeleteSubscriptions(token: NSData()), .NoContentType),
                    (.Discover(type: .Featured), .PostsType),
                    (.Discover(type: .Trending), .UsersType),
                    (.Discover(type: .Recent), .PostsType),
                    (.CategoryPosts(slug: "art"), .PostsType),
                    (.EmojiAutoComplete(terms: ""), .AutoCompleteResultType),
                    (.FindFriends(contacts: ["": [""]]), .UsersType),
                    (.FlagComment(postId: "", commentId: "", kind: ""), .NoContentType),
                    (.FlagPost(postId: "", kind: ""), .NoContentType),
                    (.FriendStream, .ActivitiesType),
                    (.FriendNewContent(createdAt: NSDate()), .ErrorType),
                    (.InfiniteScroll(queryItems: [""], elloApi: { return ElloAPI.AmazonCredentials }), .AmazonCredentialsType),
                    (.InviteFriends(contact: ""), .NoContentType),
                    (.Join(email: "", username: "", password: "", invitationCode: ""), .UsersType),
                    (.Loves(userId: ""), .LovesType),
                    (.Loves(userId: currentUserId), .LovesType),
                    (.NoiseStream, .ActivitiesType),
                    (.NoiseNewContent(createdAt: NSDate()), .ErrorType),
                    (.NotificationsNewContent(createdAt: NSDate()), .ErrorType),
                    (.NotificationsStream(category: ""), .ActivitiesType),
                    (.PostComments(postId: ""), .CommentsType),
                    (.PostDetail(postParam: "", commentCount: 0), .PostsType),
                    (.PostLovers(postId: ""), .UsersType),
                    (.PostReposters(postId: ""), .UsersType),
                    (.ProfileDelete, .NoContentType),
                    (.ProfileToggles, .DynamicSettingsType),
                    (.ProfileUpdate(body: ["": ""]), .UsersType),
                    (.PushSubscriptions(token: NSData()), .NoContentType),
                    (.ReAuth(token: ""), .ErrorType),
                    (.RePost(postId: ""), .PostsType),
                    (.Relationship(userId: "", relationship: ""), .RelationshipsType),
                    (.RelationshipBatch(userIds: [""], relationship: ""), .NoContentType),
                    (.SearchForUsers(terms: ""), .UsersType),
                    (.SearchForPosts(terms: ""), .PostsType),
                    (.UpdatePost(postId: "", body: ["": ""]), .PostsType),
                    (.UpdateComment(postId: "", commentId: "", body: ["": ""]), .CommentsType),
                    (.UserCategories(categoryIds: [""]), .NoContentType),
                    (.UserStream(userParam: ""), .UsersType),
                    (.UserStream(userParam: currentUserId), .UsersType),
                    (.UserStreamFollowers(userId: ""), .UsersType),
                    (.UserStreamFollowing(userId: ""), .UsersType),
                    (.UserNameAutoComplete(terms: ""), .AutoCompleteResultType)
                ]
                for (endpoint, mappingType) in expectations {
                    it("\(endpoint.description) has the correct mappingType \(mappingType)") {
                        expect(endpoint.mappingType) == mappingType
                    }
                }
            }

            describe("pagingPaths") {

                context("are valid") {
                    let expectations: [(ElloAPI, String)] = [
                        (.Category(slug: "art"), "/api/v2/categories/art/posts/recent"),
                        (.PostDetail(postParam: "some-param", commentCount: 10), "/api/v2/posts/some-param/comments"),
                        (.CurrentUserStream, "/api/v2/profile/posts"),
                        (.UserStream(userParam: "999"), "/api/v2/users/999/posts"),
                    ]
                    for (api, path) in expectations {
                        it("\(api).path is valid") {
                            expect(api.path) == path
                        }
                    }
                }
            }

            describe("headers") {

                context("Accept-Language endpoints") {
                    let endpoints: [ElloAPI] = [
                        .AmazonCredentials,
                        .AnonymousCredentials,
                        .Auth(email: "", password: ""),
                        .Availability(content: [:]),
                        .CreateComment(parentPostId: "", body: [:]),
                        .CreateLove(postId: ""),
                        .CreatePost(body: [:]),
                        .DeleteComment(postId: "", commentId: ""),
                        .DeleteLove(postId: ""),
                        .DeletePost(postId: ""),
                        .DeleteSubscriptions(token: NSData()),
                        .Discover(type: .Trending),
                        .CategoryPosts(slug: ""),
                        .EmojiAutoComplete(terms: ""),
                        .FindFriends(contacts: [:]),
                        .FlagComment(postId: "", commentId: "", kind: ""),
                        .FlagPost(postId: "", kind: ""),
                        .FriendNewContent(createdAt: NSDate()),
                        .FriendStream,
                        .InfiniteScroll(queryItems: [""], elloApi: { () -> ElloAPI in
                            return ElloAPI.Auth(email: "", password: "")
                        }),
                        .InfiniteScroll(queryItems: [""], elloApi: { () -> ElloAPI in
                            return ElloAPI.FriendStream
                        }),
                        .InviteFriends(contact: ""),
                        .Join(email: "", username: "", password: "", invitationCode: ""),
                        .Loves(userId: ""),
                        .NoiseNewContent(createdAt: NSDate()),
                        .NoiseStream,
                        .NotificationsNewContent(createdAt: NSDate()),
                        .NotificationsStream(category: ""),
                        .PostComments(postId: ""),
                        .PostDetail(postParam: "", commentCount: 10),
                        .PostLovers(postId: ""),
                        .PostReposters(postId: ""),
                        .CurrentUserStream,
                        .ProfileDelete,
                        .ProfileToggles,
                        .ProfileUpdate(body: [:]),
                        .PushSubscriptions(token: NSData()),
                        .ReAuth(token: ""),
                        .Relationship(userId: "", relationship: ""),
                        .RelationshipBatch(userIds: [""], relationship: ""),
                        .RePost(postId: ""),
                        .SearchForPosts(terms: ""),
                        .SearchForUsers(terms: ""),
                        .UserNameAutoComplete(terms: ""),
                        .UserCategories(categoryIds: [""]),
                        .UserStream(userParam: ""),
                        .UserStreamFollowers(userId: ""),
                        .UserStreamFollowing(userId: ""),
                    ]
                    for endpoint in endpoints {
                        it("\(endpoint) has the correct headers") {
                            expect(endpoint.headers()["Accept-Language"]) == ""
                            expect(endpoint.headers()["Accept"]) == "application/json"
                            expect(endpoint.headers()["Content-Type"]) == "application/json"
                        }
                    }
                }

                context("If-Modified-Since endpoints") {
                    let date = NSDate()
                    let endpoints: [ElloAPI] = [
                        .FriendNewContent(createdAt: date),
                        .NoiseNewContent(createdAt: date),
                        .NotificationsNewContent(createdAt: date)
                    ]
                    for endpoint in endpoints {
                        it("\(endpoint) has the correct headers") {
                            expect(endpoint.headers()["If-Modified-Since"]) == date.toHTTPDateString()
                        }
                    }
                }

                context("build number header") {
                    let endpoint: ElloAPI = .AmazonCredentials
                    it("should include build number") {
                        let expected = NSBundle.mainBundle().infoDictionary![kCFBundleVersionKey as String] as! String
                        expect(endpoint.headers()["X-iOS-Build-Number"]) == expected
                        expect(endpoint.headers()["X-iOS-Build-Number"]).to(match("^\\d+$"))
                    }
                }

                context("normal authorization required") {
                    let endpoints: [ElloAPI] = [
                        .AmazonCredentials,
                        .Availability(content: [:]),
                        .CreateComment(parentPostId: "", body: [:]),
                        .CreateLove(postId: ""),
                        .CreatePost(body: [:]),
                        .DeleteComment(postId: "", commentId: ""),
                        .DeleteLove(postId: ""),
                        .DeletePost(postId: ""),
                        .DeleteSubscriptions(token: NSData()),
                        .Discover(type: .Trending),
                        .CategoryPosts(slug: ""),
                        .EmojiAutoComplete(terms: ""),
                        .FindFriends(contacts: ["" : [""]]),
                        .FlagComment(postId: "", commentId: "", kind: ""),
                        .FlagPost(postId: "", kind: ""),
                        .FriendStream,
                        .InfiniteScroll(queryItems: [""], elloApi: { () -> ElloAPI in
                            return ElloAPI.FriendStream
                        }),
                        .InviteFriends(contact: ""),
                        .Join(email: "", username: "", password: "", invitationCode: ""),
                        .Loves(userId: ""),
                        .NoiseStream,
                        .NotificationsStream(category: ""),
                        .PostComments(postId: ""),
                        .PostDetail(postParam: "", commentCount: 10),
                        .PostLovers(postId: ""),
                        .PostReposters(postId: ""),
                        .CurrentUserStream,
                        .ProfileDelete,
                        .ProfileToggles,
                        .ProfileUpdate(body: [:]),
                        .RePost(postId: ""),
                        .PushSubscriptions(token: NSData()),
                        .Relationship(userId: "", relationship: ""),
                        .RelationshipBatch(userIds: [""], relationship: ""),
                        .SearchForUsers(terms: ""),
                        .SearchForPosts(terms: ""),
                        .UserCategories(categoryIds: [""]),
                        .UserStream(userParam: ""),
                        .UserStreamFollowers(userId: ""),
                        .UserStreamFollowing(userId: ""),
                        .UserNameAutoComplete(terms: "")
                    ]
                    for endpoint in endpoints {
                        it("\(endpoint) has the correct headers") {
                            expect(endpoint.headers()["Authorization"]) == AuthToken().tokenWithBearer ?? ""
                        }
                    }
                }
            }

            describe("parameter values") {

                it("AnonymousCredentials") {
                    let params = ElloAPI.AnonymousCredentials.parameters!
                    expect(params["client_id"]).notTo(beNil())
                    expect(params["client_secret"]).notTo(beNil())
                    expect(params["grant_type"] as? String) == "client_credentials"
                }

                it("Auth") {
                    let params = ElloAPI.Auth(email: "me@me.me", password: "p455w0rd").parameters!
                    expect(params["client_id"]).notTo(beNil())
                    expect(params["client_secret"]).notTo(beNil())
                    expect(params["email"] as? String) == "me@me.me"
                    expect(params["password"] as? String) == "p455w0rd"
                    expect(params["grant_type"] as? String) == "password"
                }

                it("Availability") {
                    let content = ["username": "sterlingarcher"]
                    expect(ElloAPI.Availability(content: content).parameters as? [String: String]) == content
                }

                it("CreateComment") {
                    let content = ["text": "my sweet comment content"]
                    expect(ElloAPI.CreateComment(parentPostId: "id", body: content).parameters as? [String: String]) == content
                }

                it("CreatePost") {
                    let content = ["text": "my sweet post content"]
                    expect(ElloAPI.CreatePost(body: content).parameters as? [String: String]) == content
                }

                it("Discover") {
                    let params = ElloAPI.Discover(type: .Featured).parameters!
                    expect(params["per_page"] as? Int) == 10
                    expect(params["include_recent_posts"] as? Bool) == true
                    expect(params["seed"]).notTo(beNil())
                }

                it("CategoryPosts") {
                    let params = ElloAPI.CategoryPosts(slug: "art").parameters!
                    expect(params["per_page"] as? Int) == 10
                }

                xit("FindFriends") {

                }

                it("FriendStream") {
                    let params = ElloAPI.FriendStream.parameters!
                    expect(params["per_page"] as? Int) == 10
                }

                it("InfiniteScroll") {
                    let queryItems = NSURLComponents(string: "ttp://ello.co/api/v2/posts/278/comments?after=2014-06-02T00%3A00%3A00.000000000%2B0000&per_page=2")!.queryItems
                    let infiniteScroll = ElloAPI.InfiniteScroll(queryItems: queryItems!) { return ElloAPI.Discover(type: .Featured) }
                    let params = infiniteScroll.parameters!
                    expect(params["per_page"] as? String) == "2"
                    expect(params["include_recent_posts"] as? Bool) == true
                    expect(params["seed"]).notTo(beNil())
                    expect(params["after"]).notTo(beNil())
                }

                it("InviteFriends") {
                    let params = ElloAPI.InviteFriends(contact: "me@me.me").parameters!
                    expect(params["email"] as? String) == "me@me.me"
                }

                describe("Join") {
                    context("without an invitation code") {
                        let params = ElloAPI.Join(email: "me@me.me", username: "sweetness", password: "password", invitationCode: nil).parameters!
                        expect(params["email"] as? String) == "me@me.me"
                        expect(params["username"] as? String) == "sweetness"
                        expect(params["password"] as? String) == "password"
                        expect(params["invitation_code"]).to(beNil())
                    }

                    context("with an invitation code") {
                        let params = ElloAPI.Join(email: "me@me.me", username: "sweetness", password: "password", invitationCode: "my-sweet-code").parameters!
                        expect(params["email"] as? String) == "me@me.me"
                        expect(params["username"] as? String) == "sweetness"
                        expect(params["password"] as? String) == "password"
                        expect(params["invitation_code"] as? String) == "my-sweet-code"
                    }
                }

                it("NoiseStream") {
                    let params = ElloAPI.NoiseStream.parameters!
                    expect(params["per_page"] as? Int) == 10
                }

                describe("NotificationsStream") {

                    it("without a category") {
                        let params = ElloAPI.NotificationsStream(category: nil).parameters!
                        expect(params["per_page"] as? Int) == 10
                        expect(params["category"]).to(beNil())
                    }

                    it("with a category") {
                        let params = ElloAPI.NotificationsStream(category: "all").parameters!
                        expect(params["per_page"] as? Int) == 10
                        expect(params["category"] as? String) == "all"
                    }
                }

                it("PostComments") {
                    let params = ElloAPI.PostComments(postId: "comments-id").parameters!
                    expect(params["per_page"] as? Int) == 10
                }

                describe("PostDetail") {
                    it("commentCount 10") {
                        let params = ElloAPI.PostDetail(postParam: "post-id", commentCount: 10).parameters!
                        expect(params["comment_count"] as? Int) == 10
                    }
                    it("commentCount 0") {
                        let params = ElloAPI.PostDetail(postParam: "post-id", commentCount: 0).parameters!
                        expect(params["comment_count"] as? Int) == 0
                    }
                }

                it("Profile") {
                    let params = ElloAPI.CurrentUserStream.parameters!
                    expect(params["post_count"] as? Int) == 10
                }

                xit("PushSubscriptions, DeleteSubscriptions") {

                }

                it("ReAuth") {
                    let params = ElloAPI.ReAuth(token: "refresh").parameters!
                    expect(params["client_id"]).notTo(beNil())
                    expect(params["client_secret"]).notTo(beNil())
                    expect(params["grant_type"] as? String) == "refresh_token"
                    expect(params["refresh_token"] as? String) == "refresh"
                }

                it("RelationshipBatch") {
                    let params = ElloAPI.RelationshipBatch(userIds: ["1", "2", "8"], relationship: "friend").parameters!
                    expect(params["user_ids"] as? [String]) == ["1", "2", "8"]
                    expect(params["priority"] as? String) == "friend"
                }

                it("RePost") {
                    let params = ElloAPI.RePost(postId: "666").parameters!
                    expect(params["repost_id"] as? Int) == 666
                }

                it("SearchForPosts") {
                    let params = ElloAPI.SearchForPosts(terms: "blah").parameters!
                    expect(params["terms"] as? String) == "blah"
                    expect(params["per_page"] as? Int) == 10
                }

                it("SearchForUsers") {
                    let params = ElloAPI.SearchForUsers(terms: "blah").parameters!
                    expect(params["terms"] as? String) == "blah"
                    expect(params["per_page"] as? Int) == 10
                }

                it("UserNameAutoComplete") {
                    let params = ElloAPI.UserNameAutoComplete(terms: "blah").parameters!
                    expect(params["terms"] as? String) == "blah"
                }

                it("UserCategories") {
                    let params = ElloAPI.UserCategories(categoryIds: ["456"]).parameters!
                    expect(params["followed_category_ids"] as? [String]) == ["456"]
                }
            }

            describe("valid enpoints") {
                describe("with stubbed responses") {
                    describe("a provider") {
                        it("returns stubbed data for auth request") {
                            var message: String?

                            let target: ElloAPI = .Auth(email:"test@example.com", password: "123456")
                            provider.request(target, completion: { (result) in
                                switch result {
                                case let .Success(moyaResponse):
                                    message = NSString(data: moyaResponse.data, encoding: NSUTF8StringEncoding) as? String
                                default: break
                                }
                            })

                            let sampleData = target.sampleData as NSData
                            expect(message).to(equal(NSString(data: sampleData, encoding: NSUTF8StringEncoding)))
                        }

                        it("returns stubbed data for friends stream request") {
                            var message: String?

                            let target: ElloAPI = .FriendStream
                            provider.request(target, completion: { (result) in
                                switch result {
                                case let .Success(moyaResponse):
                                    message = NSString(data: moyaResponse.data, encoding: NSUTF8StringEncoding) as? String
                                default: break
                                }
                            })

                            let sampleData = target.sampleData as NSData
                            expect(message).to(equal(NSString(data: sampleData, encoding: NSUTF8StringEncoding)))
                        }
                    }
                }
            }
        }
    }
}
