//
//  SignUp3VC.swift
//  Anding
//
//  Created by woonKim on 2022/10/12.
//

import UIKit

class SignUp3VC: UIViewController {
    
    let logoImg = UIImage(named: "logo.svg")
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.image = logoImg
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "LoginVC", bundle: nil)
        let LoginVC = storyboard.instantiateViewController(identifier: "LoginVC")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginVC)
    }
}
