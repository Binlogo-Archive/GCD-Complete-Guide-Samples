//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import SafariServices

//
// 本示例用于阐述异步网络请求
// 文章详情链接：https://xiaozhuanlan.com/complete-ios-gcd （TBD：待发布后替换）
//

struct MiniSpecialColumn {
    var id: String
    var title: String
    var description: String
    var link: URL
}

class FakeNetwork {
    func getMiniSpecialColumnList() -> [(String, String)] {
        return [("000", "设计知录（原U程I）"),
                ("001", "设计行录：Sketch 快速入门"),
                ("002", "彻底搞定 GCD🚦并发编程")]
    }
    static let fakeResults: [String: MiniSpecialColumn] = [
        "000": .init(id: "000",
                     title: "设计知录（原U程I）",
                     description: "做接地气的设计传道者，帮助您学会解决设计问题",
                     link: URL(string: "https://xiaozhuanlan.com/ui-x")!),
        "001": .init(id: "001",
                     title: "设计行录：Sketch 快速入门",
                     description: "你知道吗？Sketch 除了能做 UI 和交互，还能画插画、绘图表和 P图哦～",
                     link: URL(string: "https://xiaozhuanlan.com/sketch-go")!),
        "002": .init(id: "002",
                     title: "彻底搞定 GCD🚦并发编程",
                     description: "本专栏旨在彻底厘清 iOS 开发中 GCD 的应用场景与涉及的API，分析并理解其背后的原理。",
                     link: URL(string: "https://xiaozhuanlan.com/complete-ios-gcd")!)
    ]
    
    func getMiniSpecialColumnDetail(withID id: String, completion: @escaping (MiniSpecialColumn) -> ()) {
        DispatchQueue.global().async {
            sleep(1) // ℹ️ 模拟网络耗时 1s
            let result = FakeNetwork.fakeResults[id]!
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

private let themeColor = UIColor(red: 255/255.0, green: 112/255.0, blue: 85/255.0, alpha: 1.0)
class ItemViewController: UIViewController {
    
    var item: MiniSpecialColumn!
    
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLable = UILabel()
    private lazy var subscribeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        [titleLabel, descriptionLable, subscribeButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descriptionLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        subscribeButton.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 20).isActive = true
        subscribeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.text = item.title
        
        descriptionLable.numberOfLines = 0
        descriptionLable.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLable.text = item.description
        
        subscribeButton.setTitleColor(themeColor, for: .normal)
        subscribeButton.setTitle("马上订阅", for: .normal)
        subscribeButton.addTarget(self, action: #selector(subscribeAction), for: .touchUpInside)
    }
    
    @objc
    private func subscribeAction(_ sender: Any) {
        let vc = SFSafariViewController(url: item.link)
        present(vc, animated: true, completion: nil)
    }
}

private let itemCellIdentifier = "ItemCellIdentifier"
class ListViewController : UITableViewController {
    
    private var items: [(String, String)]!
    private var network = FakeNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "小专栏"
        items = network.getMiniSpecialColumnList()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: itemCellIdentifier)
    }
    
    // MARK: - UITableView Data Source & Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        let id = items[indexPath.row].0
        // 🤔 尝试方案2
        network.getMiniSpecialColumnDetail(withID: id) { [weak self] item in
            let vc = ItemViewController()
            vc.item = item
            self?.show(vc, sender: nil)
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UINavigationController(rootViewController: ListViewController())
