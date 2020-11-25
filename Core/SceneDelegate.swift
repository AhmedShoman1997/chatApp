//
//  SceneDelegate.swift
//  VarsKeyChat
//
//  Created by Ahmed Shoman on 7/4/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        
        if FUser.currentUser() != nil{
            
            let usersVC = UIStoryboard(name: "Users", bundle: nil).instantiateViewController(identifier: "usersNavigation")
            
            self.window?.rootViewController = usersVC
            
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }



}

