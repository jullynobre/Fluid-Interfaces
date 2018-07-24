//
//  ViewController.swift
//  draw-tool
//
//  Created by Ada 2018 on 24/07/18.
//  Copyright © 2018 Academy 2018. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var pinch: UIPinchGestureRecognizer!
    @IBOutlet var rotation: UIRotationGestureRecognizer!
    
    @IBOutlet weak var square: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setando o Delegate
        pinch.delegate = self
        rotation.delegate = self
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
    }
    
    @IBAction func didRotate(_ sender: Any) {
        let gesture: UIRotationGestureRecognizer = sender as! UIRotationGestureRecognizer
    
        gesture.view?.transform = (gesture.view?.transform)!.rotated(by: gesture.rotation)
        gesture.rotation = 0

        
    }
    
    @IBAction func didPinch(_ sender: Any) {
        let gesture: UIPinchGestureRecognizer = sender as! UIPinchGestureRecognizer
        
        gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
        gesture.scale = 1.0

    }
    
    
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}
extension ViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

