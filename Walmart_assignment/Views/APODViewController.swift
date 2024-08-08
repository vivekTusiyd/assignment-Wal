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
        NetworkMonitor.shared.startMonitoring()

        view.addSubview(loader)
        loader.center = view.center
        
        //Due to late response from Network library, added 1 sec delay to fetch correct network data  
        sleep(1)
        
        //First check if internet is connected or not
        if !NetworkMonitor.shared.isConnected {
            
            //check if data is there in local db
            checkLocalDBSupport(isNetworkAvailable: false)
        }else{
            //Check if already open the image then don't hit the api
            checkLocalDBSupport(isNetworkAvailable: true)
        }
    }
    
    //MARK: - Local DB Support check
    func checkLocalDBSupport(isNetworkAvailable: Bool) {
        // check data in locals
        if let imageData: ImageDataEntity = LocalDataModel.shared.fetchImageDetailsFromDB() {
            if let isVisited = imageData.value(forKey: "isVisited") as? Bool, isVisited == true {
                if let base64String = imageData.value(forKey: "imageData") as? String {
                    if let image = Helper.sharedInstance.convertBase64StringToImage(imageBase64String: base64String) {
                        DispatchQueue.main.async {
                            self.imageViewAPOD.image = image
                        }
                    }
                }
                if let title = imageData.value(forKey: "title") as? String {
                    DispatchQueue.main.async {
                        self.labelTitle.text = title
                    }
                }
                if let desc = imageData.value(forKey: "explanation") as? String {
                    DispatchQueue.main.async {
                        self.textViewDescription.text = desc
                    }
                }
            }
        }else{
            if isNetworkAvailable {
                getImageDataFromAPI()
            }else{
                Helper.sharedInstance.internetNotAvailableAlertView(controller: self)
            }
        }
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
                    
                    let base64String = Helper.sharedInstance.convertImageToBase64String(img: imageView.image ?? UIImage())
                    LocalDataModel.shared.insertUpdateImageDetailsToDB(imageDict: self.imageDataViewModel.imageDataDictionary.value! as NSDictionary, base64imageData: base64String)
                }
            }
        }
    }

    

}

