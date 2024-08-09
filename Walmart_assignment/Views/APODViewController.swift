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
    @IBOutlet weak var imageViewAPODHeight: NSLayoutConstraint!
    @IBOutlet weak var labelDescription: UILabel!
    
    var imageDataViewModel : APODViewModel = APODViewModel()
    let loader = UIActivityIndicatorView(style: .large)
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkMonitor.shared.startMonitoring()

        imageViewAPOD.addSubview(loader)
        loader.center = imageViewAPOD.center
        
        //Added 1 sec delay to fetch correct connection status before calling the api
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
        // if Network not there and user already seen image for today then show from DB w/o hitting api
        if !isNetworkAvailable {
            let imageData: [ImageDataEntity] = LocalDataModel.shared.fetchImageDetailsFromDB()
            
            if let isDayToday = imageData.last?.value(forKey: "date") as? String, isDayToday.elementsEqual( Helper.sharedInstance.getDateTimeStringFromDate(Date())) {
                
                if let isVisited = imageData.last?.value(forKey: "isVisited") as? Bool, isVisited == true {
                    
                    fetchExistingDataAndUpdateUI(imageData)
                }
            }else {
                // if Network not there and user has not seen APOD today then show the alert with last image or show error message if DB is empty.
                let alert = UIAlertController(title: AlertType.kAlert, message: ConnectionFeedbackMessage.kNotConnectedToInternet, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    self.fetchExistingDataAndUpdateUI(imageData, true)
                }
                
                alert.addAction(alertAction)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            let imageData: [ImageDataEntity] = LocalDataModel.shared.fetchImageDetailsFromDB()
            
            if let isDayToday = imageData.last?.value(forKey: "date") as? String, isDayToday.elementsEqual( Helper.sharedInstance.getDateTimeStringFromDate(Date())) {
            
                if let isVisited = imageData.last?.value(forKey: "isVisited") as? Bool, isVisited == true {
                    
                    fetchExistingDataAndUpdateUI(imageData)
                }else{
                    getImageDataFromAPI()
                }
            }else {
                getImageDataFromAPI()
            }
            
        }
    }
    
    //Fetch saved data and reflect in UI
    func fetchExistingDataAndUpdateUI(_ imageData: [ImageDataEntity], _ isExtremeEdgeCase: Bool = false) {
        if let base64String = imageData.last?.value(forKey: "imageData") as? String {
            if let image = Helper.sharedInstance.convertBase64StringToImage(imageBase64String: base64String) {
                DispatchQueue.main.async {
                    self.imageViewAPOD.image = image
                }
            }
        }
        if let title = imageData.last?.value(forKey: "title") as? String {
            DispatchQueue.main.async {
                self.labelTitle.text = title
            }
        }
        if let desc = imageData.last?.value(forKey: "explanation") as? String {
            DispatchQueue.main.async {
                self.labelDescription.text = desc
            }
        }
        
        //Show alert for extreme edge case
        if isExtremeEdgeCase {
            Helper.sharedInstance.internalServerErrorAlertView(controller: self)
        }
    }
    
    //MARK:- Get Image Details from API
    func getImageDataFromAPI(){
        imageDataViewModel.getAPODImageData(self, APIKey)
        
        getImageDetailsAPiObserver()
    }
    
    //Image Details API Observer
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
                        self.labelDescription.text = self.imageDataViewModel.imageDataDictionary.value?["explanation"] as? String
                    }
                }
                break
            case false:
                //if the api fails then will be showing failure alert
                Helper.sharedInstance.internalServerErrorAlertView(controller: self)
                
                break
            default:
                break
            }
            
        }
    }

    //Fetch Image from URL
    func fetchImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }

    //MARK: - Load Image on UI
    func loadImage(from url: URL, into imageView: UIImageView, loader: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            loader.startAnimating()
        }
        fetchImage(from: url) { data in
            DispatchQueue.main.async {
                loader.stopAnimating()
                if let data = data {
                    
                    let imageAPOD:UIImage = UIImage(data: data)!
                    
                    //Calculate image height proportionally based on the image from server
                    let imageHeight = imageAPOD.getHeightOfImage
                    let imageWidth = imageAPOD.getWidthOfImage
                    
                    if(imageHeight > imageWidth)
                    {
                        let proportionalWidthDifference = imageView.frame.size.width/imageWidth
                        let proportionalHeight = proportionalWidthDifference*imageHeight
                        self.imageViewAPODHeight.constant = proportionalHeight
                    }
                    
                    imageView.image = UIImage(data: data)

                    //Save data in local DB
                    let base64String = Helper.sharedInstance.convertImageToBase64String(img: imageView.image ?? UIImage())
                    LocalDataModel.shared.insertUpdateImageDetailsToDB(imageDict: self.imageDataViewModel.imageDataDictionary.value! as NSDictionary, base64imageData: base64String)
                }
            }
        }
    }
}

