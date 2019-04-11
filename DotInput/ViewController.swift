//
//  ViewController.swift
//  DotInput
//
//  Created by xiekunpeng on 2019/4/11.
//  Copyright © 2019 xboker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dotV = HTIDotInputView.init(frame: CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 60), count: InputCount.Seven);
        self.view.addSubview(dotV);
        dotV.getInputPSWBlock {(psw : String?) -> (Void) in
            print("当前输入的密码内容  \(psw ?? "")");
        }
        
        
        // Do any additional setup after loading the view.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    
}

