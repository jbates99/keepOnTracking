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
