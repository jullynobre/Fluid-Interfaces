//
//  ViewController.swift
//  draw-tool
//
//  Created by Ada 2018 on 24/07/18.
//  Copyright © 2018 Academy 2018. All rights reserved.
//

import UIKit
import CoreMotion

class SecondViewController: UIViewController {
    
    @IBOutlet weak var cat: UIView!
    
    var animator: UIDynamicAnimator!
    var gravit: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var snap: UISnapBehavior!
    var pushBehaviour: UIPushBehavior!
    
    let motionManager = CMMotionManager()
    var time = Timer()
    
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
        
        startGyro()
    }
    
    func startGyro() {
        
        if motionManager.isGyroAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates()
            
            
            // Configure a timer to fetch the accelerometer data.
            self.time = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: { (timer) in
                // Get the gyro data.
                if let acceleration = self.motionManager.accelerometerData?.acceleration {
                    var x = 0.0
                    var y = 0.0
                    
                    if (acceleration.x > 0.1) || (acceleration.x < -0.1) {
                        x = acceleration.x
                    }
                    if (acceleration.y > 0.1) || (acceleration.y < -0.1) {
                        y = acceleration.y
                    }
                    
                    let magnitude = sqrt((x * x) + (y * y))/25
                    
                    self.pushBehaviour = UIPushBehavior(items: self.pitukas, mode: .instantaneous)
                    self.pushBehaviour.pushDirection = CGVector(dx: x, dy: -y)
                    self.pushBehaviour.magnitude = CGFloat(magnitude)
                    self.animator.addBehavior(self.pushBehaviour)
                    
                }
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.time, forMode: .defaultRunLoopMode)
        }
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
