//: [Previous](@previous)

import UIKit
import PlaygroundSupport

class DelayTipsDemo: UIViewController {
    
    var fakeDatas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _showEmptyNavTipsIfNeeded()
    }
    
    private func _showEmptyNavTipsIfNeeded() {
        
    }
}

PlaygroundPage.current.liveView = UINavigationController(rootViewController: DelayTipsDemo())

//: [Next](@next)
