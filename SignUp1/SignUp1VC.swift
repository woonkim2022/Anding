//
//  SignUp1VC.swift
//  Anding
//
//  Created by woonKim on 2022/10/09.
//

import UIKit
import Alamofire

class SignUp1VC: UIViewController, UITextFieldDelegate  {
    
    let hideShowPwBtn1 = UIButton()
    let hideShowPwBtn2 = UIButton()
    let idCheckUrl = "https://dev.joeywrite.shop/app/users/check/id"
    
    var idWriteCheck: Bool = false
    var idExistCheck: Bool = true
    var pwWriteCheck: Bool = false
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var idCheckLbl: UILabel!
    @IBOutlet weak var idExistCheckLbl: UILabel!
    @IBOutlet weak var pwLbl: UILabel!
    @IBOutlet weak var pwCheckLbl: UILabel!
    @IBOutlet weak var pwValidationCheckLbl: UILabel!
    @IBOutlet weak var pwSameCheckLbl: UILabel!
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var pw: UITextField!
    @IBOutlet weak var pwCheck: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        id.delegate = self
        pw.delegate = self
        pwCheck.delegate = self
    
        hideShowPwBtn1.setImage(UIImage(named: "hidePw.svg"), for: .normal)
        hideShowPwBtn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0)
        hideShowPwBtn1.frame = CGRect(x: CGFloat(pw.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        hideShowPwBtn1.addTarget(self, action: #selector(pwHideShow), for: .touchUpInside)
        
        hideShowPwBtn2.setImage(UIImage(named: "hidePw.svg"), for: .normal)
        hideShowPwBtn2.imageEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0)
        hideShowPwBtn2.frame = CGRect(x: CGFloat(pw.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        hideShowPwBtn2.addTarget(self, action: #selector(pwCheckHideShow), for: .touchUpInside)
        
        id.layer.cornerRadius = 6
        id.layer.borderWidth = 1
        id.layer.borderColor = UIColor.white.cgColor
        id.textColor = .white
        id.setLeftPadding(12)
        id.autocorrectionType = .no
        
        pw.layer.cornerRadius = 6
        pw.layer.borderWidth = 1
        pw.layer.borderColor = UIColor.white.cgColor
        pw.textColor = .white
        pw.setLeftPadding(12)
        pw.rightView = hideShowPwBtn1
        pw.rightViewMode = .always
        pw.isSecureTextEntry = true

        pwCheck.layer.cornerRadius = 6
        pwCheck.layer.borderWidth = 1
        pwCheck.layer.borderColor = UIColor.white.cgColor
        pwCheck.textColor = .white
        pwCheck.setLeftPadding(12)
        pwCheck.rightView = hideShowPwBtn2
        pwCheck.rightViewMode = .always
        pwCheck.isSecureTextEntry = true
        
        pwValidationCheckLbl.isHidden = true
        pwSameCheckLbl.isHidden = true
        idCheckLbl.isHidden = true
        idExistCheckLbl.isHidden = true
        
        self.changeIdTextColor()
        self.changePwTextColor()
        self.changePwCheckTextColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
           self.view.endEditing(true)
    }
    
    @IBAction func escBtn(_ sender: UIButton) {
        
        guard let vc = self.presentingViewController as? LoginVC else {
            return
        }
   
        vc.dismiss(animated: true)
    }
    
    @IBAction func idCheckBtn(_ sender: UIButton) {
        
        if idCheckLbl.text == "아이디는 숫자로만 구성될 수 없습니다." {
            
            let alert = UIAlertController(title: "아이디는 숫자로만 구성될 수 없습니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if idWriteCheck == true {
        
        guard let id = id.text else { return }
        let params: Parameters = ["userId" : id]
        
        AF.request(idCheckUrl,
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
                   
                    let getData = try JSONDecoder().decode(SameIdNickName.self, from: dataJson)
                    print(getData)
                        
                    if getData.code == 1001 {
                        self.idExistCheckLbl.isHidden = false
                        self.idExistCheckLbl.text = "사용 가능한 아이디 입니다."
                        self.idExistCheck = true
                    }
                        
                    if getData.code == 3015 {
                        self.idExistCheckLbl.isHidden = false
                        self.idExistCheckLbl.text = "이미 등록된 아이디 입니다."
                        self.idExistCheck = false
                    }
                        
                    print(getData.code)

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
    }
    
    @IBAction func pwSameCheckChanged(_ sender: UITextField) {
        
        if pw.text! != pwCheck.text! {
            pwSameCheckLbl.isHidden = false
        }
        if pw.text! == pwCheck.text! {
            pwSameCheckLbl.isHidden = true
        }
        if pwCheck.text!.count > 20 {
            pwCheck.deleteBackward()
        }
    }
   
    @IBAction func nextBtn(_ sender: UIButton) {
        
        if idCheckLbl.text == "아이디는 숫자로만 구성될 수 없습니다." {
            
            let alert = UIAlertController(title: "아이디는 숫자로만 구성될 수 없습니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if idWriteCheck == false {
            
            let alert = UIAlertController(title: "아이디 작성 양식을 지켜주세요.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if pwWriteCheck == false {
            let alert = UIAlertController(title: "비밀번호 작성 양식을 지켜주세요.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)

            present(alert, animated: true, completion: nil)
            return
        }
        
        if idExistCheckLbl.text == "이미 등록된 아이디 입니다." {
            let alert = UIAlertController(title: "이미 등록된 아이디 입니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)

            present(alert, animated: true, completion: nil)
            return
        }
        
        if idExistCheckLbl.text != "사용 가능한 아이디 입니다." {
            let alert = UIAlertController(title: "아이디 중복 확인이 필요합니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if pwCheck.text!.count == 0 {
            
            let alert = UIAlertController(title: "비밀번호 확인이 필요합니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        if pwSameCheckLbl.isHidden == false {
            let alert = UIAlertController(title: "비밀번호가 일치하지 않습니다.", message: .none, preferredStyle: .alert)

            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)

            present(alert, animated: true, completion: nil)
            return
        }
        
        if idWriteCheck == true && pwWriteCheck == true && pw.text!.count > 0 && pwSameCheckLbl.isHidden == true {
            
            let signUp2 = UIStoryboard(name: "SignUp2VC", bundle: nil)
            guard let vc = signUp2.instantiateViewController(withIdentifier: "SignUp2VC")as? SignUp2VC else {return}
            
            vc.idFromSignUp1 = id.text!
            vc.pwFromSignUp1 = pw.text!
            
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
        
    @objc func pwHideShow(sender: UIButton) {
        
        if pw.isSecureTextEntry == true {
            hideShowPwBtn1.setImage(UIImage(named: "showPw.svg"), for: .normal)
            pw.isSecureTextEntry.toggle()
        } else {
            hideShowPwBtn1.setImage(UIImage(named: "hidePw.svg"), for: .normal)
            pw.isSecureTextEntry.toggle()
        }
    }
    
    @objc func pwCheckHideShow(sender: UIButton) {
        
        if pwCheck.isSecureTextEntry == true {
            hideShowPwBtn2.setImage(UIImage(named: "showPw.svg"), for: .normal)
            pwCheck.isSecureTextEntry.toggle()
        } else {
            hideShowPwBtn2.setImage(UIImage(named: "hidePw.svg"), for: .normal)
            pwCheck.isSecureTextEntry.toggle()
        }
    }
    
    @IBAction func idChanged(_ sender: UITextField) {
        print(id.text!)
        
        idExistCheckLbl.text = ""
        
        let idChanged = validateId(validId: id.text!)
        
        if idChanged == true {
            idWriteCheck = true
        } else {
            idWriteCheck = false
        }
        
        let idOnlyNumberCheck = validateOnlyNumber(validIdOnlyNumber: id.text!)
        
        print(idChanged)
        print(id.text!.count)
        
        if idOnlyNumberCheck == true {
            idCheckLbl.text = "아이디는 숫자로만 구성될 수 없습니다."
            idCheckLbl.isHidden = false
        } else {
            idCheckLbl.isHidden = true
        }
        
        if idChanged == false  && id.text!.count >= 8 {
            idCheckLbl.isHidden = false
            idCheckLbl.text = "대문자, 특수문자, 한글은 포함 될 수 없습니다."
        }
        
        if id.text!.count > 16 {
            id.deleteBackward()
        }
    }
    
    @IBAction func pwChanged(_ sender: UITextField) {
        
        let pwChanged = validatePw(validPw: pw.text!)
        print(pwChanged)
        
        if pwChanged == false {
            pwWriteCheck = false
        } else {
            pwWriteCheck = true
        }
        
        if pwChanged == false && pw.text!.count >= 10 {
            pwValidationCheckLbl.isHidden = false
        }
        
        if pwChanged == true {
            pwValidationCheckLbl.isHidden = true
        }
        print(pw.text!)
        
        if pw.text! != pwCheck.text! {
            pwSameCheckLbl.isHidden = false
        }
        if pw.text! == pwCheck.text! {
            pwSameCheckLbl.isHidden = true
        }
        
        if pw.text!.count > 20 {
            pw.deleteBackward()
        }
    }
    
    func changeIdTextColor() {
        
        guard let text = self.idLbl.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
        self.idLbl.attributedText = attributedString
    }
    
    func changePwTextColor() {
        
        guard let text = self.pwLbl.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
        self.pwLbl.attributedText = attributedString
    }
    
    func changePwCheckTextColor() {
        
        guard let text = self.pwCheckLbl.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
        self.pwCheckLbl.attributedText = attributedString
    }
    
    func validateId(validId : String) -> Bool {
        
        let idReg = "[a-z0-9]{8,16}"
        let idChanged = NSPredicate(format: "SELF MATCHES %@", idReg)
        
        return idChanged.evaluate(with: validId)
    }
    
    
    func validateOnlyNumber(validIdOnlyNumber : String) -> Bool {
            
        let idReg = "[0-9]{8,16}"
        let idChanged = NSPredicate(format: "SELF MATCHES %@", idReg)
        
        return idChanged.evaluate(with: validIdOnlyNumber)
    }
    
    func validatePw(validPw : String) -> Bool {
        
        let pwReg = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[~!@#$%^&*]).{10,20}$"
        let idChanged = NSPredicate(format: "SELF MATCHES %@", pwReg)
        
        return idChanged.evaluate(with: validPw)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }
}

extension UITextField {
    
    func setLeftPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y:0, width: 12, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y:0, width: 12, height: 0))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
