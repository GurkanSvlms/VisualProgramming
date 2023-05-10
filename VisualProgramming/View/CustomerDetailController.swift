//
//  CustomerDetailController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 30.04.2023.
//

import UIKit
import CoreData

class CustomerDetailController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var warehouseTextField: UILabel!
    
    var productId: UUID? = nil

    var product : Products? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var isAccepted : Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        product = getProductWithId(id: productId!.uuidString)
        
        nameLabel.text = product?.product_name
        descriptionLabel.text = product?.product_description
        quantityLabel.text = "Quantity: \(product?.product_quantity ?? 0)"
        priceLabel.text = "Price: \(product?.product_unit_price ?? 0)"
        warehouseTextField.text = getWarehouseName(warehouseId: product?.product_warehouse ?? "Error")
        
        
    }
    
    func getProductWithId(id : String) -> Products? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "product_id == %@", id)
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                return results[0]
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Could not fetch product with id. \(error), \(error.userInfo)")
            return nil
        }
    }

    func getWarehouseName(warehouseId: String) -> String? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Warehouses")
        request.predicate = NSPredicate(format: "warehouse_id == %@", warehouseId)
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["warehouse_name"]
        
        do {
            let results = try context.fetch(request)
            let warehouses = results as! [[String: String]]
            if let warehouseName = warehouses.first?["warehouse_name"] {
                return warehouseName
            } else {
                return nil
            }
        } catch {
            print("Hata: \(error.localizedDescription)")
            return nil
        }
    }


    @IBAction func buyButtonClicked(_ sender: Any) {
        product = getProductWithId(id: productId!.uuidString)
        let productAmount = Int(product!.product_quantity)
        let amount = Int(amountTextField.text!)
        if amount! <= productAmount{
//            stok yeterli
            let updatedQuantity = productAmount - amount!
            product?.product_quantity = Int32(updatedQuantity)
            do {
                    try context.save()
                    print("Ürün miktarı güncellendi.")
                    performSegue(withIdentifier: "returnToCustomerHome", sender: nil)
                } catch {
                    print("Ürün miktarı güncellenirken hata oluştu: \(error)")
                }
        }else{
//            stok yetersiz
            sendRequest()
        }
    }
    func sendRequest(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Requests", in: context)
        let newRequest = NSManagedObject(entity: entity!, insertInto: context)
        let amount = Int32(amountTextField.text!)
        
        newRequest.setValue(UUID(), forKey: "request_id")
        newRequest.setValue(product?.product_id, forKey: "product_id")
        newRequest.setValue(amount! - product!.product_quantity, forKey: "request_quantity")
        newRequest.setValue(isAccepted, forKey: "is_accepted")
        
        do {
            try context.save()
            print("Talep Kaydedildi.")
            let alertController = UIAlertController(title: "Successful request", message: "The request has been sent to the manufacturer", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
            
            performSegue(withIdentifier: "returnToCustomerHome", sender: nil)
            
        } catch {
            print("Talep hatası: \(error.localizedDescription)")
            
            // Kaydetme işlemi başarısız olduğunda kullanıcıya bir alert mesajı gösteriyoruz.
            let alertController = UIAlertController(title: "Hata", message: "Lütfen tekrar deneyin.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
        
    }
}
