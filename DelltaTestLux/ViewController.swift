//
//  ViewController.swift
//  DelltaTestLux
//
//  Created by sergey on 20.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//


import UIKit
import SwiftyStoreKit
import StoreKit


var sharedSecret = "280d1ba4a9054d17935bc7035de7a954"

class NetworkActivityIndicator: NSObject {
    private static var loadingCount = 0
    
   class func networkOperationStarted() {
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func networkOperationFinished(){
        if loadingCount > 0{
            loadingCount -= 1
        }
        
        if loadingCount == 0{
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
}

class ViewController: UITableViewController {

    var listProducts = [RegisteredPurchase]()
    
    var nameProducts = [ "motor",
                         "mechel",
                         "matros",
                         "povarn",
                         "tanker",
                         "gmssb"
    ]
    
    let boundleId = "info.upump.questionnairedelta."
    
    let reseiptValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
    
    var muPurch : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Варианты"
        setRightButton()
        setupProducts()
        setupTable()
    }
    func setRightButton()  {
        //  let rightButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restore))
        let rightButton =  UIBarButtonItem(title: "restore", style: .plain, target: self, action: #selector(restore))
        navigationItem.rightBarButtonItem = rightButton
    }
    
     func setupProducts(){
        
        for i in 0...nameProducts.count - 1 {
            let product = RegisteredPurchase(endNameApp: nameProducts[i])
            listProducts.append(product)
            getProductWitInfo(product: product)
        }
    }
    
    func getProductWitInfo(product: RegisteredPurchase){
       NetworkActivityIndicator.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([boundleId + product.endNameApp!], completion:{
            result in
            // моя ахине странно но работает
           NetworkActivityIndicator.networkOperationFinished()
          
            product.name = result.retrievedProducts.first?.localizedTitle
            product.cost = result.retrievedProducts.first?.localizedPrice
            product.description = result.retrievedProducts.first?.localizedDescription
            self.verifyForChack(product: product)
        }
        )
    }
    
    func verifyForChack(product: RegisteredPurchase){
        NetworkActivityIndicator.networkOperationStarted()
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: sharedSecret)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) {
            result in
            
            NetworkActivityIndicator.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                let productId = self.boundleId + product.endNameApp!
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                    product.isPurchased = true
        
                     //self.tableView.reloadData()
                case .notPurchased:
                    print("The user has never purchased мой текс  \(productId)")
                   product.isPurchased = false
                    // self.tableView.reloadData()  возможно стоит поставить для безопасности
                }
                
            case .error(let error):
                print("Receipt verification failed: \(error)")
                 product.isPurchased = false
            }
            
           self.tableView.reloadData()
        }
        
    }
    
    @objc func restore(){
        NetworkActivityIndicator.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            NetworkActivityIndicator.networkOperationFinished()
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    // fetch content from your server, then:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
             //   self.setupProducts()
                self.tableView.reloadData()

                print("Restore Success: \(results.restoredPurchases)")

            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    func setupTable(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(displayP3Red: 197/255, green: 202/255, blue: 232/255, alpha: 1)
      //  tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as UITableViewCell
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        let product = listProducts[indexPath.row]
        cell.backgroundColor = UIColor(displayP3Red: 232/255, green: 234/255, blue: 246/255, alpha: 1)
        cell.selectionStyle = .none
        cell.layer.borderColor = UIColor(displayP3Red: 92/255, green: 107/255, blue: 192/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        cell.textLabel?.text = product.name
        
        if(product.isPurchased){
            cell.accessoryType = .checkmark
        } else {cell.accessoryType = .detailButton}
        
       // verifyForChack(product: product)
        
        cell.detailTextLabel?.text = product.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        getInfo(purchase: listProducts[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProducts.count
    }
    
    func getInfo(purchase: RegisteredPurchase)  {
        NetworkActivityIndicator.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([boundleId + purchase.endNameApp!], completion:{
        result in
            // моя ахине странно но работает
            NetworkActivityIndicator.networkOperationFinished()
            
            
            let title =  result.retrievedProducts.first?.localizedTitle
            let price = result.retrievedProducts.first?.localizedPrice
            
            let al = self.alertWithTitle(title: title!, message: "стоимость \(String(describing: price!))")
            self.showAlert(alert: al)

        }
        )
    }
    
//pokipka
    func purchase(product: RegisteredPurchase)  {
        NetworkActivityIndicator.networkOperationStarted()
        let idString = boundleId + product.endNameApp!
        SwiftyStoreKit.retrieveProductsInfo([idString]) { result in
            NetworkActivityIndicator.networkOperationFinished()
            if let productRetriv = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(productRetriv, quantity: 1, atomically: true) { result in
                    // handle result (same as above)
                    switch result {
                    case .success(let productRetriv):
                        // fetch content from your server, then:
                        if productRetriv.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(productRetriv.transaction)
                        }
                        product.isPurchased = true
                    self.tableView.reloadData()
                    
                       // print("Purchase Success: \(productRetriv.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        }
                    }
                }
            }
        }
    }
    
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let product = listProducts[indexPath.row]
       // varifyPurchase(product: product)  вариант с принудительной проверкой перед открытием
        if(product.isPurchased){
            openBase(product: product)
        } else {purchase(product: product)}
        
    }
    
    func alertWithTitle(title: String, message: String) ->UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(alert: UIAlertController){
        guard let _ = self.presentedViewController else{
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    
    func alertForProductRetrieval(result: RetrieveResults) ->UIAlertController{
        
        if let product =  result.retrievedProducts.first{
            let priceString = product.localizedPrice
            return alertWithTitle(title: product.localizedTitle, message:
                "\(product.localizedDescription) - \(priceString)")
        }
        else if let invalidProductId = result.invalidProductIDs.first{
            return alertWithTitle(title: "could not retrival prduct id", message:
                "invalid product \(invalidProductId)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unknown error"
            return alertWithTitle(title: "could not retrival info", message: errorString)
        }
    }
    
    func openBase(product: RegisteredPurchase) {
        let vc = MyViewController(product: product)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
