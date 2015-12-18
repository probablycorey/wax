//
//  ViewController.swift
//  SwiftExample
//
//  Created by junzhan on 15/12/18.
//  Copyright © 2015年 test.jz.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func testSwiftVCButtonPressed(sender: AnyObject) {
        let vc = TestSwiftVC.init();
        self.navigationController?.pushViewController(vc, animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

