//
//  Extensions.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit

extension UIView {
    
    func inputContainerView(withImage image: UIImage, textfield: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 0.87
        view.addSubview(imageView)
        
        imageView.centerY(inView: view) //vertically centering it in the view
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, height: 24, width: 24)
        view.addSubview(textfield)
        textfield.centerY(inView: view)
        textfield.anchor(left: imageView.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        
        let divider = UIView()
        divider.backgroundColor = .white
        view.addSubview(divider)
        divider.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 0.75)
        
        return view
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, height: CGFloat? = nil, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    //vertically center any UIelement we want inside any view we want
    func centerX(inView view: UIView,topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            anchor(top: topAnchor, paddingTop: paddingTop)
        }
    }
    
    //horizontally center any UIelement we want inside any view we want, if we dont give a constant value it is defaulted to 0
    func centerY(inView view: UIView, constant: CGFloat = 0, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        //if we pass that left anchor in then we will anchor to the left side of any view we need it for
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let twtrBlue = UIColor.rgb(red: 29, green: 161, blue: 242)
    
}

extension UITextField {
    func textField(withPlaceholder placeholder: String, isSecureTextEntry: Bool) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .white
        tf.isSecureTextEntry = isSecureTextEntry
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return tf
    }
}

extension UILabel {
    func uiLabel(withText: String? = nil, font: UIFont?, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = withText
        label.font = font
        label.textColor = textColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }
}

extension UIButton {
    func authButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.twtrBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        return button
    }
    
    func tweetButton(imageName: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(height: 20, width: 20)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}
