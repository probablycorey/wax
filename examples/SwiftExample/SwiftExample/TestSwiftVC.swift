//
//  TestSwiftVC.swift
//  TestSwift
//
//  Created by junzhan on 15/9/28.
//  Copyright © 2015年 taobao.com. All rights reserved.
//

import UIKit

class TestASwiftClass :NSObject{
    
    dynamic var aBool:Bool = true;
    dynamic var aInt:UInt = 0;
    dynamic var aFloat:Float = 123.45;
    dynamic var aDouble:Double = 1234.567;
    dynamic var aString:String = "abc";
    dynamic var aObject:AnyObject! = nil;
    
    
    dynamic func testReturnVoidWithaId(aId:UIView){
        
        print("F:\(__FUNCTION__) L:\(__LINE__)");
        self.performSelector(Selector("testNoExistMethod"));
    }
}

class TestSwiftVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    dynamic var aBool:Bool = true;
    dynamic var aInt:UInt = 0;
    dynamic var aFloat:Float = 123.45;
    dynamic var aDouble:Double = 1234.567;
    dynamic var aString:String = "abc";
    dynamic var aObject:AnyObject! = nil;
    
    override func viewDidLoad() {
        self.title = "TestSwiftVC";
        super.viewDidLoad()
        print("F:\(__FUNCTION__) L:\(__LINE__)");
        setupTableView();
        callTestASwiftClass();
        self.classForCoder.testClassReturnVoidWithaBool(true, aInteger: 123, aFloat: 123.456, aDouble: 1234.567, aString: "abc", aObject: self);
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        print("F:\(__FUNCTION__) L:\(__LINE__)");
    }
    dynamic func callTestASwiftClass(){
        let aSwiftClass:TestASwiftClass = TestASwiftClass();
        aSwiftClass.testReturnVoidWithaId(self.view);
    }
    
    dynamic func setupTableView(){
        let tableView:UITableView = UITableView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.size.width, height: self.view.bounds.size.height), style: UITableViewStyle.Plain);
        tableView.delegate = self;
        tableView.dataSource = self;
        self.view.addSubview(tableView);
    }
    
    dynamic func testReturnVoidWithaId(aId:UIView){
        print("F:\(__FUNCTION__) L:\(__LINE__)");
    }
    
    dynamic class func testClassReturnVoidWithaBool(aBool:Bool, aInteger:UInt, aFloat:Float, aDouble:Double, aString:String, aObject:AnyObject){
        print("F:\(__FUNCTION__) L:\(__LINE__)");
    }

    dynamic class func testClassReturnVoidWithaId(aId:AnyObject){
        print("F:\(__FUNCTION__) L:\(__LINE__)");
    }
    
    func testReturnTuple(aBOOL:Bool, aInteger:UInt, aFloat:Float) -> (Bool, UInt, Float) {
        return (aBOOL, aInteger, aFloat)
    }
    func testReturnVoidWithaCharacter(aCharacter:Character){
        
    }
    
    //tableView
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "UITableViewCell");
        
        cell.textLabel!.text = "this is cell \(indexPath.row)";
        
        return cell;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
