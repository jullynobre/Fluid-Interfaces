//
//  ViewController.swift
//  draw-tool
//
//  Created by Ada 2018 on 24/07/18.
//  Copyright © 2018 Academy 2018. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var cat: UIView!
    
    var animator: UIDynamicAnimator!
    var gravit: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!
    
    var pitukas = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cat.layer.cornerRadius = 75
        
                for _ in 0...10{
                    let pituka = UIView.init(frame: CGRect(x: CGFloat(arc4random_uniform(UInt32(view.frame.width))), y: CGFloat(arc4random_uniform(UInt32(view.frame.height))), width: 30.0, height: 30.0))
        
                    pituka.backgroundColor = UIColor.lightText
                    pituka.layer.cornerRadius = 15
                    view.addSubview(pituka)
                    pitukas.append(pituka)
                }
        
        animator = UIDynamicAnimator(referenceView: view)
        collision = UICollisionBehavior(items: [cat] + pitukas)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [cat] + pitukas)
        itemBehaviour.elasticity = 0.4
        animator.addBehavior(itemBehaviour)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func randomColor() -> UIColor {
        return UIColor.init(hue: CGFloat(drand48()), saturation: 0.3, brightness: 1, alpha: 1)
    }
    
}

extension SecondViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


