//
//  UIExtension.swift
//  QBCloud
//
//  Created by gaoshanyu on 8/25/16.
//  Copyright © 2016 raniys. All rights reserved.
//

import UIKit

public extension UIColor {
    
    // hex sample: 0xf43737
    convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green: CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha: CGFloat(255 * alpha) / 255)
    }
    
    convenience init(hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }
    
}

public extension UIImage {
    
    /// To make screenshot
    ///
    /// - returns: image of screenshot
    public var screenShot: UIImage {
    
        let window = UIApplication.shared.keyWindow
        
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
        
            UIGraphicsBeginImageContextWithOptions(window!.bounds.size, false, UIScreen.main.scale)
        
        } else {
        
            UIGraphicsBeginImageContext(window!.bounds.size)
        
        }
        
        window?.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /// To make the image always up
    ///
    /// - returns: image of corrected
    func transformImageTocorrectDirection() -> UIImage {
        
        var image = self
        
        if self.imageOrientation != .up {
            
            var transform = CGAffineTransform.identity
            
            switch self.imageOrientation {
            case .down, .downMirrored:
                transform = transform.translatedBy(x: self.size.width, y: self.size.height)
                transform = transform.rotated(by: CGFloat(Double.pi))
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: self.size.width, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi))
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: self.size.height)
                transform = transform.rotated(by: -CGFloat(Double.pi))
            default:
                break
            }
            
            switch self.imageOrientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: self.size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .rightMirrored, .leftMirrored:
                transform = transform.translatedBy(x: self.size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            default:
                break
            }
            
            let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                            bitsPerComponent: (self.cgImage?.bitsPerComponent)!, bytesPerRow: 0,
                                            space: (self.cgImage?.colorSpace!)!,
                                            bitmapInfo: (self.cgImage?.bitmapInfo.rawValue)!)
            
            ctx?.concatenate(transform)
            
            ctx?.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
            
            image = UIImage(cgImage: (ctx?.makeImage()!)!)
            
        }
        
        return image
    }
}


public extension UIView {
    
    /// To find the parent ViewController for current view
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

public extension UIViewController {
    
    func showNotifyAlert(_ title: String, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        
        let yesAction = UIAlertAction(title: "确认", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


