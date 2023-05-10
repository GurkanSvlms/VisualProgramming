//
//  CustomerHomeController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 30.04.2023.
//

import UIKit
import CoreData

class CustomerHomeController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var productList : [Products] = []
    
    var selectedProductId : UUID?
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        productList = getUserProduct()!
        
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = productList[indexPath.row]
        selectedProductId = selectedProduct.product_id! // seçilen ürünün ID'si
        print(selectedProductId ?? "Nil")
            
            performSegue(withIdentifier: "goToDetailVC", sender: selectedProductId)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC" {
            let destinationVC = segue.destination as! CustomerDetailController
            selectedProductId = sender as? UUID
            destinationVC.productId = selectedProductId
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("ProductCell")
        let productCell = Bundle.main.loadNibNamed("ProductCell", owner: self)?.first as! ProductCell
        let product = productList[indexPath.row]
        productCell.nameTextField.text = product.product_name
//        productCell.descriptionTextField.text = product.product_description
//        productCell.priceText.text = "Price:\(String(product.product_unit_price))"
//        productCell.quantityLabel.text = "Quantity:\(String(product.product_quantity)) "
//       
        return productCell
    }
    
    func getUserProduct() -> [Products]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Products>(entityName: "Products")
       
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch depots. \(error), \(error.userInfo)")
            return nil
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
    
    @IBAction func requestButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "gotoRequests", sender: nil)
    }
    

}
