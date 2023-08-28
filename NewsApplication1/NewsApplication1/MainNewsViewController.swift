//
//  ViewController.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 23/08/23.
//

import UIKit
import Combine

class MainNewsViewController: UIViewController {
    
    @IBOutlet var tapGester: UITapGestureRecognizer!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var NewsCollectionView: UICollectionView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var homeButton: UIButton!
    var refresh = UIRefreshControl()
    var can =  Set<AnyCancellable>()
    var networking = Networking()
    var decodedResponce : Responce!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 5
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource=self
        NewsCollectionView.delegate = self
        NewsCollectionView.dataSource = self
        NewsCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    @IBAction func tapGesterclicked(_ sender: Any) {
        print("mainviewcontroller")
    }
    @IBAction func MenuButtonClicked(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TableViewCell") 
//        vc.modalPresentationStyle = .currentContext
//        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func SearchButtonClicked(_ sender: Any) {
        if searchTextField.text !=  ""{
            let temp = searchUrl + "\(searchTextField.text!)"
            ApiCall(urll: temp)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("rotated")
        if UIDevice.current.orientation.isLandscape{
            print("landscape")
                // NewsCollectionView.reloadData()
        }else{
            print("potrait")
                //NewsCollectionView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ApiCall()
    }
    
    
    func ApiCall(urll:String = ""){
        if urll == ""{
            networking.apiCall().sink { error in
                print(error)
            } receiveValue: { decodedResponce1 in
                self.decodedResponce = decodedResponce1
                DispatchQueue.main.async {
                    self.NewsCollectionView.reloadData()
                }
            }.store(in: &can)
        } else {
            networking.apiCall(catApiUrl: urll).sink { error in
                print(error)
            } receiveValue: { decodedResponce1 in
                self.decodedResponce = decodedResponce1
                DispatchQueue.main.async {
                    self.NewsCollectionView.reloadData()
                    self.dismiss(animated: false, completion: nil)
                }
            }.store(in: &can)
        }
    }
}


extension MainNewsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView{
            return categoryArray.count
        }else{
            if  (decodedResponce != nil){
                return decodedResponce.articles.count
            } else {
                return 0
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView{
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
            cell.textLabel.sizeToFit()
            return cell
        }else{
            let cell = NewsCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.layer.cornerRadius = 7
        cell.layer.borderWidth = 1
        
        if collectionView == categoryCollectionView{
            let cell = cell as! CategoryCollectionViewCell
            cell.textLabel.text = "  \(categoryArray[indexPath.row])   "
            cell.textLabel.sizeToFit()
            
        }else{
            
            let cell = cell as! CollectionViewCell
            cell.imageView.image = nil
            if  (decodedResponce != nil){
                cell.descriptionLabel.text = "\(decodedResponce.articles[indexPath.row].description ?? "not found come")"
                cell.titleLabel.text = "\(decodedResponce.articles[indexPath.row].title ?? "not found come")"
                cell.contentLabel.text = "\(decodedResponce.articles[indexPath.row].content ?? "not found come")"
                if decodedResponce.articles[indexPath.row].urlToImage != nil{
                    cell.imageView.isHidden = false
                    networking.apiCallForImage(uurl: decodedResponce.articles[indexPath.row].urlToImage!).sink { error in
                        print(error)
                    } receiveValue: { Responce in
                        DispatchQueue.main.async {
                            cell.imageView.image = Responce
                            print("imageattached\(indexPath)")
                        }
                    }.store(in: &can)
                }else{
                    print(indexPath)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            if(cell.isSelected)
                {
                    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.style = UIActivityIndicatorView.Style.medium
                    loadingIndicator.startAnimating();

                    alert.view.addSubview(loadingIndicator)
                    present(alert, animated: true, completion: nil)
                }
                else
                {
                    cell.backgroundColor = .blue
                }
            var a = networking.addingCatToUrl(category: categoryEnum.allCases[indexPath.row])
            ApiCall(urll: a)
        } else {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "webViewController") as! WebViewController
            vc.urlForNews = "\((decodedResponce.articles[indexPath.row].url ?? "notfound url") as String)"
            if let vcc = vc.presentationController as? UISheetPresentationController{
                vcc.detents = [.medium(),.large()]
            }
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
}
extension MainNewsViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("layout")
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
    
    
}
