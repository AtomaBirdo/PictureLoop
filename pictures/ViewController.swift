//
//  ViewController.swift
//  pictures
//
//  Created by Jiayang (James) Wang on 12/16/19.
//  Copyright © 2019 Jiayang (James) Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagev: UIImageView!
    
    @IBOutlet weak var textView: UITextField!
    
    @IBOutlet weak var loop: UIButton!
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var random: UIButton!
    @IBOutlet weak var remove: UIButton!
    @IBOutlet weak var restore: UIButton!
    @IBOutlet weak var plus: UIStepper!
    @IBOutlet weak var load: UIButton!
    @IBOutlet weak var changeDesc: UIButton!
    
    var imageName = ["a1.jpg", "a2.jpg", "a3.jpeg", "a4.jpg", "a5.jpg"]
    var imageDesc = ["Eclipse over atmosphere", "An example of galaxy", "Nebula", "Pillars of Creation", "Group of stars"]
    var images : [UIImage] = []
    
    var a = 0
    var b : [Int] = []
    var c = 0
    var d = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imagev.addGestureRecognizer(tapGestureRecognizer)
        confirm.isHidden = true
        for temp in imageName{
            images.append(UIImage(named : temp)!)
        }
    }

    @IBAction func loo(_ sender: UIButton) {
        repeat{
            a = (a + 1) % images.count
        }while(b.contains(a))
        
        imagev.image = images[a]
        textView.text = imageDesc[a]
    }
    
    @IBAction func rand(_ sender: UIButton) {
        repeat{
            a = Int.random(in: 0 ... images.count - 1)
        }while(b.contains(a))
        
        imagev.image = images[a]
        textView.text = imageDesc[a]
    }
    
    @IBAction func remove(_ sender: UIButton) {
        if !b.contains(a) && b.count != images.count - 1{
            b.append(a)
            repeat{
                a = (a + 1) % images.count
            }while(b.contains(a))
            
            imagev.image = images[a]
            textView.text = imageDesc[a]
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
    
    @IBOutlet weak var duration: UITextField!
    
    var time = Timer()
    var animating = false
    
    @IBOutlet weak var anima: UIButton!
    
    @IBAction func ani(_ sender: UIButton) {
        if !animating{
            anima.setTitle("Stop", for: UIControl.State.normal)
            
            /*var images : [UIImage] = []
            for imageN in imageName{
                images.append(UIImage(named: imageN)!)
            }*/
            
            var t : Double = 10
            if duration.text != ""{
                t = Double(duration.text!)!
            }
            
            time = Timer.scheduledTimer(timeInterval: TimeInterval(t), target: self, selector: #selector(Action), userInfo: nil, repeats: true)
            
            animating = true
            
            /*imagev.animationDuration = TimeInterval(a)
            imagev.animationImages = images
            imagev.startAnimating()*/
            
        }else{
            anima.setTitle("Animate", for: UIControl.State.normal)
            time.invalidate()
            animating = false
            
            /*imagev.stopAnimating()
            d = 0
            textView.text = imageDesc[d]*/
        }
    }
    
    @objc func Action(){
        repeat{
            a = (a + 1) % images.count
        }while(b.contains(a))
        imagev.image = images[a]
        textView.text = imageDesc[a]
        newImageView.image = images[a]
    }
    
    var newImageView = UIImageView(image: UIImage(named: "ai.jpg"))
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        /*if animating{
            var t : Double = 10
            if duration.text != ""{
                t = Double(duration.text!)!
            }
            
            fsTimer = Timer.scheduledTimer(timeInterval: TimeInterval(t), target: self, selector: #selector(Action), userInfo: nil, repeats: true)
        }*/
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
        //fsTimer.invalidate()
    }
    
    @IBAction func loadImage(_ sender: UIButton) {
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.allowsEditing = false
        let actionSheet = UIAlertController(title: "Photo", message: "PHOTO", preferredStyle: .actionSheet)
        /*actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            ipc.sourceType = .camera
            self.present(ipc, animated: true, completion: nil)
        }))*/
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            ipc.sourceType = .photoLibrary
            self.present(ipc, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagev.image = pickedImage
        
        images.append(pickedImage)
        imageDesc.append("")
        a = images.count - 1
        step.maximumValue += 1
        
        picker.dismiss(animated: true, completion: nil)
        confirm.isHidden = false
        textView.text = ""
        textView.isUserInteractionEnabled = true
        
        loop.isUserInteractionEnabled = false
        random.isUserInteractionEnabled = false
        duration.isUserInteractionEnabled = false
        anima.isUserInteractionEnabled = false
        load.isUserInteractionEnabled = false
        remove.isUserInteractionEnabled = false
        restore.isUserInteractionEnabled = false
        step.isUserInteractionEnabled = false
        changeDesc.isHidden = true
        
        time.invalidate()
        anima.setTitle("Animate", for: UIControl.State.normal)
        animating = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmChange(_ sender: UIButton) {
        confirm.isHidden = true
        textView.isUserInteractionEnabled = false
        
        imageDesc[a] = textView.text!
        stepper(step)
        
        loop.isUserInteractionEnabled = true
        random.isUserInteractionEnabled = true
        duration.isUserInteractionEnabled = true
        anima.isUserInteractionEnabled = true
        load.isUserInteractionEnabled = true
        remove.isUserInteractionEnabled = true
        restore.isUserInteractionEnabled = true
        step.isUserInteractionEnabled = true
        changeDesc.isHidden = false
    }
    
    @IBAction func change(_ sender: UIButton) {
        confirm.isHidden = false
        textView.text = ""
        textView.isUserInteractionEnabled = true
        
        loop.isUserInteractionEnabled = false
        random.isUserInteractionEnabled = false
        duration.isUserInteractionEnabled = false
        anima.isUserInteractionEnabled = false
        load.isUserInteractionEnabled = false
        remove.isUserInteractionEnabled = false
        restore.isUserInteractionEnabled = false
        step.isUserInteractionEnabled = false
        changeDesc.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

