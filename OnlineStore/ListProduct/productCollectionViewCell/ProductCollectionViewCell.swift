//
//  ProductCollectionViewCell.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 09/12/23.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productVarian: UILabel!
    @IBOutlet var productStock: UILabel!
    @IBOutlet var productPrice: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        productPrice.textColor = UIColor.systemBlue    }

}
