//
//  HelperFunctions.swift
//  MyChatTest
//
//  Created by Ahmed Shoman on 3/9/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit

//MARK: GLOBAL FUNCTIONS
private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
    
    // Usage
    /*
     let x = dateFormatter().string(from: <#T##Date#>)
     let y = dateFormatter().date(from: <#T##String#>)
     */
}

// Time

func timeElapsed(date: Date) -> String {
    
    let seconds = NSDate().timeIntervalSince(date)
    
    var elapsed: String?
    
    
    if (seconds < 60) {
        elapsed = "Just now"
    } else if (seconds < 60 * 60) {
        let minutes = Int(seconds / 60)
        
        var minText = "min"
        if minutes > 1 {
            minText = "mins"
        }
        elapsed = "\(minutes) \(minText)"
        
    } else if (seconds < 24 * 60 * 60) {
        let hours = Int(seconds / (60 * 60))
        var hourText = "hour"
        if hours > 1 {
            hourText = "hours"
        }
        elapsed = "\(hours) \(hourText)"
    } else {
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "yyyy-MM-dd"
        
        elapsed = "\(currentDateFormater.string(from: date))"
    }
    
    return elapsed!
}

func formatCallTime(date: Date) -> String {
    
    let seconds = NSDate().timeIntervalSince(date)
    
    var elapsed: String?
    
    
    if (seconds < 60) {
        elapsed = "Just now"
    }  else if (seconds < 24 * 60 * 60) {
       
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "HH:mm:ss"

        elapsed = "\(currentDateFormater.string(from: date))"
    } else {
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        elapsed = "\(currentDateFormater.string(from: date))"
    }
    
    return elapsed!
}

// read time status "HH:MM"

func readTimeFrom(dateString: String) -> String{
    
    let date = dateFormatter().date(from: dateString)
    
    let CurrentDateFormat = dateFormatter()
    CurrentDateFormat.dateFormat = "HH:mm:ss"
    
    return CurrentDateFormat.string(from: date!)
}


func imageFromStringData(pictureData: String, withBlock: (_ image: UIImage?) -> Void) {
    
    var image: UIImage?
    
    let decodedData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    image = UIImage(data: decodedData! as Data)
    
    withBlock(image)
}

func imageToStringData(avatarImage: UIImage) -> String{
    
    guard let imgData = avatarImage.jpegData(compressionQuality: 0.5) else {return ""}
    
    let imgString = imgData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    
    // let StringImg = imgData.base64EncodedData(options: Data.Base64EncodingOptions(rawValue: 0))
    
    return imgString
}
