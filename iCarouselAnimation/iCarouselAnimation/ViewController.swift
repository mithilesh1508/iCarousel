//
//  ViewController.swift
//  iCarouselAnimation
//
//  Created by Mithilesh Kumar on 16/04/22.
//

import UIKit
func degreeToRadian(angle:CGFloat) -> CGFloat {
    return (angle * CGFloat.pi)/180
}

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    let transformLayer = CATransformLayer()
    var currentAngle:CGFloat = 0
    var currentOffset:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        transformLayer.frame = self.view.bounds
        self.view.layer.addSublayer(transformLayer)
        
        for i in 1...6{
            addingImage(imageName: "\(i)")
        }
        turnOnCarousel()
        
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panGesture(recognizer:)))
        self.view.addGestureRecognizer(pangesture)
    }
    
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer)  {
        let xOffset = recognizer.translation(in: self.view).x
        if recognizer.state == .began {
            currentOffset = 0
        }
        let xDifference = xOffset - currentOffset
        currentOffset += xDifference
        currentAngle += xDifference
        turnOnCarousel()
    }
    
    func  turnOnCarousel() {
        guard let transformSublayers = transformLayer.sublayers else {
            return
        }
        let segment = CGFloat(360 / transformSublayers.count)
        var angleOffset = currentAngle
        
        for layer in transformSublayers {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 600
            transform = CATransform3DRotate(transform, degreeToRadian(angle: angleOffset), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            CATransaction.setAnimationDuration(0)
            layer.transform = transform
            angleOffset += segment
        }
    }
    
    func addingImage (imageName: String)
    {
        let imageCardSize = CGSize(width: 200, height: 156)
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: self.view.frame.size.width / 2 - imageCardSize.width / 2 , y: self.view.frame.size.height / 2 - imageCardSize.height / 2, width: imageCardSize.width, height: imageCardSize.height)
        
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        guard  let cardImage = UIImage(named: imageName)?.cgImage else {
            return
        }
        imageLayer.contents = cardImage
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.masksToBounds = true
        imageLayer.isDoubleSided = true
        imageLayer.borderColor = UIColor.init(white: 1, alpha: 0.5).cgColor
        imageLayer.borderWidth = 5
        imageLayer.cornerRadius = 10
        //view.layer.addSublayer(imageLayer)
        transformLayer.addSublayer(imageLayer)
    }

}

