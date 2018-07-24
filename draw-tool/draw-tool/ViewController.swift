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
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}

