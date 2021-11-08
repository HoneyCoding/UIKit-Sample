//
//
//
//
//
//

import UIKit

class BaseViewController: UIViewController {
    let tableView: UITableView = UITableView()
    let bottomView: UIView = UIView()
    
    private(set) lazy var testConstraintButton: UIButton = {
        let button = Utility.shared.createRoundedButton(withTintColor: .white, backgroundColor: .systemBlue)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(testButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    private(set) lazy var changeTableViewCellCountButton: UIButton = {
        let button = Utility.shared.createRoundedButton(withTintColor: .darkGray, backgroundColor: .white, drawBorder: true)
        button.setTitle("\(currentTableViewCellCount)", for: .normal)
        button.addTarget(self, action: #selector(changeTableViewCellCountButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let cellIdentifier = "cell"
    let bottomViewHeight: CGFloat = 48
    let additionalTableViewCellCount: Int = 4
    var currentTableViewCellCount: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureBottomView()
        configureTableView()
        configureViewColors()
        makeConstraints()
    }
    
    func configureViewColors() {
        // I created this function to set colors. But this function doesn't set color to table view cell.
        // The color of cell is set in tableView(_:cellForRowAt:) method
        
        view.backgroundColor = .green
        bottomView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        tableView.backgroundColor = .orange
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped(_:)))
    }
    
    func configureBottomView() {
        // empty function. I created this function for use in child class
    }

    func configureTableView() {        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .singleLine
    }
    
    func makeConstraints() {
        // empty function. I created this function for use in child class
    }
    
    @objc func testButtonTapped(_ sender: UIButton) {
        // empty function. I created this function for use in child class
    }
    
    @objc final func changeTableViewCellCountButtonTapped(_ sender: UIButton) {
        let indexPathList: [IndexPath]
        
        indexPathList = ((currentTableViewCellCount)...(currentTableViewCellCount + 3)).map({ row in
            return IndexPath(row: row, section: 0)
        })
        
        currentTableViewCellCount += additionalTableViewCellCount
        sender.setTitle("\(currentTableViewCellCount)", for: .normal)
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.insertRows(at: indexPathList, with: .none)
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        tableView.scrollToRow(at: IndexPath(row: currentTableViewCellCount - 1, section: 0), at: .bottom, animated: true)
    }
    
    @objc final func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTableViewCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = "Message \(indexPath.row + 1)"
        contentConfiguration.textProperties.color = .white
        cell.contentConfiguration = contentConfiguration
        cell.backgroundColor = .white.withAlphaComponent(0.2)
        cell.selectionStyle = .none
        
        return cell
    }
}

