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
    
    var animator: UIDynamicAnimator!
    var gravit: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setando o Delegate
        pinch.delegate = self
        rotation.delegate = self
        
        animator = UIDynamicAnimator(referenceView: view)
        
        gravit = UIGravityBehavior(items: [square])
        animator.addBehavior(gravit)
        
        collision = UICollisionBehavior(items: [square])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (snap != nil) {
            animator.removeBehavior(snap)
        }
        
        let touch = touches.first! as UITouch
        snap = UISnapBehavior(item: square, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
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

