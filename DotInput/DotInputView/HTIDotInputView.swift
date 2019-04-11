//
//  HTIDotInputView.swift
//  iBestProduct
//
//  Created by xiekunpeng on 2019/3/27.
//  Copyright © 2019 iBest. All rights reserved.
//

import UIKit

///密文输入的个数
enum InputCount : Int {
    case Six = 6
    case Seven = 7
    case Eight = 8
    case Nine = 9
}

typealias InputOverB = (String) ->(Void);


class HTIDotInputView: UIView, UITextFieldDelegate {
    
    
    ///fram方式创建, 如果是可视化请在awakeFromNib()方法中设置
    init(frame: CGRect, count: InputCount) {
        super.init(frame: frame);
        self.inputCount = count;
        self.addDotView();
        ///添加监听在键盘将要消失时隐藏cursorV
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisapper), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///可视化创建
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    
    //MARK:getter
    ///默认是6位输入
    var inputCount = InputCount.Six;
    ///创建的dotV存在数组中
    var dotArr = NSMutableArray.init();
    ///输入完d回调的Block
    var inputOver : InputOverB?;
    ///光标闪烁计时
    var timer : Timer?;
    
    ///输入框, 实际上看不到, 单纯为了记录输入的内容
    lazy var inputTF: UITextField = {
        var tf = UITextField.init(frame: CGRect.zero);
        tf.delegate = self;
        tf.addTarget(self, action: #selector(tfChange(sender:)), for: UIControl.Event.allEvents);
        tf.isSecureTextEntry = true;
        tf.clearsOnBeginEditing = true;
        tf.keyboardType = UIKeyboardType.numberPad;
        return tf;
    }()
    
    ///闪烁的光标V
    lazy var cursorV: UIView = {
        var v = UIView.init(frame: CGRect(x: 0, y: 0, width: 1, height: self.bounds.height));
        v.backgroundColor = UIColor.lightGray;
        return v;
    }()
    
    ///手势, 点击时获取第一响应
    lazy var tapG: UITapGestureRecognizer = {
        var tapg : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGAction(sender:)));
        return tapg;
    }()
    
    
    func addDotView()  {
        let offset : CGFloat = 10.0;
        self.dotArr.removeAllObjects();
        let count = self.inputCount.rawValue;
        let width = (self.frame.width - offset * CGFloat((count - 1))) / CGFloat(count);
        
        for idx in 0..<count {
            let dtV = DotView.init(frame: CGRect(x: CGFloat(idx) * (width + offset) , y: 0, width: width, height: self.frame.height));
            dtV.tag = 800 + idx;
            dtV.updateColor(upColor: false);
            self.dotArr.add(dtV);
            self.addSubview(dtV);
        }
        self.addSubview(self.inputTF);
        self.addGestureRecognizer(self.tapG);
    }
    
    ///重置输入状态
    func resetInputTF()  {
        self.inputTF.text = "";
        self.inputTF.becomeFirstResponder();
    }
    
    
    
    @objc func tfChange(sender : UITextField   ) {
        if sender.text?.count ?? 0 >= self.inputCount.rawValue  {
            sender.text = String(sender.text!.prefix(self.inputCount.rawValue));
        }
        let count = sender.text?.count ?? 0 ;
        for idx in 0..<self.inputCount.rawValue {
            let dtV = self.dotArr[idx] as! DotView;
            if idx < count  {
                dtV.updateColor(upColor: true);
            }else {
                dtV.updateColor(upColor: false);
            }
            if idx == sender.text?.count {
                self.layoutCursor(dotV: dtV);
            }else {

            }
        }
        if sender.text?.count == self.inputCount.rawValue {
            self.cursorV.isHidden = true;
            self.timer?.invalidate();
            self.timer = nil; 
        }
        if (self.inputOver != nil) {
            self.inputOver!(sender.text!);
        }
//        print("当前输入的密码:   \(sender.text ?? "")");
    }
    
    func layoutCursor(dotV : DotView)  {
        if !self.inputTF.isFirstResponder {
            return;
        }
        self.cursorV.removeFromSuperview();
        self.cursorV.frame = CGRect(x: dotV.bounds.width / 2.0, y: 3, width: 1, height: self.bounds.height - 6);
        dotV.addSubview(self.cursorV);
        if self.timer == nil {
            self.timer = Timer.init(timeInterval: 0.7, target: self, selector: #selector(timerMethod(sender:)), userInfo: nil, repeats: true);
            RunLoop.current.add(self.timer!, forMode:RunLoopMode.commonModes);
            self.timer?.fire();
        }
    }
    
    @objc func timerMethod(sender : Timer)  {
        if self.inputTF.text?.count ?? 0 != self.inputCount.rawValue {
            self.cursorV.isHidden = !self.cursorV.isHidden;
        }else {
            self.cursorV.isHidden = true;
        }
    }
    
    
    func getInputPSWBlock(inputB :@escaping InputOverB) {
        self.inputOver = inputB;
    }
    
    
    @objc func tapGAction(sender : UITapGestureRecognizer) {
        self.inputTF.becomeFirstResponder();
    }
    
    
    @objc func keyboardWillDisapper()  {
        self.timer?.invalidate();
        self.timer = nil;
        self.cursorV.isHidden = true;
    }
    
 
    
    deinit {
        print("dealloc ----- \(self)");
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
