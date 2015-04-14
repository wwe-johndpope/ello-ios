//
//  DynamicSettingsSpec.swift
//  Ello
//
//  Created by Tony DiPasquale on 4/10/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import Ello
import Quick
import Nimble

class DynamicSettingsSpec: QuickSpec {
    override func spec() {
        it("coverts from JSON") {
            let parsedDynamicSettings = stubbedJSONDataArray("dynamic_settings", "categories")
            let dynamicSettings = parsedDynamicSettings.map { DynamicSettingCategory.fromJSON($0) as DynamicSettingCategory }

            expect(dynamicSettings.count) == 4
            expect(dynamicSettings.first?.label) == "Preferences"
            expect(dynamicSettings.first?.settings.count) == 6
            expect(dynamicSettings.first?.settings.first?.label) == "Public Profile"
        }
    }
}