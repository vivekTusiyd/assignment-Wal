//
//  APODViewModel.swift
//  Walmart_assignment
//
//  Created by Aerologix Aerologix on 08/08/24.
//

import Foundation
import UIKit


class APODViewModel: NSObject {
    
    var isSuccess = Bindable<Bool>()
    var imageDataDictionary : Observable<ImageDataModel?> = Observable(nil)
    
    func getAPODImageData(_ controller : UIViewController, _ apiKey : String){
        NetworkService.sharedServiceSession.getMethodURLRequest(controller: controller, appendKey: apiKey) { (jsonDict ,responseCode) in
            print("\n\n Response : \(jsonDict)")
            if ((jsonDict as? NSDictionary)?["status_code"] as? Int) == 200 {
                let imageData =  ((jsonDict as? NSDictionary)?["data"] as? ImageDataModel)
                self.isSuccess.value = true
                self.imageDataDictionary.value = imageData
            }else{
                self.isSuccess.value = false
            }
        }
    }

}

