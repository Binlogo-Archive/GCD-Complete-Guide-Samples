//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//
// 本示例用于阐述「网络请求、I/O 操作等耗时操作阻塞了主线程的 UI 交互，造成卡顿」的问题
// 文章详情链接：https://xiaozhuanlan.com/complete-ios-gcd （TBD：待发布后替换）
//

struct Item {
    var title: String
    var content: String
    var link: String
}

private let itemCellIdentifier = "ItemCellIdentifier"
class ListViewController : UITableViewController {
    
    private var itemTitles = ["GCD", "Complete", "Guide"]
    private var network = FakeNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "小专栏"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: itemCellIdentifier)
    }
    
    // MARK: - UITableView Data Source & Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath)
        cell.textLabel?.text = itemTitles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        
        let title = itemTitles[indexPath.row]
        let vc = ItemViewController()
        vc.item = network.getItemDetail(title: title) // ⚠️ 问题产生
        show(vc, sender: nil)
    }
}

class ItemViewController: UIViewController {
    
    var item: Item!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = item.title
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}

class FakeNetwork {
    func getItemDetail(title: String) -> Item {
        sleep(1) // ℹ️ 模拟网络耗时 1s
        return Item(title: title,
                    content: "彻底搞定 GCD🚦并发编程",
                    link: "https://xiaozhuanlan.com/complete-ios-gcd")
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = UINavigationController(rootViewController: ListViewController())
