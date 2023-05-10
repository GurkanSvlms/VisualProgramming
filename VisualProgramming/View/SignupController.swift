//
//  SignUpController.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 6.05.2023.
//

import UIKit
import CoreData


class SignUpController: UIViewController {
    @IBOutlet weak var segmentedContoller: UISegmentedControl!
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.tintColor = .systemGray5
        
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        if let id = idTextField.text, !id.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
            signUpButton.isEnabled = true
            signUpButton.tintColor = #colorLiteral(red: 0.9197836518, green: 0.6721765399, blue: 0.04132012278, alpha: 1)
        
        } else {
            signUpButton.isEnabled = false
            signUpButton.tintColor = .systemGray5
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        switch segmentedContoller.selectedSegmentIndex {
        case 0:
            let manufactorUser = Manufactor(context: context)
            manufactorUser.user_id = idTextField.text
            manufactorUser.user_password = passwordTextField.text

            do {
                try context.save()
                performSegue(withIdentifier: "gotoManufactorVC", sender: self)
                print("Kullanıcı kaydedildi.")
            } catch {
                print("Kullanıcı kaydetme hatası: \(error)")
            }
        case 1:
            let customerUser = Customer(context: context)
            customerUser.user_id = idTextField.text
            customerUser.user_password = passwordTextField.text

            do {
                try context.save()
                performSegue(withIdentifier: "gotoCustomerVC", sender: nil)
                print("Kullanıcı kaydedildi.")
                performSegue(withIdentifier: "returnLoginVC", sender: nil)
            } catch {
                print("Kullanıcı kaydetme hatası: \(error)")
            }
        default:
            break
        }
    }
    
    // Verileri hazırla ve alıcı ekranı belirle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoManufactorVC" {
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
