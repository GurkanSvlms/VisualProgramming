//
//  ProduceProductController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 30.04.2023.
//

import UIKit
import CoreData

class ProduceProductController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var warehouseLabel: UILabel!
    
    var productId: String?

    var product : Products?
    
    var warehouseId : String!
    
    var currentUser : String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        product = getProductWithId(id: productId ?? "Error")
        
        nameLabel.text = product?.product_name
        descriptionLabel.text = product?.product_description
        quantityLabel.text = "Quantity: \(product?.product_quantity ?? 0)"
        priceLabel.text = "Price: \(product?.product_unit_price ?? 0)"
        warehouseLabel.text = getWarehouseName(warehouseID: warehouseId ?? "Error")
        
        
    }
    
    func getProductWithId(id : String) -> Products? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "product_id == %@", id)
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results{
                    warehouseId = result.product_warehouse
                }
                return results[0]
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Could not fetch product with id. \(error), \(error.userInfo)")
            return nil
        }
    }

    @IBAction func produceButtonClicked(_ sender: Any) {
        product = getProductWithId(id: productId ?? "Error")
        let productAmount = Int(product!.product_quantity)
        let amount = Int(amountTextField.text!)
        
        let updatedQuantity = productAmount + amount!
        product?.product_quantity = Int32(updatedQuantity)
        do {
                try context.save()
                print("Ürün miktarı güncellendi.")
                performSegue(withIdentifier: "returnManufactorHome", sender: self)
            } catch {
                print("Ürün miktarı güncellenirken hata oluştu: \(error)")
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnManufactorHome"{
            let addWarehouseVC = segue.destination as! ManufactorHomeController
            addWarehouseVC.currentUser = self.currentUser
        }
    }
    func getWarehouseName(warehouseID: String) -> String? {
        let fetchRequest: NSFetchRequest<Warehouses> = Warehouses.fetchRequest()
        let predicate = NSPredicate(format: "warehouse_id == %@", UUID(uuidString: warehouseID)! as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let warehouses = try context.fetch(fetchRequest)
            if let warehouse = warehouses.first {
                return warehouse.warehouse_name
            }
        } catch {
            print("Hata: Depo adı getirilemedi - \(error.localizedDescription)")
        }
        
        return nil
    }


}

