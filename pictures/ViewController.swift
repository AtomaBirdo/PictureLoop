//
//  ViewController.swift
//  pictures
//
//  Created by Jiayang (James) Wang on 12/16/19.
//  Copyright © 2019 Jiayang (James) Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imagev: UIImageView!
    
    @IBOutlet weak var textView: UITextField!
    
    var imageName = ["a1.jpg", "a2.jpg", "a3.jpeg", "a4.jpg", "a5.jpg"]
    var imageDesc = ["Eclipse over atmosphere", "An example of galaxy", "Nebula", "Pillars of Creation", "Group of stars"]
    
    var a = 0
    var b : [Int] = []
    var c = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loo(_ sender: UIButton) {
        repeat{
            a = (a + 1) % 5
        }while(b.contains(a))
        
        imagev.image = UIImage(named : imageName[a])
        textView.text = imageDesc[a]
    }
    
    @IBAction func rand(_ sender: UIButton) {
        repeat{
            a = Int.random(in: 0...4)
        }while(b.contains(a))
        
        imagev.image = UIImage(named : imageName[a])
        textView.text = imageDesc[a]
    }
    
    @IBAction func remove(_ sender: UIButton) {
        if !b.contains(a) && b.count != 4{
            b.append(a)
        }
    }
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var step: UIStepper!
    @IBAction func stepper(_ sender: UIStepper) {
        name.text = imageDesc[Int(sender.value)]
    }
    
    @IBAction func restore(_ sender: UIButton) {
        if b.contains(Int(step.value)){
            //c = b.first(where: {$0 == Int(step.value)})! - 1
            c = b.firstIndex(of: Int(step.value))!
            b.remove(at: c)
        }
    }
    
}

