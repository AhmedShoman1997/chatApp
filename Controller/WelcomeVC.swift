//
//  ViewController.swift
//  VarsKeyChat
//
//  Created by Ahmed Shoman on 7/4/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit
import ProgressHUD
import ImagePicker
import FirebaseAuth
import FirebaseDatabase

class WelcomeVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!{
        didSet{
            //emailTF.attributedPlaceholder = NSAttributedString(string: "My Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signBtnOutLet: UIButton!{
        didSet{
            signBtnOutLet.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var swipLBL: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    //MARK: - constants
    
    let leftSwip = UISwipeGestureRecognizer()
    let rightSwip = UISwipeGestureRecognizer()
    let imageGest = UITapGestureRecognizer()
    
    var avatarImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerGesture()
        swipActions()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func signBtnPressed(_ sender: UIButton) {
        
        if signBtnOutLet.titleLabel?.text == "Sign in"{
            
            signInBtnPressed()
            
        }else{
            
            signUpBtnPressed()
        }
    }
    
    //MARK: - Helper Functions
    
    func imagePickerGesture(){
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(imageGest)
        imageGest.addTarget(self, action: #selector(self.imageTapped))
    }
    
    @objc func imageTapped(){
        
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func swipActions(){
        leftSwip.direction = .left
        rightSwip.direction = .right
        
        self.view.isUserInteractionEnabled = true
        
        self.view.addGestureRecognizer(leftSwip)
        self.view.addGestureRecognizer(rightSwip)
        
        leftSwip.addTarget(self, action: #selector(self.SwipAction))
        rightSwip.addTarget(self, action: #selector(self.SwipAction))
    }
    
    @objc func SwipAction(){
        
        if signBtnOutLet.titleLabel?.text == "Sign in"{
            signBtnOutLet.setTitle("Sign up", for: .normal)
            nameTF.isHidden = false
            avatarImageView.isHidden = false
            swipLBL.text = "Swip to sign in"
        }else{
            signBtnOutLet.setTitle("Sign in", for: .normal)
            nameTF.isHidden = true
            avatarImageView.isHidden = true
            swipLBL.text = "Swip to sign up"
        }
        
    }
    
    func signInBtnPressed(){
        
        guard !emailTF.text!.isEmpty,
            !passwordTF.text!.isEmpty else {ProgressHUD.showError("Fill all fields") ;return}
        ProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (result, error) in
            
            if error != nil{
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            guard let uID = result?.user.uid else {return}
            
            
            DBref.child(reference(.User)).child(uID).observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (snapshot, error) in
                ProgressHUD.dismiss()
                ProgressHUD.showSuccess()
                
                guard let value = snapshot.value as? NSDictionary else {return}
                
                self.saveUserLocallyAndLogin(userDic: value)
            })
        }
        
    }
    
    func signUpBtnPressed(){
        
        guard !emailTF.text!.isEmpty,
            !passwordTF.text!.isEmpty
            ,!nameTF.text!.isEmpty else {ProgressHUD.showError("Fill all fields") ;return}
        
        guard avatarImage != nil else {ProgressHUD.showError("Select avatar image") ;return}
        ProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { (result, error) in
            
            
            if error != nil{
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            
            // result?.user.uid
            
            // save user at database
            
            guard let uID = result?.user.uid else {return}
            guard let uEmail = result?.user.email else {return}
            
            let avatar = imageToStringData(avatarImage: self.avatarImage!)
            
            let currentUser = FUser(_objectId: uID, _createdAt: Date(), _updatedAt: Date(), _email: uEmail, _fullname: self.nameTF.text!, _avatar: avatar)
            
            let userDic = userDictionaryFrom(user: currentUser)
            
            self.saveUserTodatabase(uID: uID, userDic: userDic)
        }
    }
    
    func saveUserTodatabase(uID: String, userDic: NSDictionary){
        DBref.child(reference(.User)).child(uID).setValue(userDic) { (error, _) in
            ProgressHUD.dismiss()
            ProgressHUD.showSuccess()
            
            if error == nil{
                self.saveUserLocallyAndLogin(userDic: userDic)
            }else{
                ProgressHUD.show(error?.localizedDescription ?? "")
            }
        }
    }
    
    func saveUserLocallyAndLogin(userDic: NSDictionary){
        
        saveUserLocally(fUser: FUser.init(_dictionary: userDic))
        self.goToRecents()
    }
    
    func goToRecents(){
        //TODO: - Recent
        
        let usersVC = UIStoryboard(name: "Users", bundle: nil).instantiateViewController(identifier: "usersNavigation")
        
        usersVC.modalPresentationStyle = .fullScreen
        
        self.present(usersVC, animated: true, completion: nil)
        
    }
}

extension WelcomeVC: ImagePickerDelegate{
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if images.count > 0{
            self.avatarImage = images.first
            self.avatarImageView.image = self.avatarImage!.circleMasked
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
