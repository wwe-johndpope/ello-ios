//
//  BlockUserModalConfig.swift
//  Ello
//
//  Created by Colin Gray on 6/8/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

public struct BlockUserModalConfig {
    let userId: String
    let userAtName: String
    let relationshipPriority: RelationshipPriority
    let changeClosure: RelationshipChangeClosure

    public init(userId: String, userAtName: String, relationshipPriority: RelationshipPriority, changeClosure: RelationshipChangeClosure) {
        self.userId = userId
        self.userAtName = userAtName
        self.relationshipPriority = relationshipPriority
        self.changeClosure = changeClosure
    }

}
