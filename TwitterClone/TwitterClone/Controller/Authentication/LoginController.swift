//
//  LoginController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit

class LoginController: UIViewController{
    //MARK: - Properties
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textfield: emailTextField)
        return view
    }()
    
    //this email text field will be added to our email ContainerView, we made our emailTextField outside the container view bc eventually we are going to need to grab the text from it later.
    private lazy var emailTextField: UITextField = {
        var tf = UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
        tf.tag = 1
        tf.delegate = self
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),textfield: passwordTextField)
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf =  UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
        tf.tag = 2
        tf.delegate = self
        return tf
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twtrBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleUserLogin), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .twtrBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(height: 165, width: 165)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 30, paddingLeft: 20, paddingRight: 32)
        
        view.addSubview(logInButton)
        logInButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 32, height: 50)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        signUpButton.centerX(inView: view)
    }
    
    //MARK: - Selectors
    @objc func handleUserLogin(sender: UIButton){
        print(123)
    }
    
    @objc func handleShowSignUp(sender: UIButton){
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension LoginController: UITextFieldDelegate{
    
}
