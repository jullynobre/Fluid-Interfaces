//
//  ViewController.swift
//  draw-tool
//
//  Created by Ada 2018 on 24/07/18.
//  Copyright © 2018 Academy 2018. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var square: UIView!
    
    var lastRotation: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func didDrag(_ sender: Any) {
        let gesture: UIPanGestureRecognizer = sender as! UIPanGestureRecognizer
        
        
        switch gesture.state {

            case .changed:
                let translation = gesture.translation(in: view)
        
                let square = gesture.view
                
                let squareX = gesture.view?.center.x
                let squareY = gesture.view?.center.y
                
                square?.center = CGPoint(x: translation.x + squareX!, y: translation.y + squareY!)
            
                gesture.setTranslation(CGPoint.zero, in: view)
            case .ended:
                print("Gesture has ended")
            default:
                return
        }
        
    
    }
    
    @IBAction func didTap(_ sender: Any) {
        square.backgroundColor = randomColor()
        
        print("Fui tapeado :D")
    }
    
    @IBAction func didRotate(_ sender: Any) {
        let gesture: UIRotationGestureRecognizer = sender as! UIRotationGestureRecognizer
    
        var originalRotation = CGFloat()
        
        if gesture.state == .began {
            print("sender.rotation: \(gesture.rotation)")
            // sender.rotation renews everytime the rotation starts
            // delta value but not absolute value
            gesture.rotation = lastRotation
            
            // the last rotation is the relative rotation value when rotation stopped last time,
            // which indicates the current rotation
            originalRotation = gesture.rotation
            
        } else if gesture.state == .changed {
            
            let newRotation = gesture.rotation + originalRotation
            gesture.view?.transform = CGAffineTransform(rotationAngle: newRotation)
            
        } else if gesture.state == .ended {
            
            // Save the last rotation
            lastRotation = gesture.rotation
            
        }
        
//        if(gesture.state == .ended){
//            lastRotation = 0.0;
//        }
//
//        let rotation = 0.0 - (lastRotation - gesture.rotation)
//        // var point = rotateGesture.location(in: viewRotate)
//        let currentTrans = gesture.view?.transform
//        let newTrans = currentTrans!.rotated(by: rotation)
//        gesture.view?.transform = newTrans
//        lastRotation = gesture.rotation
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}

