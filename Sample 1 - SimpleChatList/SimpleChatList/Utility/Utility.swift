//
//  Utility.swift
//  SimpleChatList
//
//  Created by 김진태 on 2021/11/08.
//

import UIKit

class Utility {
    static let shared = Utility()
    
    private init() {  }
    
    func createRoundedButton(withTintColor tintColor: UIColor, backgroundColor: UIColor, radius: CGFloat = 24, drawBorder: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = radius
        button.clipsToBounds = true
        button.tintColor = tintColor
        button.backgroundColor = backgroundColor
        
        if drawBorder {
            button.layer.borderWidth = 1
            button.layer.borderColor = tintColor.cgColor
        }
        
        // use code for setting auto layout
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: button.layer.cornerRadius * 2).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        
        return button
    }
}

