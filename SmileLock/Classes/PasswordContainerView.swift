

import UIKit
import LocalAuthentication

public protocol PasswordInputCompleteProtocol: class {
    func passwordInputComplete(passwordContainerView: PasswordContainerView, input: String)
    func touchAuthenticationComplete(passwordContainerView: PasswordContainerView, success: Bool, error: NSError?)
}

public class PasswordContainerView: UIView {
    
    //MARK: IBOutlet
    @IBOutlet public var passwordInputViews: [PasswordInputView]!
    @IBOutlet public weak var passwordDotView: PasswordDotView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var touchAuthenticationButton: UIButton!
    
    //MARK: Property
    public weak var delegate: PasswordInputCompleteProtocol?
    private var touchIDContext = LAContext()
    
    private var inputString: String = "" {
        didSet {
            passwordDotView.inputDotCount = inputString.characters.count
            checkInputComplete()
        }
    }
    
    public var isVibrancyEffect = false {
        didSet {
            configureVibrancyEffect()
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            guard !isVibrancyEffect else { return }
            deleteButton.setTitleColor(tintColor, forState: UIControlState())
            passwordDotView.strokeColor = tintColor
            touchAuthenticationButton.tintColor = tintColor
            passwordInputViews.forEach {
                $0.textColor = tintColor
                $0.borderColor = tintColor
            }
        }
    }
    
    public var highlightedColor: UIColor! {
        didSet {
            guard !isVibrancyEffect else { return }
            passwordDotView.fillColor = highlightedColor
            passwordInputViews.forEach {
                $0.highlightBackgroundColor = highlightedColor
            }
        }
    }
    
    public var isTouchAuthenticationAvailable: Bool {
        return touchIDContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    public var touchAuthenticationEnabled = false {
        didSet {
            let enable = (isTouchAuthenticationAvailable && touchAuthenticationEnabled)
            touchAuthenticationButton.alpha = enable ? 1.0 : 0.0
            touchAuthenticationButton.userInteractionEnabled = enable
        }
    }
    
    public var touchAuthenticationReason = "Touch to unlock"
    
    //MARK: AutoLayout
    public var width: CGFloat = 0 {
        didSet {
            self.widthConstraint.constant = width
        }
    }
    private let kDefaultWidth: CGFloat = 288
    private let kDefaultHeight: CGFloat = 410
    private var widthConstraint: NSLayoutConstraint!
    
//    private func configureConstraints() {
//        let ratioConstraint = widthAnchor.constraintEqualToAnchor(self.heightAnchor, multiplier: kDefaultWidth / kDefaultHeight)
//        self.widthConstraint = widthAnchor.constraintEqualToConstant(kDefaultWidth)
//        self.widthConstraint.priority = 999
//        NSLayoutConstraint.activateConstraints([ratioConstraint, widthConstraint])
//    }
    
    //MARK: VisualEffect
    public func rearrangeForVisualEffectView(in vc: UIViewController) {
        self.isVibrancyEffect = true
        self.passwordInputViews.forEach { passwordInputView in
            let label = passwordInputView.label
            label.removeFromSuperview()
            vc.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.addConstraints(fromView: label, toView: passwordInputView, constraintInsets: UIEdgeInsetsZero)
        }
    }
    
    //MARK: Init
    public class func create(withDigit digit: Int) -> PasswordContainerView {
        let bundle = NSBundle(forClass: self)
        let nib = UINib(nibName: "PasswordContainerView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! PasswordContainerView
        
        view.passwordDotView.totalDotCount = digit
        return view
    }
    
    public class func create(in containerView: UIView, digit: Int) -> PasswordContainerView {
        let passwordContainerView = create(withDigit: digit)
        containerView.addSubview(passwordContainerView)
        return passwordContainerView
    }
    
    //MARK: Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
//        configureConstraints()
        backgroundColor = UIColor.clearColor()
        passwordInputViews.forEach {
            $0.delegate = self
        }
        deleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteButton.titleLabel?.minimumScaleFactor = 0.5
        touchAuthenticationEnabled = true
        let image = touchAuthenticationButton.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate)
        touchAuthenticationButton.setImage(image, forState: UIControlState())
        touchAuthenticationButton.tintColor = tintColor
    }
    
