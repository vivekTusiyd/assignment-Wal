//
//  APODViewModel.swift
//  Walmart_assignment
//
//  Created by Vivek Tusiyad on 08/08/24.
//

import Foundation
import UIKit


class APODViewModel: NSObject {
    
    var isSuccess = Bindable<Bool>()
    var imageDataDictionary : Observable<[String:Any]?> = Observable(nil)

    func getAPODImageData(_ controller : UIViewController, _ apiKey : String){
        NetworkService.sharedServiceSession.getMethodURLRequest(controller: controller, appendKey: apiKey) { (jsonDict ,responseCode) in
            print("\n\n Response : \(jsonDict)")
            if ((jsonDict as? NSDictionary)?["url"] as? String) != nil {
                let imageData = (jsonDict as? NSDictionary)
                self.isSuccess.value = true
                self.imageDataDictionary.value = imageData as? [String:Any]

            }else{
                self.isSuccess.value = false
                self.imageDataDictionary.value = nil
            }
        }
    }

}

