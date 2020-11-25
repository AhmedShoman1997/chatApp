//
//  Refrences.swift
//  MyChatTest
//
//  Created by Ahmed Shoman on 3/9/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import Foundation

enum FCollectionReference: String {
    
    case User
    case Recent
    case Message
}


func reference(_ collectionReference: FCollectionReference) -> String{
    return collectionReference.rawValue
}
