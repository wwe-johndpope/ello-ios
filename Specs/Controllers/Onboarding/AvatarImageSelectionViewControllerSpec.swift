//
//  AvatarImageSelectionViewControllerSpec.swift
//  Ello
//
//  Created by Colin Gray on 10/5/2015.
//  Copyright (c) 2015 Ello. All rights reserved.
//

@testable
import Ello
import Quick
import Nimble
import Nimble_Snapshots


class AvatarImageSelectionViewControllerSpec: QuickSpec {
    override func spec() {
        describe("AvatarImageSelectionViewController") {
            let subject = AvatarImageSelectionViewController()
            describe("snapshots") {
                validateAllSnapshots(subject, named: "AvatarImageSelectionViewController")
            }
        }
    }
}
