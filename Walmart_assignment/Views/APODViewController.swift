//
//  APODViewController.swift
//  Walmart_assignment
//
//  Created by Vivek Tusiyad on 08/08/24.
//

import UIKit

class APODViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewAPOD: UIImageView!
    @IBOutlet weak var textViewDescription: UITextView!
    
    var imageDataViewModel : APODViewModel = APODViewModel()
    let loader = UIActivityIndicatorView(style: .large)
    var imageDetailsObject : ImageDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        view.addSubview(loader)
        loader.center = view.center
        
        //First check if internet is connected or not
        if !NetworkMonitor.shared.isConnected {
            Helper.sharedInstance.internetNotAvailableAlertView(controller: self)
            
            // check data in locals
        }else{
            //Check if already open the image then don't hit the api
            getImageDataFromAPI()
        }
    }
    
    func getImageDataFromAPI(){
        imageDataViewModel.getAPODImageData(self, APIKey)
    }
    
    func getImageDetailsAPiObserver(){
        self.imageDataViewModel.isSuccess.bind{ response in
            
            switch response{
            case true:
                self.imageDataViewModel.imageDataDictionary.bind{ [self] response in
                    self.imageDetailsObject = response
                    
                    print(response as Any)
                    
                }
                break
            case false:
                break
            default:
                break
            }
            
        }
    }
    
    

    

}

