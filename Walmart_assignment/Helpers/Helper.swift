//
//  Helper.swift
//  Walmart_assignment
//
//  Created by Vivek Tusiyad on 08/08/24.
//

import Foundation
import UIKit

class Helper : NSObject {
    
    class var sharedInstance:Helper {
        struct sharedInstance {
            static let instance = Helper()
        }
        return sharedInstance.instance
    }
    
    func showAlertViewWithTitle(_ title: String, with message: String,controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    //MARKS:- Show Response
    func internetNotAvailableAlertView(controller: UIViewController) {
        DispatchQueue.main.async(execute: {
            self.showAlertViewWithTitle(AlertType.kWarning, with: ConnectionFeedbackMessage.kInternetOffline, controller: controller)
        })
    }
    
    func internalServerErrorAlertView(controller: UIViewController)  {
        DispatchQueue.main.async(execute: {
            self.showAlertViewWithTitle(AlertType.kError, with: ConnectionFeedbackMessage.kInternalServerError, controller: controller)
        })
    }
    
    func errorAlertView(controller: UIViewController, error: NSError?) {
        DispatchQueue.main.async(execute: {
            self.showAlertViewWithTitle(AlertType.kError, with: (error?.localizedDescription)!, controller: controller)
        })
    }
    
    // MARK: - Check Date Format
    func checkDateFormat(dateString: String,outputFormat: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"  // input Format 1
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        if dateFormatter.date(from: dateString) != nil {
            let formattedDate = dateFormatter.date(from:dateString)!
            let localDate = formattedDate.toLocalTime()
            dateFormatter.dateFormat = outputFormat // Output Formated
            return dateFormatter.string(from: localDate)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSS"  // input Format 2
        if dateFormatter.date(from: dateString) != nil {
            let formattedDate = dateFormatter.date(from:dateString)!
            let localDate = formattedDate.toLocalTime()
            dateFormatter.dateFormat = outputFormat // Output Formated
            return dateFormatter.string(from: localDate)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"  // input Format 3
        if dateFormatter.date(from: dateString) != nil {
            let formattedDate = dateFormatter.date(from:dateString)!
            let localDate = formattedDate.toLocalTime()
            dateFormatter.dateFormat = outputFormat // Output Formated
            return dateFormatter.string(from: localDate)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  // input Format 4
        if dateFormatter.date(from: dateString) != nil {
            let formattedDate = dateFormatter.date(from:dateString)!
            let localDate = formattedDate.toLocalTime()
            dateFormatter.dateFormat = outputFormat // Output Formated
            return dateFormatter.string(from: localDate)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"   // input Format 5
        if dateFormatter.date(from: dateString) != nil {
            let formattedDate = dateFormatter.date(from:dateString)!
            dateFormatter.dateFormat = outputFormat // Output Formated
            let localDate = formattedDate.toLocalTime()
            return dateFormatter.string(from: localDate)
        }
        
        // invalid format
        return nil
    }
    
}

struct AlertType {
    static let kAlert : String  = "Alert"
    static let kError : String = "Error"
    static let kWarning : String = "Warning"
    static let kSuccess : String = "Success"
    static let kFailure : String = "Failure"
}

extension Date {
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}


