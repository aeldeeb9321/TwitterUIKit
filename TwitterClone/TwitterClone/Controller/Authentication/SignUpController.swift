//
//  SignUpController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    //setting a class level variable of our profile image so we can access it in multiple different methods
    private var profileImage: UIImage?
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo") , for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePic), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textfield: emailTextField)
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
        tf.delegate = self
        return tf
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),textfield: passwordTextField)
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
        tf.delegate = self
        return tf
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textfield: fullnameTextField)
        return view
    }()
    
    private lazy var fullnameTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Full Name", isSecureTextEntry: false)
        tf.delegate = self
        return tf
    }()
    
    private lazy var usernameContainerView: UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textfield: usernameTextField)
        return view
    }()
    
    private lazy var usernameTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Username", isSecureTextEntry: false)
        tf.delegate = self
        return tf
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton().authButton(withTitle: "Sign Up")
        button.addTarget(self, action: #selector(handleUserSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var haveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account? ", "Sign In")
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .twtrBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        addPhotoButton.setDimensions(height: 128, width: 128)
        addPhotoButton.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView, signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        view.addSubview(stack)
        
        stack.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(haveAccountButton)
        haveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        haveAccountButton.centerX(inView: view)
    }
    
    //MARK: - Selectors
    
    @objc private func handleAddProfilePic(sender: UIButton) {
        present(imagePicker, animated: true)
    }
    @objc private func handleUserSignUp(sender: UIButton){
        guard let profileImage = profileImage else{
            print("Please select a profile image")
            return
        }
        
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        guard let fullname = fullnameTextField.text else{return}
        guard let username = usernameTextField.text?.lowercased() else{return}
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        AuthService.shared.registerUser(credentials: credentials) { Error, ref in
        
            //getting access to the root vc
            guard let tab = self.presentingViewController as? MainTabController else{return}
            //since we have access to this tab controller we can call the authenticateuserConfigureUI so the user doesnt see a black screen when they log in
            tab.authenticateUserAndConfigureUI()
            //if log in is succesful we will dissmiss this loginController
            self.dismiss(animated: true)
        }
        
    }
    
    @objc private func handleGoToLogin(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else{return}
        self.profileImage = profileImage
        self.addPhotoButton.layer.cornerRadius = 128 / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        addPhotoButton.imageView?.clipsToBounds = true //makes sure image doesnt go outside the bounds of the frame
        //adding a border color
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        //we used .withRendering to get back our original image back, this is necessary to be done as it is a button
        self.addPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension SignUpController: UITextFieldDelegate {
    
}
