//
//  DeletePopVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/02.
//

import Foundation
import UIKit
import Alamofire

class DeletePopVC :UIViewController{
    
    var postDeldelteModel : PostDeldelteModel?
    var postNum = 0
    @IBOutlet weak var allPopBg: UIView!
    @IBOutlet weak var popupBg: UIView!
    @IBOutlet weak var deleteEndPop: UIView!
    @IBOutlet weak var deleteText: UILabel!
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    
    @IBAction func DeleteBtn(_ sender: Any) {
        //게시글 삭제호출
        postDelete(postNum: postNum)
    }
    
    
    override func viewDidLoad() {
        
        popupBg.cournerRound12()
        deleteEndPop.cournerRound12()
        print(postNum)
        
        // viewMap: View 객체
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        allPopBg.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
        dismiss(animated: true,completion: nil)
    }
    
    
    
    //MARK: - 삭제하기 호출
    func postDelete(postNum :Int){
        
        //            self.indicator.isHidden = false
        //            //start
        //            self.indicator.startAnimating()
        
        let url = "https://dev.joeywrite.shop/app/posts/delete"
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        let param :Parameters = [
            "postId": postNum
        ]
        print("⭐️삭제게시글번호:\(param)")
        
        AF.request(url,
                   method:.patch,
                   parameters: param,
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
                    self.postDeldelteModel = try JSONDecoder().decode(PostDeldelteModel.self, from: dataJSON)
                    print("🔴삭제 postDelModel:\(self.postDeldelteModel)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //                            self.indicator.stopAnimating()
                        //                            self.indicator.isHidden = true
                        self.popupBg.isHidden = true
                        self.deleteEndPop.isHidden = false
                        self.deleteText.text = "해당 게시글이 삭제 되었습니다."
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
                    
                    self.popupBg.isHidden = true
                    self.deleteEndPop.isHidden = false
                    self.deleteText.text = "게시글 삭제에 실패했습니다."
                    
                }
            }
        }
        )}
    
}
