//
//  UIViewControllerExtensions.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/27/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UITableView {
    
    func emptyMessage(message:String, viewController:UITableViewController) {
        let messageLabel = UILabel(frame: CGRectMake(0,0,viewController.view.bounds.size.width, viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGreen
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .Center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        messageLabel.backgroundColor = UIColor.offWhite
        
        viewController.tableView.backgroundView = messageLabel
        viewController.tableView.separatorStyle = .None
    }
    
    func removeMessage(viewController: UITableViewController) {
        viewController.tableView.backgroundView = nil
        viewController.tableView.separatorStyle = .SingleLine
    }
}
