////
///  ArtistInviteDetailScreen.swift
//

class ArtistInviteDetailScreen: StreamableScreen, ArtistInviteDetailScreenProtocol {
    fileprivate let successScreen = ArtistInviteSubmissionSuccessScreen()

    override func style() {
        super.style()
        successScreen.alpha = 0
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        if let window = window, successScreen.superview != window {
            window.addSubview(successScreen)

            successScreen.snp.makeConstraints { make in
                make.edges.equalTo(self)
            }
            successScreen.frame = window.bounds
        }
        else if window == nil, successScreen.superview != nil {
            successScreen.removeFromSuperview()
        }
    }

    func showSuccess() {
        animate {
            self.successScreen.alpha = 1
        }
        delay(3, block: hideSuccess)
    }

    func hideSuccess() {
        animate {
            self.successScreen.alpha = 0
        }
    }
}
