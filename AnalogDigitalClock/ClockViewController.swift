//
//  ClockViewController.swift
//  AnalogDigitalClock
//
//  Created by Vinay Sharma on 28/06/22.
//

import UIKit

class ClockViewController: UIViewController {
    
    @IBOutlet weak var clockView: NeumorphicView!
    @IBOutlet weak var hourHand: UIImageView!
    @IBOutlet weak var mimuteHand: UIImageView!
    @IBOutlet weak var secondHand: UIImageView!
    @IBOutlet weak var progressBar: CircularProgressBar!
    
    @IBOutlet weak var centerGlowView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet var digitViews: [UIView]!
    var currentMinute = Float.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnalogClock()
        setupDigitalClock()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        typingAnimation(text: "Time takes it all,\nwhether you want it to or not.")
        centerGlowView.doGlowAnimation(withColor: .blue, withEffect: .normal)
        // Do any additional setup after loading the view.
    }
    
    //typing animation
    func typingAnimation(text: String, characterDelay: TimeInterval = 14.0) {
      quoteLabel.text = ""
        
      let writingAnimation = DispatchWorkItem { [weak self] in
        text.forEach { char in
          DispatchQueue.main.async {
              self?.quoteLabel?.text?.append(char)
          }
          Thread.sleep(forTimeInterval: characterDelay/100)
        }
      }
        
      let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
      queue.asyncAfter(deadline: .now() + 0.05, execute: writingAnimation)
    }
    
    //Removes white pixel from image
    func makeTransparent(rawImage: CGImage) -> CGImage? {
        let image = UIImage(cgImage: rawImage)
        let colorMasking: [CGFloat] = [255, 255, 255, 255, 255, 255]
        UIGraphicsBeginImageContext(image.size)
        
        if let maskedImage = rawImage.copy(maskingColorComponents: colorMasking),
            let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0.0, y: image.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(maskedImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return finalImage?.cgImage
        }
        
        return nil
    }
    
    func setupDigitalClock(){
        let digits = UIImage(named: "clockNumbers")
        
        for digitView in digitViews {
            digitView.layer.contents = makeTransparent(rawImage: (digits?.cgImage!)!)
            digitView.layer.contentsRect = CGRect(x: 0, y: 0, width: 0.1, height: 1.0)
            digitView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        }
    }
    
    func setupAnalogClock(){
        let bgColor = UIColor(displayP3Red: 0.86, green: 0.86, blue: 0.9, alpha: 1.0)
        
        self.view.backgroundColor = bgColor
        self.clockView.backgroundColor = bgColor
    }
    
    @objc private func update() {
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let units: Set<Calendar.Component> = [Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]
        let components = calendar.dateComponents(units, from: Date())
        
        let hoursAngle = (Float(components.hour!) / 12.0) * Float.pi * 2.0
        let minutesAngle = (Float(components.minute!) / 60.0) * Float.pi * 2.0
        let secondsAngle = (Float(components.second!) / 60.0) * Float.pi * 2.0
        if currentMinute != Float(components.minute!) {
            progressBar.setProgressWithAnimation(duration: 3, value: (Float(components.minute!) / 60.0))
        }
        currentMinute = Float(components.minute!)
        
        self.hourHand.transform = CGAffineTransform.init(rotationAngle: CGFloat(hoursAngle))
        self.mimuteHand.transform = CGAffineTransform.init(rotationAngle: CGFloat(minutesAngle))
        self.secondHand.transform = CGAffineTransform.init(rotationAngle: CGFloat(secondsAngle))
        
        // set hours
        self.setDigit(digit: components.hour! / 10, forView: digitViews[0])
        self.setDigit(digit: components.hour! % 10, forView: digitViews[1])

        // set minutes
        self.setDigit(digit: components.minute! / 10, forView: digitViews[2])
        self.setDigit(digit: components.minute! % 10, forView: digitViews[3])

        // set seconds
        self.setDigit(digit: components.second! / 10, forView: digitViews[4])
        self.setDigit(digit: components.second! % 10, forView: digitViews[5])

    }
    
    private func setDigit(digit: Int, forView view: UIView) {
        
        view.layer.contentsRect = CGRect(x: CGFloat(digit) * 0.1, y: 0, width: 0.1, height: 1.0)
        
    }
    
    
}

