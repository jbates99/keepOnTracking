//
//  AppearanceController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/23/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AppearanceController {
    
    static func initializeAppearance() {
        UINavigationBar.appearance().tintColor = .darkGreen
        UINavigationBar.appearance().barTintColor = .lightGreen
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGreen]
        UITabBar.appearance().tintColor = .darkGreen
        UITabBar.appearance().barTintColor = .lightGreen
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGreen], forState: .Normal)
        UITableView.appearance().backgroundColor = .offWhite
        UITableViewCell.appearance().tintColor = .darkGreen
        UITableViewCell.appearance().backgroundColor = .offWhite
        ButtonTableViewCell.appearance().backgroundColor = .offWhite
        FollowUserTableViewCell.appearance().backgroundColor = .offWhite
        PendingRequestCell.appearance().backgroundColor = .offWhite
        ButtonTableViewCell.appearance().tintColor = .darkGreen
        FollowUserTableViewCell.appearance().tintColor = .darkGreen
        PendingRequestCell.appearance().tintColor = .darkGreen
        MKMapView.appearance().tintColor = .lightGreen
        UITextField.appearance().backgroundColor = .offWhite
        UITextField.appearance().tintColor = .lightGreen
        UITextField.appearance().textColor = .darkGreen
        UILabel.appearance().tintColor = .darkGreen
    }
    
}

extension UIColor {
    
    class var lightGreen: UIColor {
        return UIColor(red: 51/255, green: 204/255, blue: 153/255, alpha: 1)
    }
    
    class var darkGreen: UIColor {
        return UIColor(red: 49/255, green: 153/255, blue: 110/255, alpha: 1)
    }
    
    class var orangeRed: UIColor {
        return UIColor(red: 241/255, green: 89/255, blue: 73/255, alpha: 1)
    }
    
    class var offWhite: UIColor {
        return UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
    }
    
}
