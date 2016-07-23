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
    
    // MARK: - App Colors
    
    static let lightGreen = UIColor(red: 51/255, green: 204/255, blue: 153/255, alpha: 1)
    static let darkGreen = UIColor(red: 49/255, green: 153/255, blue: 110/255, alpha: 1)
    static let orangeRed = UIColor(red: 241/255, green: 89/255, blue: 73/255, alpha: 1)
    static let offWhite = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
    
    // MARK: - Set Up General Appearance
    
    static func initializeAppearance() {
        UINavigationBar.appearance().tintColor = darkGreen
        UINavigationBar.appearance().barTintColor = lightGreen
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: darkGreen]
        UITabBar.appearance().tintColor = darkGreen
        UITabBar.appearance().barTintColor = lightGreen
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: darkGreen], forState: .Normal)
        UITableView.appearance().backgroundColor = offWhite
        UITableViewCell.appearance().tintColor = darkGreen
        UITableViewCell.appearance().backgroundColor = offWhite
        ButtonTableViewCell.appearance().backgroundColor = offWhite
        FollowUserTableViewCell.appearance().backgroundColor = offWhite
        PendingRequestCell.appearance().backgroundColor = offWhite
        ButtonTableViewCell.appearance().tintColor = darkGreen
        FollowUserTableViewCell.appearance().tintColor = darkGreen
        PendingRequestCell.appearance().tintColor = darkGreen
        MKMapView.appearance().tintColor = lightGreen
        UITextField.appearance().backgroundColor = offWhite
        UITextField.appearance().tintColor = lightGreen
        UITextField.appearance().textColor = darkGreen
        UILabel.appearance().tintColor = darkGreen
        
    }

}