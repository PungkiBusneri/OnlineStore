//
//  ListProductViewController.swift
//  OnlineStore
//
//  Created by Pungki Busneri on 09/12/23.
//

import UIKit
import Moya
import SwiftyJSON

class ListProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CreateProductDelegate{
    @IBOutlet var backButton: UIButton!
    @IBOutlet var addButtonProduct: UIButton!
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var productCollection: UICollectionView!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var createProduct: UIButton!
    
    private var cellIdentifier = "ProductCollectionViewCell"
    private var productData: [ProductModel] = []
    
    let authToken = UserDefaults.standard.string(forKey: "AuthToken")
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollection.dataSource = self
        productCollection.delegate = self
        productCollection.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        navigationController?.navigationBar.isHidden = true
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func exitButtonTapped(_ sender: Any) {
        showAlertExit()
    }
    
    @IBAction func createProductTapped(_ sender: Any) {
        let createProductViewController = CreateProductViewController()
        createProductViewController.delegate = self
        navigationController?.pushViewController(createProductViewController, animated: true)
    }
    func showCreateProductButton() {
        createProduct.isHidden = false
        addButtonProduct.isHidden = true
    }
    
    func showAddProductButton() {
        createProduct.isHidden = true
        addButtonProduct.isHidden = false
    }
    
    func productCreated() {
        showAddProductButton()
        fetchProductList()
    }
    func fetchProductList() {
        
        let endpoint = ListProductEndPoint.getProductList(page: 1, perPage: 10, search: "Tas", orderDirection: "asc")
        
        let provider = MoyaProvider<ListProductEndPoint>()
        
        provider.request(endpoint) { result in
            switch result {
            case let .success(response):
//                print(String(data: response.data, encoding: .utf8) ?? "Unable to convert data to string")

                do {
                    let json = try JSON(data: response.data)
                    let productListResponse = self.mapProductListResponseFromJSON(json)
                    
                    if let items = productListResponse?.data.items {
                        // Update data produk
                        self.productData = items
                        self.productCollection.reloadData()
                    }
                } catch {
                    print("Gagal mengurai respons: \(error)")
                }
                
            case let .failure(error):
                print("Gagal membuat permintaan: \(error)")
            }
        }
    }
    func mapProductListResponseFromJSON(_ json: JSON) -> ProductListResponse? {
        
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollection.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProductCollectionViewCell
        
        let product = productData[indexPath.item]
        cell.productName.text = product.title
        
        return cell
    }
    
    func showAlertExit() {
        let alert = UIAlertController(title: .none, message: "Are you sure to LOGOUT?", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "YES", style: .default) { (action) in
            
            self.performExit()
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        
        alert.addAction(exitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func performExit() {
        UserDefaults.standard.removeObject(forKey: "AuthToken")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            // Navigasikan pengguna ke layar selamat datang atau layar login
            let welcomeVC = WelcomeViewController()
            let navigationController = UINavigationController(rootViewController: welcomeVC)
            sceneDelegate.window?.rootViewController = navigationController
        }
    }
}
