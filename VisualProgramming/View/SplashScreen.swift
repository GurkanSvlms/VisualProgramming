//
//  SplashScreen.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 24.04.2023.
//

import UIKit

class SplashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRegocnizer = UITapGestureRecognizer(target: self, action: #selector(goToHomeVC))
        view.addGestureRecognizer(gestureRegocnizer)
    }
    
    @objc func goToHomeVC(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.performSegue(withIdentifier: "goToLoginVC", sender: nil)
        }
    }
    



}
