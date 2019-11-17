//: [Previous](@previous)

import UIKit
import PlaygroundSupport

class FakeNetwork {
    func openRedPacket(withID id: String, completion: @escaping () -> ()) {
        // ℹ️ 模拟网络耗时 100ms
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            completion()
        }
    }
}

final class MessagesViewController: UIViewController {
    
    private lazy var messagesFakeImageView: UIImageView = {
        let view = UIImageView()
        let imagePath = Bundle.main.path(forResource: "messages_fake", ofType: "PNG")!
        view.image = UIImage(contentsOfFile: imagePath)
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(_showRedPacket))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messagesFakeImageView)
        messagesFakeImageView.translatesAutoresizingMaskIntoConstraints = false
        messagesFakeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesFakeImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messagesFakeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesFakeImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func _showRedPacket() {
        let redPacketCover = RedPacketCoverViewController()
        present(redPacketCover, animated: true, completion: nil)
    }
}

final class RedPacketCoverViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        let imagePath = Bundle.main.path(forResource: "redpacket_bg@2x", ofType: "png")!
        let image = UIImage(contentsOfFile: imagePath)
        view.image = image
        return view
    }()
    
    private lazy var openButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "redpacket_open_btn")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(_openRedPacket), for: .touchUpInside)
        return button
    }()
    
    private lazy var openAnimationImageView: UIImageView = {
        let image = UIImage(named: "redpacket_open_btn")
        let view = UIImageView(image: image)
        view.isHidden = true
        return view
    }()
    
    let network = FakeNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.addSubview(backgroundImageView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(openButton)
        
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
        
        view.addSubview(openAnimationImageView)
        openAnimationImageView.translatesAutoresizingMaskIntoConstraints = false
        openAnimationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openAnimationImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
        openAnimationImageView.heightAnchor.constraint(equalTo: openButton.heightAnchor).isActive = true
        openAnimationImageView.widthAnchor.constraint(equalTo: openButton.widthAnchor).isActive = true
    }
    
    @objc private func _openRedPacket() {
        _startOpenAnimation()
        network.openRedPacket(withID: "fakeID") { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?._stopOpenAnimation()
                // 打开红包详情页
            }
        }
    }
    
    private func _startOpenAnimation() {
        openAnimationImageView.isHidden = false
        openButton.isHidden = true
        openAnimationImageView.rotate()
    }
    
    private func _stopOpenAnimation() {
        openAnimationImageView.stopRotate()
        openAnimationImageView.isHidden = true
    }
}

private extension UIImageView {
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotation.fromValue = NSNumber(value: 0)
        rotation.byValue = NSNumber(value: Double.pi)
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.0
        rotation.isCumulative = true
        rotation.isRemovedOnCompletion = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotate() {
        layer.removeAnimation(forKey: "rotationAnimation")
        layoutIfNeeded()
    }
}

PlaygroundPage.current.liveView = UINavigationController(rootViewController: MessagesViewController())

//: [Next](@next)
