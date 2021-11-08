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
class SecondChatListViewController: BaseViewController {
    private var bottomViewMoveDirectionIsUp: Bool = false
    var bottomViewBottomConstraint: NSLayoutConstraint!
    
    /*  DIFFERENT CODE
        - FirstChatListViewController overrides configureTableView Method to set tableView's contentInset.
        - SecondChatListViewController overrides configureBottomView Method to set bottomView's content hugging priority.
        - The difference is because of makeConstraints method of two view controllers.
     */
    override func configureBottomView() {
        // It's ok to remove this "super.configureBottomView()" code but I wrote it.
        super.configureBottomView()
        bottomView.setContentHuggingPriority(.required, for: .vertical)
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
            - Actually All codes in FirstChatViewController's makeConstraints method are same without this code.
         */
        tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
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
        let resizedDistance: CGFloat = 200
        let bottomViewBottomConstraintConstant: CGFloat = bottomViewMoveDirectionIsUp ? 0 : -resizedDistance
        
        /*  - First, we get current contentOffset.y and initialize new variable <contentOffsetY> using this value.
            - Second, we change <contentOffsetY>'s value because this variable will be used for scroll tableView into new Position we want.
            - Third, create new variable <contentOffset> and initialize using <contentOffsetY>
         */
        var contentOffsetY: CGFloat = tableView.contentOffset.y
        contentOffsetY += bottomViewMoveDirectionIsUp ? -resizedDistance : resizedDistance
        let contentOffset = CGPoint(x: 0, y: contentOffsetY)
        
        var resizedTableViewFrame = tableView.frame
        resizedTableViewFrame.size.height += bottomViewMoveDirectionIsUp ? resizedDistance : -resizedDistance
        
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
            /*  This code is written for making scroll indicator's animation better.
                If you don't understand why I wrote this code,
                then try to remove this one and check the difference of scroll indicator    */
            tableView.frame = resizedTableViewFrame
            
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

