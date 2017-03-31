////
///  VideoLoopView.swift
//
// Heavily inspired by https://github.com/liaujianjie/VideoLoopView/blob/master/VideoLoopView/VideoLoopView.swift

import AVFoundation
import FutureKit
import PINRemoteImage
import PINCache
import Alamofire


public class VideoLoopView: UIView {

    private var isObserving = false
    private var shouldPlay = true
    private var promise = Promise<VideoCacheType>()
    private var cacheType: VideoCacheType!
    private var videoObserver: NSObjectProtocol?
    private var foregroundObserver: NotificationObserver?
    private var backgroundObserver: NotificationObserver?
    private let playerLayer: AVPlayerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem? {
        willSet {
            removeObservers()
        }
        didSet {
            guard let playerItem = self.playerItem else { return }
            isObserving = true
            playerItem.addObserver(
                self,
                forKeyPath: #keyPath(AVPlayerItem.status),
                options: [.old, .new],
                context: nil
            )
            player = AVPlayer(playerItem: playerItem)
            player?.actionAtItemEnd = .none
            player?.isMuted = true
            playerLayer.player = player

            videoObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: nil) { [weak self] _ in
                guard let `self` = self, self.shouldPlay else { return }

                inForeground {
                    self.player?.seek(to: kCMTimeZero)
                }
            }

            foregroundObserver = NotificationObserver(notification: Application.Notifications.WillEnterForeground) { [weak self] _ in
                guard let `self` = self, self.shouldPlay else { return }

                inForeground {
                    self.play()
                }
            }

            backgroundObserver = NotificationObserver(notification: Application.Notifications.DidEnterBackground) { [weak self] _ in
                guard let `self` = self, self.shouldPlay else { return }

                inForeground {
                    self.player?.pause()
                }
            }

            play()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = bounds
        CATransaction.commit()
    }

    deinit {
        removeObservers()
    }

    public func loadVideo(url: URL) -> Future<VideoCacheType>  {
        let cache = VideoCache()
        cache.loadVideo(url: url)
        .onSuccess { [weak self] (url, type) in
            guard let `self` = self else { return }
            self.cacheType = type
            self.playerItem = AVPlayerItem(url: url)
        }
        .onFail { _ in
            self.promise.completeWithFail("Unable to Load")
        }
        return promise.future
    }

    override public func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?)
    {
        guard keyPath == #keyPath(AVPlayerItem.status) else { return }

        let status: AVPlayerItemStatus

        if let statusNumber = change?[.newKey] as? NSNumber {
            status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
        } else {
            status = .unknown
        }

        switch status {
        case .readyToPlay:
            promise.completeWithSuccess(cacheType)
        case .failed:
            promise.completeWithFail("Failed To Load")
        case .unknown:
            break
        }
    }

    public func reset() {
        player?.replaceCurrentItem(with: nil)
    }

    public func playVideo() {
        shouldPlay = true
        play()
    }

    public func pauseVideo() {
        shouldPlay = false
        player?.pause()
    }

    private func setup() {
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.backgroundColor = UIColor.clear.cgColor
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
    }

    private func removeObservers() {
        guard isObserving else { return }
        isObserving = false
        NotificationCenter.default.removeObserver(self)
        if let observer = videoObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        foregroundObserver?.removeObserver()
        backgroundObserver?.removeObserver()
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }

    private func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch let error as NSError {
            print(error)
        }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error)
        }
        player?.play()
    }
}
