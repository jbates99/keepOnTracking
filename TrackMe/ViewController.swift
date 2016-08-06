//
//  ViewController.swift
//  HUD example
//
//  Created by Parker Rushton on 8/6/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        HUD.show(HUDContentType.Error)
    }

}

