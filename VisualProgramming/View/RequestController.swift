//
//  RequestController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 30.04.2023.
//

import UIKit
import CoreData

class RequestController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var productId: UUID?
    var product: Products?
    var productList : [Products] = []
    var requestList : [Requests] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var requestQuantity : Int?
    var isAccepted : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        let fetchRequest: NSFetchRequest<Requests> = Requests.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            if let request = results.first {
                productId = request.product_id
                print(productId ?? "No ID")
                requestList = results
                print(requestList.count)
                let cell = Bundle.main.loadNibNamed("ProductCell", owner: self)?.first as! ProductCell
                cell.imgView.isHidden = false
                if request.is_accepted == true{
                    cell.imgView.image = UIImage(named: "checkmark.circle.fill")
                }
                else{
                    cell.imgView.image = UIImage(named: "xmark.circle.fill")

                }
                
            } else {
                return
            }
            
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequest = requestList[indexPath.row]
        
        let fetchRequest: NSFetchRequest<Requests> = Requests.fetchRequest()
        
        
        fetchRequest.predicate = NSPredicate(format: "product_id == %@", selectedRequest.product_id! as CVarArg)
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if let request = results.first {
                    let quantity = Int(request.request_quantity)
                        requestQuantity = quantity
                }
            } catch let error as NSError {
                print("Could not fetch product with id. \(error), \(error.userInfo)")
            }

        let alert = UIAlertController(title: "Request", message: "Do you want to produce \(requestQuantity ?? 000) of your chosen product?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//            Evet denirse olacaklar
            do {
                let entity = NSEntityDescription.entity(forEntityName: "Requests", in: self.context)
                
                let newRequest = NSManagedObject(entity: entity!, insertInto: self.context)
                
                self.isAccepted = true
                
                newRequest.setValue(self.isAccepted, forKey: "is_accepted")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
//            Hayır denirse olacaklar
            do {
                    self.context.delete(selectedRequest)
                    try self.context.save()
                    self.requestList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch let error as NSError {
                    print("Could not delete product. \(error), \(error.userInfo)")
                }
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ProductCell", owner: self)?.first as! ProductCell
        let request = requestList[indexPath.row]
        let fetchProduct: NSFetchRequest<Products> = Products.fetchRequest()
        
        cell.imgView.isHidden = false
        if let productIdString = request.product_id?.uuidString {
            fetchProduct.predicate = NSPredicate(format: "product_id == %@", productIdString)
            
            do {
                let productResults = try context.fetch(fetchProduct)
                
                if let product = productResults.first {
                    if let productName = product.product_name {
                        cell.nameTextField.text = productName
                    } else {
                        cell.nameTextField.text = nil
                    }
                }
            } catch let error as NSError {
                print("Could not fetch product with id. \(error), \(error.userInfo)")
            }
        }
        
        return cell
    }
}
