////
///  ProfileStatsSizeCalculator.swift
//

import PromiseKit


struct ProfileStatsSizeCalculator {

    func calculate(_ item: StreamCellItem) -> Promise<CGFloat> {
        let height = ProfileStatsView.Size.height
        return Promise<CGFloat>.resolve(height)
    }
}
