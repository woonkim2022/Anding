//
//  MyVC.swift
//  Anding
//
//  Created by woonKim on 2022/10/18.
//

import UIKit
import Alamofire
import Kingfisher

class MyVC: UIViewController {
    
    @IBOutlet weak var ProfileTapView: UIView!
    @IBOutlet weak var BookMarkTapView: UIView!
    
    let myPostUrl = "https://dev.joeywrite.shop/app/users/my-posts/number"
    let myBookUrl = "https://dev.joeywrite.shop/app/users/my-autobiographies/number"
    let myProfileUrl = "https://dev.joeywrite.shop/app/users/profile"
    
    var introduceTxFromProfile = ""
    
    var profileKingfisher: UIImage?
    
    let profileImg = UIImage(named: "profile.svg")
    let profileLineImg = UIImage(named: "profileLine.svg")
    let contentLineImg = UIImage(named: "contentLine.svg")
    let temporaryBookPresentImg = UIImage(named: "temporaryBookPresent.png")
    
    var nickName = UserDefaults.standard.value(forKey: "nickName") as! String
    var token = UserDefaults.standard.value(forKey: "token") as! String
    
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var myPostCountLbl: UILabel!
    @IBOutlet weak var myBookCountLbl: UILabel!
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var profileLine: UIImageView!
    @IBOutlet weak var contentLine: UIImageView!
    @IBOutlet weak var introduceTxView: UITextView!
    
    var viewWillAppearCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileDataGet()
        
        // 백 버튼 뷰
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))

        // 백 버튼 뷰
        ProfileTapView.addGestureRecognizer(tapGesture)
        
        // 백 버튼 뷰
        let bookMarkGesture = UITapGestureRecognizer(target: self, action: #selector(handleBookMarkTap(sender:)))

        // 백 버튼 뷰
        BookMarkTapView.addGestureRecognizer(bookMarkGesture)
        
        print("@@@@@@@@@@@@@@@@@@@@\(nickName)@@@@@@@@@@@@@@@@@@")
        print("@@@@@@@@@@@@@@@@@@@@\(token)@@@@@@@@@@@@@@@@@@")
        
        profile.image = profileImg
        profile.layer.cornerRadius = profile.frame.width / 2
        profileLine.image = profileLineImg
        contentLine.image = contentLineImg
        
        introduceTxView.textContainer.maximumNumberOfLines = 2
        introduceTxView.text = introduceTxFromProfile
        
    }
    
    // 화면에 표시될 때마다 실행되는 메소드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewWillAppearCount += 1
        print("뷰윌어피어카운트^^&&&&\(viewWillAppearCount)")
        print("뷰윌어피어토큰^^&&&&\(token)")
        
        profileDataGet()
        
        // 프로필 변경하고 마이페이지로 돌아왔을때 변경된 닉네임 라벨의 텍스트를 다시 유저디폴트 닉네임으로 등록
        UserDefaults.standard.setValue(nickNameLbl.text!, forKey: "nickName")
        
        print("뷰윌어피어데이터겟아래")
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else {
            return
        }
        
        vc.tokenFromMyVC = token
        vc.nickNameFromMy = nickNameLbl.text!
        vc.introduceFromMy = introduceTxView.text!
        vc.profilePhotoFromMy = profile.image
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    // 북마크버튼
    @objc func handleBookMarkTap(sender: UITapGestureRecognizer) {
        
        let vc = UIStoryboard(name:"ScrapVC" , bundle: nil).instantiateViewController(withIdentifier: "ScrapVC") as! ScrapVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true){ }
    }
    
    func profileDataGet() {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]
        
        print("뷰윌어피어실행시겟데이터토큰\(token)")
        
        AF.request(myPostUrl,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in

            switch response.result {
                case .success(let obj):
                print(obj)

                do {
                // obj(Any)를 JSON으로 변경
                let dataJson = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)

                let getData = try JSONDecoder().decode(MyPageWriteBookCount.self, from: dataJson)

                print(getData)

                if getData.code == 1000 {
                    
                    self.myPostCountLbl.text = String(getData.result!)
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
        
        AF.request(myBookUrl,
                       method: .get,
                       parameters: nil,
                       encoding: JSONEncoding.default,
                       headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in

            switch response.result {
                case .success(let obj):
                    print(obj)

                do {
                    // obj(Any)를 JSON으로 변경
                let dataJson = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                let getData = try JSONDecoder().decode(MyPageWriteBookCount.self, from: dataJson)

                print(getData)

                if getData.code == 1000 {

                self.myBookCountLbl.text = String(getData.result!)
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
        
        AF.request(myProfileUrl,
                       method: .get,
                       parameters: nil,
                       encoding: JSONEncoding.default,
                       headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in

            switch response.result {
                case .success(let obj):
                    print(obj)

                do {
                    // obj(Any)를 JSON으로 변경
                let dataJson = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                let getData = try JSONDecoder().decode(MyPageProfile.self, from: dataJson)

                print(getData)

                if getData.code == 1000 {
                    
                    self.nickNameLbl.text = getData.result.nickname
                    self.introduceTxView.text = getData.result.introduction
//                    guard let url = URL(string: getData.profileImage) else { return }
                    print("******마페접속프로필사진\(getData.result.profileImage)")
                    
//                    let url = URL(string: "\(getData.result.profileImage!)")
                    
                    if getData.result.profileImage != nil{
                        let url = URL(string: "\(getData.result.profileImage)")
                        self.profile.kf.setImage(with: url)
                    }
    
                    
//                    self.profile.image = self.profileKingfisher
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
    
    
    @IBAction func goToProfile(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else {
            return
        }
        
        vc.tokenFromMyVC = token
        vc.nickNameFromMy = nickNameLbl.text!
        vc.introduceFromMy = introduceTxView.text!
        vc.profilePhotoFromMy = profile.image
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    
 
    
    
}
