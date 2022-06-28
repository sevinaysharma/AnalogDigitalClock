//
//  CircularProgressBar.swift
//  AnalogDigitalClock
//
//  Created by Vinay Sharma on 28/06/22.
//

import Foundation
import UIKit

@IBDesignable
class CircularProgressBar: UIView {

let shapeLayer = CAShapeLayer()
let trackLayer = CAShapeLayer()

override init(frame: CGRect) {
super.init(frame: frame)
}

required init?(coder aDecoder: NSCoder) {
super.init(coder: aDecoder)
}
  override func layoutSubviews() {
    addProgressBar(radius: 70, progress: 50)
  }
func addProgressBar(radius: CGFloat, progress: CGFloat) {
    layer.addSublayer(trackLayer)
    self.addGradient()
    update(startAngle: 140, endAngle: 0)
}
    
    func update(startAngle: Float, endAngle: Float) {
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 74, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)

        //TrackLayer
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 6.0
        trackLayer.lineCap = CAShapeLayerLineCap.round

        //BarLayer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        shapeLayer.lineWidth = 8.0
        //shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round

        //Rotate Shape Layer
       // shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)

        //Animation
    //    loadProgress(percentage: progress)

        //LoadLayers

//        self.setProgressWithAnimation(duration: 5, value: 0.7)
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        shapeLayer.strokeEnd = CGFloat(value)
        shapeLayer.add(animation, forKey: "animateprogress")
    }

  private func addGradient() {
    let gradient = CAGradientLayer()
      gradient.colors = [UIColor.init(hexString: "5384F7").cgColor,UIColor.init(hexString: "55B2EE").cgColor,UIColor.init(hexString: "57DEE5").cgColor]
    gradient.frame = bounds
    gradient.mask = shapeLayer
    layer.addSublayer(gradient)
  }
}
