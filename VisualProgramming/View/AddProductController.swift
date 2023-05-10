//
//  AddProductController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 27.04.2023.
//

import UIKit
import CoreData

class AddProductController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentUser : String?
    
    var warehouses : [Warehouses] = []
    
    var selectedWarehouseId : String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        print(currentUser ?? "Empty")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadWarehouses()
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let name = nameTextField.text,!name.isEmpty,
              let price = priceTextField.text,!price.isEmpty,
                let description = descriptionTextField.text,!description.isEmpty,
              let quantity = quantityTextField.text, !quantity.isEmpty
        else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "Products", in: context)
        let newProduct = NSManagedObject(entity: entity!, insertInto: context)
        
        newProduct.setValue(UUID(), forKey: "product_id")
        newProduct.setValue(name, forKey: "product_name")
        newProduct.setValue(Float(price), forKey: "product_unit_price")
        newProduct.setValue(description, forKey: "product_description")
        newProduct.setValue(Int32(quantity), forKey: "product_quantity")
        newProduct.setValue(currentUser, forKey: "product_owner")
        newProduct.setValue(selectedWarehouseId, forKey: "product_warehouse")

        
        do {
            try context.save()
            print("Ürün Kaydedildi.")
            performSegue(withIdentifier: "returnManufactorVC", sender: self)
            
        } catch {
            print("Kayıt hatası: \(error.localizedDescription)")
            
            // Kaydetme işlemi başarısız olduğunda kullanıcıya bir alert mesajı gösteriyoruz.
            let alertController = UIAlertController(title: "Hata", message: "Ürün kaydedilemedi. Lütfen tekrar deneyin.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return warehouses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell()
        let warehouse = warehouses[indexPath.row]
        cell.textLabel?.text = warehouse.warehouse_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let warehouseID = warehouses[indexPath.row]
        
        selectedWarehouseId = (warehouseID.warehouse_id)?.uuidString
        // Seçilen depoya ait ürünleri kaydetme işlemleri burada yapılır
    }
    
    func loadWarehouses() {
            let request = NSFetchRequest<Warehouses>(entityName: "Warehouses")
            do {
                warehouses = try context.fetch(request)
            } catch {
                print("Depo yükleme hatası: \(error.localizedDescription)")
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnManufactorVC"{
            let addWarehouseVC = segue.destination as! ManufactorHomeController
            addWarehouseVC.currentUser = self.currentUser
        }
        
    }
    
    
}
