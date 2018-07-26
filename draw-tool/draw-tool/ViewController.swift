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
    @IBOutlet weak var cat: UIView!
    
    var animator: UIDynamicAnimator!
    var gravit: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!
    
    var pitukas = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cat.layer.cornerRadius = 75
        
//        for _ in 0...10{
//            let pituka = UIView.init(frame: CGRect(x: CGFloat(arc4random_uniform(UInt32(view.frame.width))), y: CGFloat(arc4random_uniform(UInt32(view.frame.height))), width: 30.0, height: 30.0))
//            
//            pituka.backgroundColor = UIColor.lightText
//            pituka.layer.cornerRadius = 15
//            view.addSubview(pituka)
//            pitukas.append(pituka)
//        }
        
        animator = UIDynamicAnimator(referenceView: view)
        collision = UICollisionBehavior(items: [cat] + pitukas)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [cat] + pitukas)
        itemBehaviour.elasticity = 0.4
        animator.addBehavior(itemBehaviour)
        
        
        pinch.delegate = self
        rotation.delegate = self
        collision.collisionDelegate = self

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

            let slideMultiplier = magnitude / 900
            let sliderFactor = 0.1 * slideMultiplier

            var finalPoint = CGPoint(x: gesture.view!.center.x + (velocity.x * sliderFactor),
                                     y: gesture.view!.center.y + (velocity.y * sliderFactor))

            finalPoint.x = min(max(finalPoint.x,cat.frame.width / 2), self.view.bounds.size.width - cat.frame.width / 2)
            finalPoint.y = min(max(finalPoint.y, cat.frame.height / 2), self.view.bounds.size.height - cat.frame.height / 2)

            UIView.animate(withDuration: Double(sliderFactor * 2), delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                gesture.view!.center = finalPoint },
                           completion: nil)
        }
    }
    
    @IBAction func didTap(_ sender: Any) {
        cat.backgroundColor = randomColor()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (snap != nil) {
            animator.removeBehavior(snap)
        }
        
        let touch = touches.first! as UITouch
        snap = UISnapBehavior(item: cat, snapTo: touch.location(in: view))
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

extension ViewController: UICollisionBehaviorDelegate{
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        //let item2View = item2 as! UIView
        //item2View.removeFromSuperview()
        print("Cutou a pitukinha")
    }
    
}

