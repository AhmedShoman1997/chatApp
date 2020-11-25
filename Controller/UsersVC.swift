//
//  UsersVC.swift
//  VarsKeyChat
//
//  Created by Ahmed Shoman on 7/11/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UsersVC: UIViewController {

    //MARK: - Constants
    
    var users = [FUser]()
    
    //MARK: - outLet
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getUsers()
    }
    
    //MARK: - IBActions
    
    
    //MARK: - Helper Functions
    
    func setupUI(){
        tableView.tableFooterView = UIView()
        
        
        
        
        
        
    }
    
    func getUsers(){
        
        DBref.child(reference(.User)).observe(.value) { (snapshot) in
            
            if snapshot.value == nil{
                return
            }
            
            let snap = snapshot.value as! NSDictionary
            
            for user in snap.allValues as! [NSDictionary]{
                
                let user = FUser(_dictionary: user)
                
                if user.objectId != FUser.currentId(){
                    self.users.append(user)
                }
            }
            
            
            if self.users.count < 1{
                var emptyLBL = UILabel()
                emptyLBL = UILabel(frame: CGRect(x: 0, y: (ScreenHeight / 2) - 100, width: ScreenWidth, height: 30))
                emptyLBL.text = "Empty User Table"
                emptyLBL.textAlignment = .center
                emptyLBL.font = UIFont.boldSystemFont(ofSize: 20)
                emptyLBL.textColor = .systemYellow
                self.view.addSubview(emptyLBL)
            }
            
            print(self.users)
            
            self.tableView.reloadData()
            
        }
    }
    
}

extension UsersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! usersTCell
    
        cell.userNameLBL.text = users[indexPath.row].fullname
        cell.userEmailLBL.text = users[indexPath.row].email
        
        imageFromStringData(pictureData: users[indexPath.row].avatar) { (image) in
            
            if image != nil{
                cell.userImageView.image = image!.circleMasked
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let messageVC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(identifier: "MessagesVC") as! MessagesVC
        
        messageVC.users = [FUser.currentUser()!, users[indexPath.row]]
        messageVC.usersIDs = [FUser.currentId(), users[indexPath.row].objectId]
        
        messageVC.modalPresentationStyle = .fullScreen
        self.present(messageVC, animated: true, completion: nil)
        
    }
    
    
}
