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
    
    // Initializing pictures
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
        
        // Convert image names to UIImages
        for temp in imageName{
            images.append(UIImage(named : temp)!)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // Basic loop to the next image
    @IBAction func loo(_ sender: UIButton) {
        repeat{
            a = (a + 1) % images.count
        }while(b.contains(a))
        
        imagev.image = images[a]
        textView.text = imageDesc[a]
    }
    
    // Loop to a random image
    @IBAction func rand(_ sender: UIButton) {
        repeat{
            a = Int.random(in: 0 ... images.count - 1)
        }while(b.contains(a))
        
        imagev.image = images[a]
        textView.text = imageDesc[a]
    }
    
    // Remove the current picture from the looping list
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
    
    // A stepper for selecting images to restore
    @IBAction func stepper(_ sender: UIStepper) {
        name.text = imageDesc[Int(sender.value)]
    }
    
    // Restore the selected images that was removed
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
    
    // Switching pictures automatically with time interval
    @IBAction func ani(_ sender: UIButton) {
        if !animating{
            anima.setTitle("Stop", for: UIControl.State.normal)
            
            /*var images : [UIImage] = []
            for imageN in imageName{
                images.append(UIImage(named: imageN)!)
            }*/
            
            var t : Double = 5 // Default value of interval in 5 seconds
            if duration.text != ""{
                t = Double(duration.text!)!
            }
            
            //Set the timer
            time = Timer.scheduledTimer(timeInterval: TimeInterval(t), target: self, selector: #selector(Action), userInfo: nil, repeats: true)
            
            animating = true
            
            /*imagev.animationDuration = TimeInterval(a)
            imagev.animationImages = images
            imagev.startAnimating()*/
            
        }else{
            // Stop the timer
            anima.setTitle("Animate", for: UIControl.State.normal)
            time.invalidate()
            animating = false
            
            /*imagev.stopAnimating()
            d = 0
            textView.text = imageDesc[d]*/
        }
    }
    
    // What will happen every time interval passes
    @objc func Action(){
        repeat{
            a = (a + 1) % images.count
        }while(b.contains(a))
        imagev.image = images[a]
        textView.text = imageDesc[a]
        newImageView.image = images[a]
    }
    
    var newImageView = UIImageView(image: UIImage(named: "ai.jpg"))
    
    // The function for fullscreen
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage)) // Connect this function with UITapGestureRecognizer
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
    
    // Load images from the photo library
    @IBAction func loadImage(_ sender: UIButton) {
        let ipc = UIImagePickerController() // Create an UIImagePickerController and set its properties
        ipc.delegate = self
        ipc.allowsEditing = false
        let actionSheet = UIAlertController(title: "Grant me access!", message: "Could I access your photo library please? ;)", preferredStyle: .actionSheet)
        /*actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            ipc.sourceType = .camera
            self.present(ipc, animated: true, completion: nil)
        }))*/
        actionSheet.addAction(UIAlertAction(title: "Sure _(:3」∠)_", style: .default, handler: {(action: UIAlertAction) in
            ipc.sourceType = .photoLibrary
            self.present(ipc, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "だが断る! (Noooooooo)", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagev.image = pickedImage
        
        // Add new image to the array of images and a blank description
        images.append(pickedImage)
        imageDesc.append("")
        a = images.count - 1
        step.maximumValue += 1
        
        // Dismiss the image picker
        picker.dismiss(animated: true, completion: nil)
        confirm.isHidden = false
        textView.text = ""
        textView.isUserInteractionEnabled = true
        
        // Disable all other buttons until a description is entered
        loop.isUserInteractionEnabled = false
        random.isUserInteractionEnabled = false
        duration.isUserInteractionEnabled = false
        anima.isUserInteractionEnabled = false
        load.isUserInteractionEnabled = false
        remove.isUserInteractionEnabled = false
        restore.isUserInteractionEnabled = false
        step.isUserInteractionEnabled = false
        changeDesc.isHidden = true
        
        // Stop the timer if the images are animating
        time.invalidate()
        anima.setTitle("Animate", for: UIControl.State.normal)
        animating = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Replace the original description with a new one inputted by the user
    @IBAction func confirmChange(_ sender: UIButton) {
        confirm.isHidden = true
        textView.isUserInteractionEnabled = false
        
        imageDesc[a] = textView.text!
        stepper(step) // Refresh the stepper
        
        // Enable all other buttons
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
        
        // Disable all other buttons until a description is entered
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

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        textView.endEditing(true)
        duration.endEditing(true)
    }
}

