//
//  DetailViewController.swift
//  Shots
//
//  Created by chaoyang805 on 16/6/21.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class DetailViewController: ViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    var data: [[String : String]] = []
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: data[currentPage]["image"]!)
        avatarImageView.image = UIImage(named: data[currentPage]["avatar"]!)
        authorLabel.text = data[currentPage]["author"]
        descriptionTextView.text = data[currentPage]["text"]
        descriptionTextView.setAttributeText(fromFontName: "Libertad", fontSize: 16, lineSpacing: 7)
        backButton.alpha = 0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backButton.alpha = 1
        springScaleFrom(view: backButton, x: -100, y: 0, scaleX: 0.5, scaleY: 0.5)
    }
    
    @IBAction func backButtonDidTouch(sender: UIButton) {
        performSegue(withIdentifier: "HomeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HomeSegue" {
            if let toView = segue.destinationViewController as? HomeViewController {
                toView.data = data
                toView.currentPage = currentPage
                
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

extension UITextView {
    
    func setAttributeText(fromFontName name: String, fontSize: CGFloat, lineSpacing: CGFloat) {
        let font = UIFont(name: name, size: fontSize)
        let text = self.text
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text!, attributes: [
            NSParagraphStyleAttributeName : paragraphStyle,
            NSFontAttributeName : font!
            ])
        self.attributedText = attributedString
    }

}
