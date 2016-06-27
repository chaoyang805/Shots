//
//  HomeViewController.swift
//  Shots
//
//  Created by chaoyang805 on 16/6/21.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundMaskView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var popoverView: DesignableView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var maskButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var shareLabels: UIView!
    
    var currentPage = 0
    var data = getData()
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = insertBlurView(backgroundMaskView, style: .dark)
        let _ = insertBlurView(headerView, style: .dark)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        dialogView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let translation = CGAffineTransform(translationX: 0, y: -200)
        dialogView.transform = scale.concat(translation)
        
        spring(withDuration: 0.5) {
            self.dialogView.transform = CGAffineTransform.identity
        }
        avatarImageView.image = UIImage(named: data[currentPage]["avatar"]!)
        backgroundImageView.image = UIImage(named: data[currentPage]["image"]!)
        imageButton.setImage(UIImage(named: data[currentPage]["image"]!), for: [])
        authorLabel.text = data[currentPage]["author"]
        titleLabel.text = data[currentPage]["title"]
        
        dialogView.alpha = 1
        
    }
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravityBehavior: UIGravityBehavior!
    var snapBehavior: UISnapBehavior?
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let boxLocation = sender.location(in: dialogView)
        let myView = dialogView
        let state = sender.state
        switch state {
        case .began:
            if let snap = snapBehavior {
                animator.removeBehavior(snap)
            }
            let centerOffset = UIOffsetMake(boxLocation.x - myView!.bounds.midX, boxLocation.y - myView!.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: myView!, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            animator.addBehavior(attachmentBehavior)
        case .changed:
            attachmentBehavior.anchorPoint = location
        case .ended:
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView!, snapTo: view.center)
            animator.addBehavior(snapBehavior!)
            
            let translation = sender.translation(in: view)
            if translation.y > 100 {
                animator.removeAllBehaviors()
                gravityBehavior = UIGravityBehavior(items: [myView!])
                gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 10.0)
                animator.addBehavior(gravityBehavior)
                
                delay(0.3) {
                    self.refreshData()
                }
            }
        default:
            break
        }
    }
    
    func refreshData() {
        animator.removeAllBehaviors()
        snapBehavior = UISnapBehavior(item: dialogView, snapTo: view.center)
        dialogView.center = view.center
        attachmentBehavior.anchorPoint = view.center
        
        currentPage = (currentPage + 1) % data.count
        viewDidAppear(true)
    }
    
    
    func hideShareView() {
        spring(withDuration: 0.5) {
            self.dialogView.transform = CGAffineTransform.identity
            self.shareView.isHidden = true
        }
    }
    
    func hidePopover() {
        spring(withDuration: 0.5) {
            self.popoverView.isHidden = true
        }
    }
    @IBAction func likeButtonDidTouch(_ sender: UIButton) {
        
    }
    @IBAction func maskButtonDidTouch(_ sender: UIButton) {
        spring(withDuration: 0.5) {
            self.maskButton.alpha = 0
        }
        hideShareView()
        hidePopover()
        
    }
    
    func showMask() {
        maskButton.isHidden = false
        maskButton.alpha = 0
        spring(withDuration: 0.5) {
            self.maskButton.alpha = 1
        }
    }
    
    @IBAction func shareButtonDidTouch(_ sender: UIButton) {
        shareView.isHidden = false
        
        showMask()
        
        shareView.transform = CGAffineTransform(translationX: 0, y: 200)
        emailButton.transform = CGAffineTransform(translationX: 0, y: 200)
        twitterButton.transform = CGAffineTransform(translationX: 0, y: 200)
        facebookButton.transform = CGAffineTransform(translationX: 0, y: 200)
        self.shareLabels.alpha = 0
        
        spring(withDuration: 0.5) {
            self.shareView.transform = CGAffineTransform.identity
            self.dialogView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        spring(withDuration: 0.5, delay: 0.05) {
            self.emailButton.transform = CGAffineTransform.identity
        }
        
        spring(withDuration: 0.5, delay: 0.10) {
            self.twitterButton.transform = CGAffineTransform.identity
        }
        
        spring(withDuration: 0.5, delay: 0.15) {
            self.facebookButton.transform = CGAffineTransform.identity
        }
        spring(withDuration: 0.5, delay: 0.20) {
            self.shareLabels.alpha = 1
        }
        
    }
    
    @IBAction func userButtonDidTouch(_ sender: UIButton) {
        popoverView.isHidden = false
        popoverView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3).concat(CGAffineTransform(translationX: 50, y: -50))
        popoverView.alpha = 0
        
        showMask()
        
        spring(withDuration: 0.3) {
            self.popoverView.alpha = 1
            self.popoverView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func imageButtonDidTouch(_ sender: UIButton) {
        
        
        spring(withDuration: 0.5, delay: 0, animations: {
            self.dialogView.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
            self.dialogView.layer.cornerRadius = 0
            
            self.imageButton.frame = CGRect(x: 0, y: 0, width: 320, height: 240)
            self.userButton.alpha = 0
            self.likeButton.alpha = 0
            self.shareButton.alpha = 0
            self.headerView.alpha = 0
        }) { done in
            
            self.performSegue(withIdentifier: "DetailSegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue" {
            if let toView = segue.destinationViewController as? DetailViewController {
                toView.data = self.data
                toView.currentPage = self.currentPage
            }
        }
    }
    
    
}

extension UIViewController {
    func spring(withDuration duration: TimeInterval, animations: (() -> Void)) {
        spring(withDuration: duration, delay: 0, animations: animations)
    }
    
    func spring(withDuration duration: TimeInterval, delay: TimeInterval, animations: (() -> Void)) {
        spring(withDuration: duration, delay: delay, animations: animations, completion: nil)
    }
    
    func spring(withDuration duration: TimeInterval, delay: TimeInterval, animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveLinear, animations: animations, completion: completion)
    }
    
    func springScaleFrom (view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
        let translation = CGAffineTransform(translationX:x, y: y)
        let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
        view.transform = translation.concat(scale)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
            
            view.transform = CGAffineTransform.identity
            
            }, completion: nil)
    }
}
