//
//  ViewController.swift
//  LogButton
//
//  Created by YE on 2017/3/27.
//  Copyright © 2017年 Eter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let bt = AnimationButton()

    @IBOutlet weak var lgButton: AnimationButton!
    @IBAction func tAction(_ sender: AnimationButton) {
        
        
        sender.isEnabled = false
        
        DispatchQueue.global().async {
            sleep(5)
            DispatchQueue.main.async {
                sender.isEnabled = true
                sender.setTitle("登录失败请重试", for: .normal)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    sender.setTitle("登录", for: .normal)
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lgButton.cornerRadius = 5
        lgButton.setTitleColor(UIColor.black, for: .normal)
        lgButton.setBackgroundColor(UIColor.white, forState: .normal)
        
//        self.view.backgroundColor = UIColor.black
//        
//        bt.frame = CGRect(x: 20, y: 100, width: 150, height: 50)
//        bt.setTitle("百度", for: .normal)
//        bt.upToDown = false
//        bt.cornerRadius = 5
//        bt.setTitleColor(UIColor.blue, for: .normal)
//        bt.setTitle("登录中...", for: .disabled)
//        bt.addTarget(self, action: #selector(action), for: .touchUpInside)
//        self.view.addSubview(bt)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func action() {
        self.bt.isEnabled = false
        
        DispatchQueue.global().async {
            sleep(5)
            DispatchQueue.main.async {
                self.bt.isEnabled = true
                self.bt.setTitle("登录失败请重试", for: .normal)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                    self.bt.setTitle("登录", for: .normal)
                })
            }
        }
    }

}
   

