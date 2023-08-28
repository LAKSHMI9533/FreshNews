//
//  FavNewsCollectionView.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 24/08/23.
//

import Foundation
import UIKit
import Combine

class FavNewsCollectionViewController: UIViewController{
    @IBOutlet var favNewsCollection: UICollectionView!
    var networking = Networking()
    var can =  Set<AnyCancellable>()
    var favDecodedResponce : Responce!
    var favresultsarray : String = ""
    var arrayforfav : [Responce] = []
    var arrayforfav1 : [results] = []
    var coount = 0
    
    override func viewDidLoad() {
        favNewsCollection.delegate = self
        favNewsCollection.dataSource = self
        favNewsCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        for i in 0...FavArray.count-1{
            print(i,"sdf")
            var a = networking.addingCatToUrl(category: categoryEnum.allCases[i])
            ApiCall(urll: a)
        }
    }
    
    func ApiCall(urll:String = ""){
        if urll == ""{
            networking.apiCall().sink { error in
                print(error)
            } receiveValue: { decodedResponce1 in
                self.favDecodedResponce = decodedResponce1
//                DispatchQueue.main.async {
//                  //  self.favNewsCollection.reloadData()
//                }
            }.store(in: &can)
        } else {
            networking.apiCall(catApiUrl: urll).sink { error in
                print(error)
            } receiveValue: { [self] decodedResponce1 in
                if self.arrayforfav == nil {
                    self.arrayforfav = []
                }
                self.arrayforfav.append(decodedResponce1)
                self.arrayforfav1.append(contentsOf: decodedResponce1.articles)
                if arrayforfav.count == FavArray.count{
                    DispatchQueue.main.async {
                        favNewsCollection.reloadData()
                    }
                }
            }.store(in: &can)
        }
    }
}


extension FavNewsCollectionViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayforfav.isEmpty{
            return 1
        } else {
            var count = 0
            for i in arrayforfav{
                count = i.totalResults! + count
            }
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favNewsCollection.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.titleLabel.text = "gh"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        let cell = cell as! CollectionViewCell
        if  (!arrayforfav1.isEmpty){
            if(arrayforfav1[indexPath.row] != nil){
                cell.descriptionLabel.text = "\(arrayforfav1[indexPath.row].description ?? "description not found")"
                cell.titleLabel.text = "\(arrayforfav1[indexPath.row].title ?? "notfound")"
                cell.contentLabel.text = "\(arrayforfav1[indexPath.row].content ?? "notfound")"
                if arrayforfav1[indexPath.row].urlToImage != nil{
                    networking.apiCallForImage(uurl: arrayforfav1[indexPath.row].urlToImage!).sink { error in
                        print(error)
                    } receiveValue: { Responce in
                        DispatchQueue.main.async {
                            cell.imageView.image = Responce
                            print("imageattached\(indexPath)")
                        }
                    }.store(in: &can)

                }
            }else {
                print("empty")
            }
            
        }else{
            print("error in will display")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(arrayforfav1[indexPath.row].url)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "webViewController") as! WebViewController
        vc.urlForNews = "\((arrayforfav1[indexPath.row].url ?? "notfound url") as String)"
        if let vcc = vc.presentationController as? UISheetPresentationController{
            vcc.detents = [.medium(),.large()]
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension FavNewsCollectionViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        }
}
