//
//  LoginController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 6.05.2023.
//

import UIKit
import CoreData

class LoginController: UIViewController {

    @IBOutlet weak var segmentedContoller: UISegmentedControl!
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.tintColor = .systemGray5

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        switch segmentedContoller.selectedSegmentIndex {
        case 0:
            let fetchRequest: NSFetchRequest<Manufactor> = Manufactor.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "user_id == %@", idTextField.text!)
                    
                    do {
                        let userResults = try context.fetch(fetchRequest)
                        if userResults.count > 0 {
                            let user = userResults.first!
                            if user.user_password == passwordTextField.text {
                                // Kullanıcı girişi başarılı, istenilen işlemler yapılabilir
                                performSegue(withIdentifier: "goToManufactorVC", sender: nil)
                                print("Kullanıcı girişi başarılı!")
                            } else {
                                print("Hatalı şifre!")
                            }
                        } else {
                            print("Kullanıcı bulunamadı!")
                        }
                    } catch let error as NSError {
                        print("Could not fetch users. \(error), \(error.userInfo)")
                    }
        case 1:
            let fetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "user_id == %@", idTextField.text!)
                    
                    do {
                        let userResults = try context.fetch(fetchRequest)
                        if userResults.count > 0 {
                            let user = userResults.first!
                            if user.user_password == passwordTextField.text {
                                // Kullanıcı girişi başarılı, istenilen işlemler yapılabilir
                                performSegue(withIdentifier: "goToCustomerVC", sender: self)
                                print("Kullanıcı girişi başarılı!")
                            } else {
                                print("Hatalı şifre!")
                            }
                        } else {
                            print("Kullanıcı bulunamadı!")
                        }
                    } catch let error as NSError {
                        print("Could not fetch users. \(error), \(error.userInfo)")
                    }
        default:
            break
        }
    }
    @IBAction func textFieldDidChange(_ sender: Any) {
        if let id = idTextField.text, !id.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
            loginButton.isEnabled = true
            loginButton.tintColor = #colorLiteral(red: 0.9197836518, green: 0.6721765399, blue: 0.04132012278, alpha: 1)
        
        } else {
            loginButton.isEnabled = false
            loginButton.tintColor = .systemGray5
        }
    }
        @IBAction func signUpButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToSignUpVC", sender: nil)
    }
    
    @IBAction func segmentedContollerChanged(_ sender: Any) {
        switch segmentedContoller.selectedSegmentIndex {
        case 0:
            idTextField.placeholder = "Manufactor ID"
        case 1:
            idTextField.placeholder = "Customer ID"
        default:
            break
        }
    }
    // Verileri hazırla ve alıcı ekranı belirle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToManufactorVC" {
            // Alıcı ekranın ViewController örneğini al
            if let destinationVC = segue.destination as? ManufactorHomeController {
                // Gönderilecek veriyi belirle
                let dataToSend = idTextField.text
                // Alıcı ekranın veri değişkenine atama yap
                destinationVC.currentUser = dataToSend
            }
        }
    }

    
}
