//
//  TestBSwiftVC.swift
//  TBHotpatchSDKTest
//
//  Created by junzhan on 15/8/20.
//  Copyright (c) 2015年 junzhan. All rights reserved.
//

import UIKit

class TestBSwiftVC: UIViewController {

    override func viewDidLoad() {
        self.title = "TestBSwiftVC";
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }

    @IBAction func testOCVCBUttonPressed(sender: AnyObject) {
//        var vc = TestOCVC.init();
//        self.navigationController?.pushViewController(vc, animated: true);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
