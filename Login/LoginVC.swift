//
//  LoginVC.swift
//  Anding
//
//  Created by woonKim on 2022/10/07.
//

import Foundation
import UIKit
import Alamofire

class LoginVC: UIViewController, UITextFieldDelegate {

    private let logoImg = UIImage(named: "logo.svg")
    private let lineImg = UIImage(named: "line.svg")
    private let warnImg = UIImage(named: "warn.svg")
    
    let loginUrl = "https://dev.joeywrite.shop/app/users/login"
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var warn: UIImageView!
    @IBOutlet weak var line1: UIImageView!
    @IBOutlet weak var line2: UIImageView!
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var pw: UITextField!
  
    @IBOutlet weak var reWriteWarnLbl: UILabel!
    
    override func viewDidLoad() {
    
        logo.image = logoImg
        warn.image = warnImg
//        line1.image = lineImg
//        line2.image = lineImg
        
        id.delegate = self
        id.layer.cornerRadius = 6
        id.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        id.leftViewMode = .always
        id.autocorrectionType = .no
    
        pw.delegate = self
        pw.layer.cornerRadius = 6
        pw.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        pw.leftViewMode = .always
        pw.isSecureTextEntry = true
        
        warn.isHidden = true
        reWriteWarnLbl.isHidden = true
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        
//        let main = UIStoryboard(name: "Main", bundle: nil)
//        let mainTabBarController = main.instantiateViewController(identifier: "TabBarController")
//
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)

        guard let userId = id.text else { return }
        guard let userPw = pw.text else { return }
//        let params: Parameters = ["password" :"Qwer1234!@", "userId" : "junejune2"]
        let params: Parameters = ["password" : userPw, "userId" : userId]

        AF.request(loginUrl,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in

            switch response.result {
                case .success(let obj):
                print(obj)

                do {
                // obj(Any)를 JSON으로 변경
                let dataJson = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)

                let getData = try JSONDecoder().decode(Login.self, from: dataJson)

                print(getData)

                if getData.code == 1000 {

                    guard let token = getData.result?.jwt else { return }
                    UserDefaults.standard.setValue(token, forKey: "token")

                    guard let nickName = getData.result?.nickname
                    else { return }
                    UserDefaults.standard.setValue(nickName, forKey: "nickName")

                // 로그인 성공시 홈 화면으로 이동

                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = main.instantiateViewController(identifier: "TabBarController")

                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }

                if getData.code == 2000 || getData.code == 3014 {
                    self.warn.isHidden = false
                    self.reWriteWarnLbl.isHidden = false
                }

                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {

                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }

                case .failure(let e):
                    // 통신 실패
                    print(e.localizedDescription)
            }
        }
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        
        let signUp1 = UIStoryboard(name: "SignUp1VC", bundle: nil)
        guard let vc = signUp1.instantiateViewController(withIdentifier: "SignUp1VC")as? SignUp1VC else {return}

        vc.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }
}
