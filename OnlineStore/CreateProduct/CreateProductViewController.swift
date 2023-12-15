//
//  CreateProductViewController.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 09/12/23.
//

import UIKit
import Moya
import SwiftyJSON

protocol CreateProductDelegate: AnyObject {
    func productCreated()
}

class CreateProductViewController: UIViewController {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var productNameInput: UITextField!
    @IBOutlet var productDecsInput: UITextField!
    @IBOutlet var addVariantProduct1: UIButton!
    @IBOutlet var addVariantProduct2: UIButton!
    @IBOutlet var addVariantProduct3: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    weak var delegate: CreateProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addVariantProduct1.layer.borderWidth = 1
        addVariantProduct1.layer.borderColor = UIColor.systemBlue.cgColor
        addVariantProduct2.layer.borderWidth = 1
        addVariantProduct2.layer.borderColor = UIColor.systemBlue.cgColor
        addVariantProduct3.layer.borderWidth = 1
        addVariantProduct3.layer.borderColor = UIColor.systemBlue.cgColor
        
        productNameInput.placeholder = "Product Name"
        productDecsInput.placeholder = "Product Description"
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        createProduct()
    }
    
    func createProduct() {
        print("Product created successfully!")
        guard let productTitle = productNameInput.text, !productTitle.isEmpty else {
            
            print("Product title cannot be empty")
            return
        }
        guard let productDescription = productDecsInput.text, !productDescription.isEmpty else {
            
            print("product description cannot be empty")
            return
        }
        
        let productProvider = MoyaProvider<CreateProductEndpoint>()
        
        let variants = generateVariants()
        
        productProvider.request(.createProduct(title: productTitle, description: productDescription, variant: variants)) { result in
            switch result {
            case let .success(response):
                if let statusCode = response.response?.statusCode {
                    
                }
                do {
                    let json = try JSON(data: response.data)
                    print("Parsed JSON: \(json)")
                    let code = json["code"].stringValue
                    let message = json["message"].stringValue
                    
                    self.delegate?.productCreated()
                    self.dismiss(animated: true, completion: nil)
                    
                } catch {
                    print("Gagal mengurai respons ini: \(error)")
                }
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
    
    func generateVariants() ->[Variants] {
        var variants: [Variants] = []
        
        for index in 1...3 {
            let variantName = "variant \(index)"
            let variantImageURL = "variant\(index)_image_url"
            let variantPrice = 100 + (index * 10)
            let variantStock = 50 + (index * 10)
            
            let variant = Variants(name: variantName, image: variantImageURL, price: variantPrice, stock: variantStock)
            variants.append(variant)
        }
        
        return variants
    }
}