    //MARK: Input Wrong
    public func wrongPassword() {
        passwordDotView.shakeAnimationWithCompletion {
            self.clearInput()
        }
    }
    
    public func clearInput() {
        inputString = ""
    }
    
    //MARK: IBAction
    @IBAction func deleteInputString(sender: AnyObject) {
        guard inputString.characters.count > 0 && !passwordDotView.isFull else {
            return
        }
        inputString = String(inputString.characters.dropLast())
    }
    
    @IBAction func touchAuthenticationAction(sender: UIButton) {
        guard isTouchAuthenticationAvailable else { return }
        touchIDContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: touchAuthenticationReason) { (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.passwordDotView.inputDotCount = self.passwordDotView.totalDotCount
                    // instantiate LAContext again for avoiding the situation that PasswordContainerView stay in memory when authenticate successfully
                    self.touchIDContext = LAContext()
                }
                self.delegate?.touchAuthenticationComplete(self, success: success, error: error)
            })
        }
    }
}

private extension PasswordContainerView {
    func checkInputComplete() {
        if inputString.characters.count == passwordDotView.totalDotCount {
            delegate?.passwordInputComplete(self, input: inputString)
        }
    }
    func configureVibrancyEffect() {
        let whiteColor = UIColor.whiteColor()
        let clearColor = UIColor.clearColor()
        //delete button title color
        var titleColor: UIColor!
        //dot view stroke color
        var strokeColor: UIColor!
        //dot view fill color
        var fillColor: UIColor!
        //input view background color
        var circleBackgroundColor: UIColor!
        var highlightBackgroundColor: UIColor!
        var borderColor: UIColor!
        //input view text color
        var textColor: UIColor!
        var highlightTextColor: UIColor!
        
        if isVibrancyEffect {
            //delete button
            titleColor = whiteColor
            //dot view
            strokeColor = whiteColor
            fillColor = whiteColor
            //input view
            circleBackgroundColor = clearColor
            highlightBackgroundColor = whiteColor
            borderColor = clearColor
            textColor = whiteColor
            highlightTextColor = whiteColor
        } else {
            //delete button
            titleColor = tintColor
            //dot view
            strokeColor = tintColor
            fillColor = highlightedColor
            //input view
            circleBackgroundColor = whiteColor
            highlightBackgroundColor = highlightedColor
            borderColor = tintColor
            textColor = tintColor
            highlightTextColor = highlightedColor
        }
        
        deleteButton.setTitleColor(titleColor, forState: .Normal)
        passwordDotView.strokeColor = strokeColor
        passwordDotView.fillColor = fillColor
        touchAuthenticationButton.tintColor = strokeColor
        passwordInputViews.forEach { passwordInputView in
            passwordInputView.circleBackgroundColor = circleBackgroundColor
            passwordInputView.borderColor = borderColor
            passwordInputView.textColor = textColor
            passwordInputView.highlightTextColor = highlightTextColor
            passwordInputView.highlightBackgroundColor = highlightBackgroundColor
            passwordInputView.circleView.layer.borderColor = UIColor.whiteColor().CGColor
            //borderWidth as a flag, will recalculate in PasswordInputView.updateUI()
            passwordInputView.isVibrancyEffect = isVibrancyEffect
        }
    }
}

extension PasswordContainerView: PasswordInputViewTappedProtocol {
    public func passwordInputView(passwordInputView: PasswordInputView, tappedString: String) {
        guard inputString.characters.count < passwordDotView.totalDotCount else {
            return
        }
        inputString += tappedString
    }
}
