//
//  Networking.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 23/08/23.
//

import Foundation
import Combine
import UIKit
var aa = "&language=en,https://newsdata.io/api/1/news?apikey=pub_280928dc2d16bb16f2f5a3df3e0f4a7c3877c&category=business&language=en&domain=nytimes,bbc,https://newsdata.io/api/1/news?apikey=pub_280928dc2d16bb16f2f5a3df3e0f4a7c3877c&country=in&category=business&language=en"

class Networking{
    var can =  Set<AnyCancellable>()
    var a = "https://newsapi.org/v2/top-headlines?country=in&apiKey=ef8d6b5fdee84cc6afcfd3b93b4f634b&category="
    
    var keys = "389c661b7e474bb58d0c4b149f57533b,hulk,ef8d6b5fdee84cc6afcfd3b93b4f634b,madhu"
    
    var  baseUrl = URL(string: "https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com,bbc.com&apiKey=ef8d6b5fdee84cc6afcfd3b93b4f634b&language=en")
    
    var second  = "https://newsdata.io/api/1/news?apikey=pub_280928dc2d16bb16f2f5a3df3e0f4a7c3877c&country=in&language=en&category="

    func addingCatToUrl( category : categoryEnum)->String{
        
        switch category{
        case .business :
            print(categoryEnum.business)
            var q = a + "business"
            print(q)
            return q
        case .entertainment:
            print(categoryEnum.entertainment)
            let q = a + "entertainment"
            print(q)
            return q
        case .health:
            print(category)
            let q = a + "health"
            print(q)
            return q
        case .politics:
            print(category)
            let q = a + "politics"
            print(q)
            return q
        case .science:
            print(category)
            let q = a + "science"
            print(q)
            return q
        case .sports:
            print(category)
            let q = a + "sports"
            print(q)
            return q
        case .technology:
            print(category)
            let q = a + "technology"
            print(q)
            return q
        case .general:
            print(category)
            let q = a + "general"
            print(q)
            return q
        }
        return ""
    }
    
    func apiCall(catApiUrl : String = "")->Future<Responce,Error>{
        Future{ promice in
            if catApiUrl != ""{
                self.baseUrl = URL(string: "\(catApiUrl)")
            }
            URLSession(configuration:.default).dataTask(with: self.baseUrl!) { Data, urlresponce, error in
                if Data != nil{
                    do{
                        let reData = try JSONDecoder().decode(Responce.self, from: Data!)
                        promice(.success(reData))
                    } catch {
                        print(error)
                    }
                } else {
                    promice(.failure(error!))
                }
            }.resume()
        }
    }
    
    func apiCallForImage(uurl : String)->Future<UIImage,Error>{
        Future{ promice in
            let url = URL(string: uurl)
            URLSession(configuration:.default).dataTask(with: url!) { Data, urlresponce, error in
                if let data = Data{
                    do{
                        if let reData = try UIImage(data: data){
                            promice(.success(reData))
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    promice(.failure(error!))
                }
            }.resume()
        }
    }
}

