//
//  ManufactorHomeController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 27.04.2023.
//

import UIKit
import CoreData

class ManufactorHomeController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var segmentedContoller: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var warehousesList : [Warehouses] = []
    
    var productList : [Products] = []
    
    var selectedProductId : String?
    
    var currentUser : String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "VisualProgramming")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        
        
        
        warehousesList = getUserWarehouses()!
        productList = getUserProduct()!
        

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentedContoller.selectedSegmentIndex {
        case 0:
            return
        case 1:
            let selectedProduct = productList[indexPath.row]
            selectedProductId = selectedProduct.product_id?.uuidString // seçilen ürünün ID'si
            print(selectedProductId ?? "Nil")
                
                performSegue(withIdentifier: "goToProduceProduct", sender: selectedProductId)
            
        default:
            break
        }
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProduceProduct" {
            let destinationVC = segue.destination as! ProduceProductController
            destinationVC.productId = selectedProductId
            destinationVC.currentUser = currentUser
        }
        else if segue.identifier == "goToWarehouseVC"{
            let addWarehouseVC = segue.destination as! AddWarehouseController
            addWarehouseVC.currentUser = self.currentUser
        }
        else if segue.identifier == "goToProductVC"{
            let addProductVC = segue.destination as! AddProductController
            addProductVC.currentUser = self.currentUser
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        if segmentedContoller.selectedSegmentIndex == 0{
            print("WarehouseCell")
            let warehouseCell = Bundle.main.loadNibNamed("WarehouseCell", owner: self)?.first as! WarehouseCell
            let warehouse = warehousesList[indexPath.row]
            warehouseCell.nameLabel.text = warehouse.warehouse_name
            warehouseCell.locationLabel.text = warehouse.warehouse_location
            warehouseCell.capacityLabel.text = String(warehouse.warehouse_capacity)
            
            return warehouseCell
        }
        else if segmentedContoller.selectedSegmentIndex == 1{
            print("ProductCell")
            let productCell = Bundle.main.loadNibNamed("ProductCell", owner: self)?.first as! ProductCell
            let product = productList[indexPath.row]
            productCell.nameTextField.text = product.product_name
            
           
            return productCell
        }
        else{
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentedContoller.selectedSegmentIndex {
        case 0:
            print("Return Warehouse")
            return warehousesList.count
        case 1:
            print("Return Product")
            return productList.count
        default:
            return 0
        }
    }
//    func getUsersProduct() -> [Products]? {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<Products>(entityName: "Products")
//
//
//        do {
//            let result = try context.fetch(fetchRequest)
//            return result
//        } catch let error as NSError {
//            print("Could not fetch depots. \(error), \(error.userInfo)")
//            return nil
//        }
//    }
//
    @IBAction func segmentedContollerChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print(warehousesList.count)
            tableView.reloadData()
        case 1:
            print(productList.count)
            tableView.reloadData()
        default:
            break
        }
        
    }

//    func getCurrentUserID() -> Int32? {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ManufactorFac")
//        request.predicate = NSPredicate(format: "isLoggedIn == true")
//        request.fetchLimit = 1
//        request.propertiesToFetch = ["userID"]
//        request.resultType = .dictionaryResultType
//
//
//        do {
//            let result = try context.fetch(request)
//            if let userDict = result.first as? [String : Any],
//               let userID  = userDict["manufactor.userID"] as? Int32{
//                return userID
//            }
//
//        } catch {
//            print("Error fetching current user ID: \(error.localizedDescription)")
//        }
//        return nil
//
//    }

    func getUserWarehouses() -> [Warehouses]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Warehouses> = Warehouses.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "warehouse_owner = %@", currentUser ?? "Empty")

        
        do {
            let result = try context.fetch(fetchRequest)
            for warehouse in result{
                warehousesList.append(warehouse)
            }
            return result
        } catch let error as NSError {
            print("Could not fetch depots. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func getUserProduct() -> [Products]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Products> = Products.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "product_owner = %@", currentUser ?? "Empty")

       
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch depots. \(error), \(error.userInfo)")
            return nil
        }
    }
    @IBAction func requestButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToRequest", sender: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if segmentedContoller.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "goToWarehouseVC", sender: nil)
        }
        else{
            performSegue(withIdentifier: "goToProductVC", sender: nil)
        }
    }
    @IBAction func exitButtonClicked(_ sender: Any) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }

}
