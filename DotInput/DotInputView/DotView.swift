//
//  DotView.swift
//  iBestProduct
//
//  Created by xiekunpeng on 2019/3/27.
//  Copyright © 2019 iBest. All rights reserved.
//

import UIKit


class DotView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.layer.borderWidth = 1;
        self.addSubview(self.dotV);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:Getter
    ///是否上色
    var upColor : Bool = false;
    lazy var dotV: UIView = {
        let width = min(self.bounds.width / 2.0, self.bounds.height / 2.0);
        var v = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: width));
        v.layer.masksToBounds = true;
        v.layer.cornerRadius = width / 2.0;
        v.backgroundColor = UIColor.blue;
        v.isHidden = true;
        v.center = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0);
        return v;
    }()
    
    //MARK:Method
    func updateColor(upColor:Bool) {
         if upColor {
            if self.upColor == false {
                self.upColor = true;
                self.layer.borderColor = UIColor.blue.cgColor;
                self.dotV.isHidden = false;
            }
            return;
        }
        if  self.upColor == true {
            self.upColor = false;
            self.layer.borderColor = UIColor.lightGray.cgColor;
            self.dotV.isHidden = true;
        }
    }
    
    

    deinit {
        print("dealloc ----\(self)");
    }
    
    
}
