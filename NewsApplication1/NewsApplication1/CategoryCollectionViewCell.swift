//
//  CategoryCollectionViewCell.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 24/08/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var textLabel : UILabel!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
}
