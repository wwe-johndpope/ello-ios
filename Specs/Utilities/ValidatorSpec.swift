//
//  ValidatorSpec.swift
//  Ello
//
//  Created by Sean Dougherty on 11/25/14.
//  Copyright (c) 2014 Ello. All rights reserved.
//

import Ello
import Quick
import Nimble


class ValidatorSpec: QuickSpec {
    override func spec() {

        context("email validation") {
            let expectations: [(String, Bool)] = [
                ("name@test.com", true),
                ("n@t.co", true),
                ("n@t.shopping", true),
                ("some.name@domain.co.uk", true),
                ("some+name@domain.somethingreallylong", true),
                ("test.com", false),
                ("name@test", false),
                ("name@.com", false),
                ("name@name.com.", false),
                ("name@name.t", false),
                ("", false),
            ]

            for (test, expected) in expectations {
                it("returns \(expected) for \(test)") {
                    expect(test.isValidEmail()) == expected
                }
            }

        }

        context("username validation") {
            let expectations: [(String, Bool)] = [
                ("", false),
                ("a", false),
                ("aa", true),
                ("-a", true),
                ("a-", true),
                ("--", true),
                ("user%", false),
            ]

            for (test, expected) in expectations {
                it("returns \(expected) for \(test)") {
                    expect(test.isValidUsername()) == expected
                }
            }

        }

        context("password validation") {
            let expectations: [(String, Bool)] = [
                ("asdfasdf", true),
                ("12345678", true),
                ("123456789", true),
                ("", false),
                ("1", false),
                ("12", false),
                ("123", false),
                ("1234", false),
                ("12345", false),
                ("123456", false),
                ("1234567", false),
            ]

            for (test, expected) in expectations {
                it("returns \(expected) for \(test)") {
                    expect(test.isValidPassword()) == expected
                }
            }
        }
    }
}
