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
        
        square.layer.cornerRadius = 75
        
        //Setando o Delegate
        pinch.delegate = self
        rotation.delegate = self
        
        animator = UIDynamicAnimator(referenceView: view)
        
        collision = UICollisionBehavior(items: [square])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.4
        animator.addBehavior(itemBehaviour)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didDrag(_ sender: Any) {
        let gesture: UIPanGestureRecognizer = sender as! UIPanGestureRecognizer
        
        if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            
            if let view = gesture.view {
                let centerX = min(max(translation.x + view.center.x, view.frame.width / 2), self.view.bounds.size.width - view.frame.width / 2)
                let centerY = min(max(translation.y + view.center.y, view.frame.height / 2), self.view.bounds.size.height - view.frame.height / 2)
                
                view.center = CGPoint(x: centerX, y: centerY)
            }
            
            gesture.setTranslation(CGPoint.zero, in: view)
        } else if gesture.state == .ended {
            let velocity = gesture.velocity(in: view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            print(velocity)
            let slideMultiplier = magnitude / 900
            let sliderFactor = 0.1 * slideMultiplier
            
            var finalPoint = CGPoint(x: gesture.view!.center.x + (velocity.x * sliderFactor),
                                     y: gesture.view!.center.y + (velocity.y * sliderFactor))
            
            finalPoint.x = min(max(finalPoint.x,square.frame.width / 2), self.view.bounds.size.width - square.frame.width / 2)
            finalPoint.y = min(max(finalPoint.y, square.frame.height / 2), self.view.bounds.size.height - square.frame.height / 2)
            
            UIView.animate(withDuration: Double(sliderFactor * 2), delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                gesture.view!.center = finalPoint },
                           completion: nil)
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
        
        let maxScale = self.view.frame.width / (gesture.view?.frame.width)!
        
        if gesture.scale < maxScale {
            gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
        }
        
        gesture.scale = 1.0
    }
    
    func randomColor() -> UIColor {
        return UIColor.init(hue: CGFloat(drand48()), saturation: 0.3, brightness: 1, alpha: 1)
    }
    
}

extension ViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

