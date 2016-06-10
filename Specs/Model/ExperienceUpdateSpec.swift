//
//  ExperienceUpdateSpec.swift
//  Ello
//
//  Created by Colin Gray on 1/4/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

@testable import Ello
import Quick
import Nimble


class ExperienceUpdateSpec: QuickSpec {
    override func spec() {
        describe("ExperienceUpdate") {
            it("should update post comment counts") {
                let post1 = Post.stub(["id": "post1", "commentsCount": 1])
                let post2 = Post.stub(["id": "post2", "commentsCount": 1])
                let comment = ElloComment.stub([
                    "parentPost": post1,
                    "loadedFromPost": post2
                    ])
                ElloLinkedStore.sharedInstance.setObject(post1, forKey: post1.id, inCollection: MappingType.PostsType.rawValue)
                ContentChange.updateCommentCount(comment, delta: 1)
                expect(post1.commentsCount) == 2
                expect(post2.commentsCount) == 2
                let storedPost = ElloLinkedStore.sharedInstance.getObject(post1.id, inCollection: MappingType.PostsType.rawValue) as! Post
                expect(storedPost.commentsCount) == 2
            }
        }
    }
}
