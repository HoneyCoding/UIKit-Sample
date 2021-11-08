//
//
//
//
//
//

import UIKit

/*
    - The difference between FirstChatListViewController and SecondChatListViewController is tableView's height.
    - TableView's Height does not change in FirstChatListViewController because makeConstraints() method works different.
    - TableView's Height can be changed in SecondChatListViewController because makeConstraints() method works different.
    - I'll comment above different code.
 */
class FirstChatListViewController: BaseViewController {
    private var bottomViewMoveDirectionIsUp: Bool = false
    var bottomViewBottomConstraint: NSLayoutConstraint!
    
    /*  DIFFERENT CODE
        - FirstChatListViewController overrides configureTableView Method to set tableView's contentInset.
        - SecondChatListViewController overrides configureBottomView Method to set bottomView's content hugging priority.
        - The difference is because of makeConstraints method of two view controllers.
     */
    override func configureTableView() {
        // It's not ok to remove this "super.configureTableView()" code because some code is written in configureTableView method of BaseViewController.
        super.configureTableView()
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomViewHeight, right: 0)
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }
    
    override func makeConstraints() {
        // It's ok to remove this "super.makeConstraints()" code but I wrote it.
        super.makeConstraints()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        testConstraintButton.translatesAutoresizingMaskIntoConstraints = false
        changeTableViewCellCountButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(testConstraintButton)
        view.addSubview(changeTableViewCellCountButton)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        /*  DIFFERENT CODE
            - TableView's bottom is upon safeArea's bottom. It affects tableView's height.
            - Actually All codes in SecondChatViewController's makeConstraints method are same without this code.
         */
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        testConstraintButton.widthAnchor.constraint(equalToConstant: testConstraintButton.layer.cornerRadius * 2).isActive = true
        testConstraintButton.widthAnchor.constraint(equalTo: testConstraintButton.heightAnchor).isActive = true
        testConstraintButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        testConstraintButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        
        changeTableViewCellCountButton.widthAnchor.constraint(equalToConstant: changeTableViewCellCountButton.layer.cornerRadius * 2).isActive = true
        changeTableViewCellCountButton.widthAnchor.constraint(equalTo: changeTableViewCellCountButton.heightAnchor).isActive = true
        changeTableViewCellCountButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        changeTableViewCellCountButton.bottomAnchor.constraint(equalTo: testConstraintButton.topAnchor, constant: -24).isActive = true
        
        bottomView.heightAnchor.constraint(equalToConstant: bottomViewHeight).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomViewBottomConstraint = bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomViewBottomConstraint.isActive = true
    }
    
    // This method does complex calculation. It can be hard for you to understand.
    override func testButtonTapped(_ sender: UIButton) {
        // It's ok to remove this "super.testButtonTapped(sender)" code but I wrote it.
        super.testButtonTapped(sender)
        
        // resizeDistance is distance between safeArea and bottomView when bottomView moved up.
        let resizeDistance: CGFloat = 200
        
        let bottomViewBottomConstraintConstant: CGFloat = bottomViewMoveDirectionIsUp ? 0 : -resizeDistance
        let contentInsetBottom: CGFloat = bottomViewMoveDirectionIsUp ? bottomViewHeight : bottomViewHeight - bottomViewBottomConstraintConstant
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentInsetBottom, right: 0)
        
        /*  - First, we get current contentOffset.y and initialize new variable <contentOffsetY> using this value.
            - Second, we change <contentOffsetY>'s value because this variable will be used for scroll tableView into new Position we want.
            - Third, create new variable <contentOffset> and initialize using <contentOffsetY>
         */
        var contentOffsetY: CGFloat = tableView.contentOffset.y
        contentOffsetY += bottomViewMoveDirectionIsUp ? -resizeDistance : resizeDistance
        let contentOffset = CGPoint(x: 0, y: contentOffsetY)
        
        /*
            - Set <bottomViewBottomConstraint>'s constant using <bottomViewBottomConstraintConstant>.
            - If we don't set the value there's no meaning we calculated above this code.
         */
        bottomViewBottomConstraint.constant = bottomViewBottomConstraintConstant
        
        /*
            We should position this code below other codes. Especially below codes using <bottomViewMoveDirectionIsUp> value
         */
        bottomViewMoveDirectionIsUp.toggle()
        
        UIView.animate(withDuration: 0.5) { [self] in
            
            /*  I wrote this code to make app user scrollable above bottomView
                If you try to scroll using simulator with more than 17 messages, You can scroll above bottomView when you scrolled till tableView's final cell. But you can't scroll beyond it.
                Without this code you can scroll beyond tableView's final cell. */
            tableView.contentInset = contentInset
            
            /*  I wrote this code to make scroll indicator's position and size natural.
                Without this code, scroll indicator's position and size will be strange. This code is only for fixing it.
                If you don't write "tableView.contentInset = contentInset" then you don't need this code.
             */
            tableView.verticalScrollIndicatorInsets = contentInset
            
            /*  - We need to set tableView.contentOffset because when we touch the button we want to move tableView Scroll.
                If you remove this code, tableView will not scroll automatically when you touch the button.
                Actually, auto scroll occurs by us, by this code. Auto scroll does not automatically happen if we don't write it.
                - If you try to pass true to animated parameter, the animation must seem to work strange. */
            tableView.setContentOffset(contentOffset, animated: false)
            
            /*  Because of change of layout constraint's constant value, we should use view.layoutIfNeeded().
                If we don't, animation would not work correctly. */
            view.layoutIfNeeded()
        }
    }
}

