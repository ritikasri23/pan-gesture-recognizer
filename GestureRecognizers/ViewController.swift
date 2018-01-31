//
//  ViewController.swift
//  GestureRecognizers
//
//  Created by Ritika Srivastava on 31/01/18.
//  Copyright © 2018 Ritika Srivastava. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var trashImageView: UIImageView!
    
    var imageViewOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add pan gesture to imageView
        addPanGesture(view: imageView)
        
        //Origin of the frame of imageView
        imageViewOrigin = imageView.frame.origin
        
        //Bring imageView to the top layer to avoid it going behind the trashImageView!
         view.bringSubview(toFront: imageView)
    }
    
    //Hide status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //Function that adds pan gesture to a UIView
    func addPanGesture(view: UIView) {
        
     let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }
    
    //Function that handles pan gesture
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
    //Be careful while force unwrapping! Make sure you have that object before you force unwrap.
        let imageViewSender = sender.view!
        
        switch sender.state {
    // 3 cases to handle pan gesture (.began, .changed, .ended)
            
    // .begin: When you start/begin the pan gesture
    // .changed: Tracks every movement throughout the gesture while you are still holding your finger onto the screen//*
        case .began, .changed:
            moveViewWithPanGesture(view: imageViewSender, sender: sender)
            
    // .ended: When you actually lift up your finger
        case .ended:
            if imageViewSender.frame.intersects(trashImageView.frame) {
                deleteImageView(view: imageViewSender)
                
            } else {
                returnViewToOrigin(view: imageViewSender)
            }
            
        default:
            break
        }
    }
    
    func moveViewWithPanGesture(view: UIView, sender: UIPanGestureRecognizer) {
        
        //Translation is the property of pan gesture recognizer that tracks the location and velocity of the movement of the pan. So here it is tracking the location and velocity of pan gesture within the main view of the screen.
        let translation = sender.translation(in: view)
        
        //Moving centre of the view along with gesture recognizer
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    //Moves imageView to its original position if we don't drag it in trashImageView
    func returnViewToOrigin(view: UIView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            view.frame.origin = self.imageViewOrigin
        })
    }
    
    //Deletes imageView with animation if it intersects the trashImageView
    func deleteImageView(view: UIView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0.0
        })
    }
}
