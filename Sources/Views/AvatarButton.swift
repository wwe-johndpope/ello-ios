//
//  AvatarButton.swift
//  Ello
//
//  Created by Ryan Boyajian on 2/5/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import Foundation

public class AvatarButton: UIButton {

    func setAvatarURL(url:NSURL?) {
        let state = UIControlState.Normal
        if let url = url {
            self.sd_setImageWithURL(url, forState: state) { (image, error, type, url) in
                if image == nil {
                    self.setDefaultImage()
                }
            }
        }
        else {
            setDefaultImage()
        }
    }

    func setDefaultImage() {
        self.setImage(nil, forState: state)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = self.imageView {
            imageView.layer.cornerRadius = self.bounds.size.height / CGFloat(2)
        }
    }

}
