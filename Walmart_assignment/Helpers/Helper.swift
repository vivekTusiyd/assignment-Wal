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
        
    //date formatter
    func getDateTimeStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    //JPEG
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage? {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image
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

extension UIImage {
    var getWidthOfImage: CGFloat {
        get {
            let width = self.size.width
            return width
        }
    }
    var getHeightOfImage: CGFloat {
        get {
            let height = self.size.height
            return height
        }
    }
}

