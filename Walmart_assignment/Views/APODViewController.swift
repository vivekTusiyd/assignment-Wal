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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        view.addSubview(loader)
        loader.center = view.center
        
        //First check if internet is connected or not
//        if !NetworkMonitor.shared.isConnected {
//            Helper.sharedInstance.internetNotAvailableAlertView(controller: self)
//            
//            // check data in locals
//        }else{
            //Check if already open the image then don't hit the api
            getImageDataFromAPI()
//        }
    }
    
    func getImageDataFromAPI(){
        imageDataViewModel.getAPODImageData(self, APIKey)
        
        getImageDetailsAPiObserver()
    }
    
    func getImageDetailsAPiObserver(){
        self.imageDataViewModel.isSuccess.bind{ response in
            
            switch response{
            case true:
                self.imageDataViewModel.imageDataDictionary.bind{ response in
                    
                    if let url = URL(string: (self.imageDataViewModel.imageDataDictionary.value?["url"] as? String) ?? "") {
                        self.loadImage(from: url, into: self.imageViewAPOD, loader: self.loader)
                    }
                    
                    DispatchQueue.main.async {
                        self.labelTitle.text = self.imageDataViewModel.imageDataDictionary.value?["title"] as? String
                        self.textViewDescription.text = self.imageDataViewModel.imageDataDictionary.value?["explanation"] as? String
                    }
                }
                break
            case false:
                break
            default:
                break
            }
            
        }
    }

    func fetchImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }

    func loadImage(from url: URL, into imageView: UIImageView, loader: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            loader.startAnimating()
        }
        fetchImage(from: url) { data in
            DispatchQueue.main.async {
                loader.stopAnimating()
                if let data = data {
                    imageView.image = UIImage(data: data)
                    
                    
                }
            }
        }
    }

    
    

    

}

