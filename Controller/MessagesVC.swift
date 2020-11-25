//
//  MessagesVC.swift
//  VarsKeyChat
//
//  Created by Ahmed Shoman on 7/18/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit
import ImagePicker

class MessagesVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBodyTF: UITextField!
    @IBOutlet weak var sendTextMessageBtnOutLet: UIButton!
    @IBOutlet weak var sendImageMessageBtnOutLet: UIButton!
    
    
    //MARK: - Constants
    
    var users: [FUser]!
    var usersIDs: [String]!
    var chatRoomId: String!
    var messages: [Messages]!
    
    var messageImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messages = []
        recivingMessages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        chatRoomId = createChatRoomId(chatRomIds: usersIDs)
    }
    
    //MARK: - IBActions
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        if messageBodyTF.text != ""{
            
            sendTextMessageBtnOutLet.isEnabled = false
            
            messageContent(text: messageBodyTF.text!, image: nil)
        }
        
    }
    
    @IBAction func uploadImageBtnPressed(_ sender: UIButton) {
        
        let imagePickerVC = ImagePickerController()
        imagePickerVC.imageLimit = 1
        imagePickerVC.delegate = self
        
        
        self.present(imagePickerVC, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    
    
    func messageContent(text: String?, image: String?){
        
        if let text = text{
            let messageId = UUID().uuidString
            
            let encreptedText = Encryption.encryptText(chatRoomId: chatRoomId, message: text)
            
            let messageBody = OutgoingMessages(message: encreptedText, senderId: FUser.currentId(), senderName: FUser.currentUser()!.fullname, date: Date(), messageType: messageType(.text), type: kPRIVATE, messageId: messageId)
            
            messageBody.sendMessage(chatRoomId: chatRoomId, messageDictionary: messageBody.messagesDictionary, membersIds: usersIDs)
            
            messageBodyTF.text = ""
            sendTextMessageBtnOutLet.isEnabled = true
        }
        
        if let image = image{
            let messageId = UUID().uuidString
            
            let encreptedText = Encryption.encryptText(chatRoomId: chatRoomId, message: "Image")
            
            let messageBody = OutgoingMessages(message: encreptedText, senderId: FUser.currentId(), senderName: FUser.currentUser()!.fullname, date: Date(), messageType: messageType(.image), imageLink: image, type: kPRIVATE, messageId: messageId)
            
            messageBody.sendMessage(chatRoomId: chatRoomId, messageDictionary: messageBody.messagesDictionary, membersIds: usersIDs)
        }
        
    }
    
    func recivingMessages(){
        
        DBref.child(reference(.Message)).child(FUser.currentId()).child(chatRoomId).queryOrdered(byChild: kDATE).observe(.childAdded) { (snapshot) in
        
            let snap = snapshot.value as! NSDictionary
            
            let message = Messages(_dictionary: snap)
            
            self.messages.append(message)
            
            self.tableView.reloadData()
            self.scrollToLastCell()
        }
    }
    
    func scrollToLastCell(){
        
        if messages.count > 0{
            
            let index = IndexPath(row: messages.count - 1, section: 0)
            
            tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
}

extension MessagesVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let decryptMessage = Encryption.decryptText(chatRoomId: chatRoomId, encryptedMessage: messages[indexPath.row].message)
        
        if messages[indexPath.row].messageType == messageType(.text){
            if messages[indexPath.row].senderId == FUser.currentId(){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "stcell", for: indexPath) as! senderTextCell
                
                let decryptMessage = Encryption.decryptText(chatRoomId: chatRoomId, encryptedMessage: messages[indexPath.row].message)
                
                cell.messageBodyLBL.text = decryptMessage
                cell.dateLBL.text = formatCallTime(date: messages[indexPath.row].date)
                
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "rtcell", for: indexPath) as! recieverTextCell
                
                cell.messageBodyLBL.text = decryptMessage
                cell.dateLBL.text = formatCallTime(date: messages[indexPath.row].date)
                
                return cell
            }
        }else{
            if messages[indexPath.row].senderId == FUser.currentId(){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "sicell", for: indexPath) as! SenderImageCell
                
                downloadImage(imageUrl: messages[indexPath.row].picture) { (Img) in
                    
                    if let Img = Img {
                        cell.imageMessageView.image = Img
                    }
                }
                
                cell.dateLBL.text = formatCallTime(date: messages[indexPath.row].date)
                
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ricell", for: indexPath) as! RecieverImageCell
                
                downloadImage(imageUrl: messages[indexPath.row].picture) { (Img) in
                    
                    if let Img = Img {
                        cell.imageMessageView.image = Img
                    }
                }
                
                cell.dateLBL.text = formatCallTime(date: messages[indexPath.row].date)
                
                return cell
            }
        }
    }
    
    
}

extension MessagesVC: ImagePickerDelegate{
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if images.count > 0{
            
            messageImage = images.first!
            
            //TODO : - upload image to Storage
                // return image url
            uploadImage(image: messageImage!, chatRoomId: chatRoomId, view: self.view) { (strImage) in
                
                if let image = strImage{
                    //TODO : - use image to send message with image url to firebase database
                    
                    self.messageContent(text: nil, image: image)
                }
            }
            
            
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
