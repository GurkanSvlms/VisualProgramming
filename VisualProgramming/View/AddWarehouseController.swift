//
//  AddWarehouseController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 27.04.2023.
//

import UIKit
import CoreData

class AddWarehouseController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var capacityTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    var currentUser : String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(currentUser ?? "Empty")
        
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        guard let name = nameTextField.text,!name.isEmpty,
              let capacity = capacityTextField.text,!capacity.isEmpty,
                let location = locationTextField.text,!location.isEmpty else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "Warehouses", in: context)
        
        let newWarehouse = NSManagedObject(entity: entity!, insertInto: context)
        
        newWarehouse.setValue(UUID(), forKey: "warehouse_id")
        newWarehouse.setValue(name, forKey: "warehouse_name")
        newWarehouse.setValue(Int(capacity), forKey: "warehouse_capacity")
        newWarehouse.setValue(location, forKey: "warehouse_location")
        newWarehouse.setValue(currentUser, forKey: "warehouse_owner")
        
        
        do {
            try context.save()
            print("Depo Kaydedildi.")
            performSegue(withIdentifier: "returnManufactorVC", sender: self)
            
        } catch {
            print("Kayıt hatası: \(error.localizedDescription)")
            
            // Kaydetme işlemi başarısız olduğunda kullanıcıya bir alert mesajı gösteriyoruz.
            let alertController = UIAlertController(title: "Hata", message: "Depo kaydedilemedi. Lütfen tekrar deneyin.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnManufactorVC"{
            let addWarehouseVC = segue.destination as! ManufactorHomeController
            addWarehouseVC.currentUser = self.currentUser
        }
        
    }
}
