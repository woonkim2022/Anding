//
//  ProfileVC.swift
//  Anding
//
//  Created by woonKim on 2022/10/18.
//

import UIKit
import Alamofire

class ProfileVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var iDDeleteModel: IDDeleteModel?
    
    let profileDefaultImg = UIImage(named: "profile.svg")
    let profileEditImg = UIImage(named: "profileEdit.svg")
    let profileEditCameraImg = UIImage(named: "profileEditCamera.svg")
    
    let nickNameCheckUrl = "https://dev.joeywrite.shop/app/users/check/nickname"
    let modifyUserProfileUrl = "https://dev.joeywrite.shop/app/users/profile"
    
    let imagePickerController = UIImagePickerController()
    let alertController = UIAlertController(title: "올릴 방식을 선택하세요", message: "사진 찍기 또는 앨범에서 선택", preferredStyle: .actionSheet)
    
    var nickNameSameCheck = true
    var tokenFromMyVC = ""
    var userInputImage = false
    var sendImg: UIImage? // 이미지받아오기
    var nickNameFromMy = ""
    var introduceFromMy = ""
    var profilePhotoFromMy: UIImage?
    var imageDeleted = false
    var jsonData: [String: Any] = [:]
    
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var nickNameSameCheckAlarmLbl: UILabel!
    @IBOutlet weak var introduceTxCount: UILabel!
    
    @IBOutlet weak var profilePhotoEdit: UIImageView!
    @IBOutlet weak var profileEditCamera: UIImageView!
    
    @IBOutlet weak var nickNameTxField: UITextField!
    @IBOutlet weak var introduceTxField: UITextField!
    
    //백버튼
    @IBOutlet weak var backTapView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백 버튼 뷰
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backTap(sender:)))

        // 백 버튼 뷰
        backTapView.addGestureRecognizer(tapGesture)
        
        profileEditCamera.image = UIImage(named: "profile.svg")
        
        print("@@@@@@@@@@@PPPPP\(tokenFromMyVC)PPPPPPPPPPP")
        print("%%%%%\(jsonData.count)%%%")
        
        profilePhotoEdit.layer.cornerRadius = profilePhotoEdit.frame.width / 2
        profilePhotoEdit.image = profilePhotoFromMy
        profileEditCamera.image = profileEditCameraImg
        
        nickNameTxField.delegate = self
        nickNameTxField.layer.cornerRadius = 6
        nickNameTxField.layer.borderWidth = 1
        nickNameTxField.layer.borderColor = UIColor.white.cgColor
        nickNameTxField.textColor = .white
        nickNameTxField.setLeftPadding(12)
        nickNameTxField.autocorrectionType = .no
        nickNameTxField.placeholder = nickNameFromMy
        
        introduceTxField.delegate = self
        introduceTxField.layer.cornerRadius = 6
        introduceTxField.layer.borderWidth = 1
        introduceTxField.layer.borderColor = UIColor.white.cgColor
        introduceTxField.textColor = .white
        introduceTxField.setLeftPadding(12)
        introduceTxField.autocorrectionType = .no
        introduceTxField.placeholder = introduceFromMy
        
        self.changeNickNameTextColor()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        enrollAlertEvent()
        self.imagePickerController.delegate = self
        nickNameSameCheckAlarmLbl.isHidden = true
        
        addGestureRecognizer()
        
        print("##########\(String(describing: nickNameTxField.placeholder))#####")
        
    }
    
    @objc func backTap(sender: UITapGestureRecognizer) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
   
    @IBAction func nickNameTxFieldEditingChanged(_ sender: Any) {
        
        nickNameSameCheckAlarmLbl.text = ""
        
        if (nickNameTxField.text!.count > 0) {
            nickNameSameCheck = validateNickName(validNickName: nickNameTxField.text!)
        }
        print(nickNameSameCheck)
        print(nickNameTxField.text!.count)
        
        if nickNameSameCheck == false {
            nickNameSameCheckAlarmLbl.text = "특수문자와 한글 자음, 모음은 사용될 수 없습니다."
            nickNameSameCheckAlarmLbl.isHidden = false
        } else {
            nickNameSameCheckAlarmLbl.isHidden = true
        }
        
        if nickNameTxField.text!.count > 12 {
            nickNameTxField.deleteBackward()
        }
    }
    
    @IBAction func nickNameSameCheckBtn(_ sender: UIButton) {
        
        if nickNameSameCheck == false {
            let alert = UIAlertController(title: "닉네임 작성 양식을 지켜주세요.", message: .none, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let nickName = nickNameTxField.text else { return }
        let params: Parameters = ["nickname" : nickName]
        
        AF.request(nickNameCheckUrl,
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
                        
                        if getData.code == 1002 {
                            self.nickNameSameCheckAlarmLbl.text = "사용 가능한 닉네임 입니다."
                            self.nickNameSameCheckAlarmLbl.isHidden = false
                        }
                        
                        if getData.code == 3016 {
                            self.nickNameSameCheckAlarmLbl.text = "이미 등록된 닉네임 입니다."
                            self.nickNameSameCheckAlarmLbl.isHidden = false
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
    
    @IBAction func introduceTxFieldEditingChanged(_ sender: Any) {
        
        print(introduceTxField.text!)
        introduceTxCount.text = String(introduceTxField.text!.count)
        
        if introduceTxField.text!.count > 30 {
            introduceTxField.deleteBackward()
        }
    }
    
    @IBAction func completion(_ sender: Any) {
        print("컴플리션테스트")
        print(userInputImage == false)
        print(introduceTxField.text!.count)
        
        sendProfileEdit(sendImg)
        
        let alert = UIAlertController(title: "프로필 수정이 완료 되었습니다.", message: .none, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func sendProfileEdit(_ image: UIImage?) {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        let url = "https://dev.joeywrite.shop/app/users/profile"
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Accept" : "application/json",
            "X-ACCESS-TOKEN" : token
        ]

        if nickNameTxField.text! != nickNameFromMy && nickNameSameCheckAlarmLbl.isHidden == false && nickNameSameCheckAlarmLbl.text! == "사용 가능한 닉네임 입니다." {
            jsonData = [
                "nickname": nickNameTxField.text!
            ]
        }
        
        if introduceTxField.text != introduceFromMy && introduceTxField.text!.count > 0 {
            jsonData = [
                "introduction": introduceTxField.text!
            ]
        }
        
        if nickNameTxField.text! != nickNameFromMy && nickNameSameCheckAlarmLbl.isHidden == false && nickNameSameCheckAlarmLbl.text! == "사용 가능한 닉네임 입니다." && introduceTxField.text! != introduceFromMy && nickNameTxField.text!.count > 0 && introduceTxField.text!.count > 0 {
            jsonData = [
                "nickname": nickNameTxField.text!,
                "introduction": introduceTxField.text!
            ]
        }

        if jsonData.count == 0 && self.userInputImage == false && self.imageDeleted == false {
            return
        }
        
        // 딕셔너리를 string으로 저장
        var jsonObj : String = ""
        do {
            
            let jsonCreate = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            
            // json데이터를 변수에 삽입 실시
            jsonObj = String(data: jsonCreate, encoding: .utf8) ?? ""
            print("⭐️만든제이순 jsonObj : " , jsonObj)
        } catch {
            print(error.localizedDescription)
        }
        
        let alamo = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("\(jsonObj)".data(using:.utf8)!, withName: "patchUserProfileReq", mimeType: "application/json")
            
            // 이미지 교체나 기존 프로필 이미지 삭제를 한 상태에서만 이미지 보냄
            if self.userInputImage != false || self.imageDeleted != false {
                if let img = self.sendImg?.jpegData(compressionQuality: 1) {
                    print( "⭐️이미지체크:= : \(img)!")
                    multipartFormData.append(img, withName: "image", fileName: "\(String(describing: image)).jpg", mimeType: "image/jpeg")
                }
            }
        
        }, to: url, method: .put, headers: header)
            .validate(contentType: ["application/json"])
        
        alamo.response { response in
            
            switch response.result {
            case .success(let value):
                do {
                    let jsonDecoder = JSONDecoder()
                    guard let valueFromServer = value else { return }
                    let parsedData = try jsonDecoder.decode(UserProfieEdit.self, from: valueFromServer)
                    
                    print( "⭐️일상업로드응답:= : \(parsedData)!")
                    
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
            case .failure(let value):
                print("failure: \(value)")
            }
        }
    }
    
    
    //MARK: - 계정삭제 버튼
    @IBAction func deleteAccount(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "계정삭제", message: "정말로 계정을 삭제 하시겠습니까? 계정삭제시 작성한 게시글도 함께 삭제됩니다. 삭제된 데이터는 복구되지 않습니다.이에 동의시 삭제버튼을 눌러주세요.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "삭제", style: .default) { [self] (_) in
            
            // 삭제서버호출
            postDelete()
            print("계정삭제")
            
        }
        alert.addAction(alertAction)
        
        // 취소글자 상태값
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        let alert = UIAlertController(title: "앤딩 로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "로그아웃", style: .default) { [self] (_) in
            
                // 로그인화면으로 이동
                let login = UIStoryboard(name: "LoginVC", bundle: nil)
                guard let vc = login.instantiateViewController(withIdentifier: "LoginVC")as? LoginVC else {return}
                
                vc.modalPresentationStyle = .currentContext
                self.present(vc, animated: true, completion: nil)
            
        }
        alert.addAction(alertAction)
        
        // 취소글자 상태값
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
      
    }
    
    //MARK: - 계정삭제 호출
    func postDelete(){

        let url = "https://dev.joeywrite.shop/app/users/withdrawl"
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        AF.request(url,
                   method:.delete,
                   parameters:nil,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json",
                             "Accept":"application/json",
                             "X-ACCESS-TOKEN" : token
                            ])
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler:{ res in
            switch res.result{
            case .success(_):
                
                guard try! res.result.get() is [String :Any] else {
                    print("올바른 응답값이 아닙니다.")
                    return
                }
                
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.iDDeleteModel = try JSONDecoder().decode(IDDeleteModel.self, from: dataJSON)
                    print("🔴삭제 postDelModel:\(self.iDDeleteModel)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        let alert = UIAlertController(title: "회원탈퇴가 완료되었습니다.", message: .none, preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(ok)
                        
                        // 토큰삭제
                        UserDefaults.standard.removeObject(forKey: "token")
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        // 로그인화면으로 이동
                        let login = UIStoryboard(name: "LoginVC", bundle: nil)
                        guard let vc = login.instantiateViewController(withIdentifier: "LoginVC")as? LoginVC else {return}
                        
                        vc.modalPresentationStyle = .currentContext
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                } // 디코딩 에러잡기
                catch let DecodingError.dataCorrupted(context) {
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
                
                
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
                //삭제완료얼럿띄우기
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    
                    let alert = UIAlertController(title: "회원탈퇴에 실패했습니다. 다시시도해주세요.", message: .none, preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
    )}
    
    
    func enrollAlertEvent() {
        let photoLibraryAlertAction = UIAlertAction(title: "사진 앨범", style: .default) {
            (action) in
            self.openAlbum() // 아래에서 설명 예정.
        }
        
        let profilePhotoDeleteAlertAction = UIAlertAction(title: "기존 프로필 삭제", style: .default) {
            (action) in
            print("기존 프로필 삭제 클릭 실행")
            self.imageDeleted = true
            self.profilePhotoEdit.image = self.profileEditImg
            self.profileEditCamera.image = self.profileEditCameraImg
            self.sendImg = self.profileDefaultImg
        }
        //            let cameraAlertAction = UIAlertAction(title: "카메라", style: .default) {(action) in
        //                self.openCamera() // 아래에서 설명 예정.
        //            }
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.alertController.addAction(photoLibraryAlertAction)
        //            self.alertController.addAction(cameraAlertAction)
        self.alertController.addAction(profilePhotoDeleteAlertAction)
        self.alertController.addAction(cancelAlertAction)

        guard let alertControllerPopoverPresentationController
                = alertController.popoverPresentationController
        else {return}
        prepareForPopoverPresentation(alertControllerPopoverPresentationController)
    }
    
    func openAlbum() {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.modalPresentationStyle = .fullScreen
        present(self.imagePickerController, animated: false, completion: nil)
    }
    
    //    func openCamera() {
    //           if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
    //               self.imagePickerController.sourceType = .camera
    //               present(self.imagePickerController, animated: false, completion: nil)
    //           }
    //           else {
    //               print ("Camera's not available as for now.")
    //           }
    //       }
    
    func addGestureRecognizer() {
        let tapGestureRecognizer
        = UITapGestureRecognizer(target: self,
                                 action: #selector(self.tappedUIImageView(_:)))
        self.profilePhotoEdit.addGestureRecognizer(tapGestureRecognizer)
        self.profilePhotoEdit.isUserInteractionEnabled = true
    }
    
    @objc func tappedUIImageView(_ gesture: UITapGestureRecognizer) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage {
            userInputImage = true
            profilePhotoEdit?.image = image
            sendImg = profilePhotoEdit.image
            print("%%%%%%%%%\(userInputImage)%%%%%%%")
        }
        else {
            print("error detected in didFinishPickinMediaWithInfo method")
        }
        dismiss(animated: true, completion: nil) // 반드시 dismiss 하기.
    }
    
    func changeNickNameTextColor() {
        
        guard let text = self.nickNameLbl.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
        self.nickNameLbl.attributedText = attributedString
    }
    
    func validateNickName(validNickName : String) -> Bool {
        
        let nickNameReg = "[a-zA-z0-9가-힣]{1,12}"
        let nickNameChanged = NSPredicate(format: "SELF MATCHES %@", nickNameReg)
        
        return nickNameChanged.evaluate(with: validNickName)
    }
}

extension ProfileVC: UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let popoverPresentationController =
            self.alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect
            = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
}
