//
//  FeedReportVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/23.
//

import Foundation
import UIKit
import Alamofire

class FeedReportVC : UIViewController{
    
    var badListModel : BadListModel?
    var reportFinalModel : ReportFinalModel?

    @IBOutlet weak var reportFinalBg: UIView!
    @IBOutlet weak var reportText: UILabel!
    
    @IBOutlet weak var blackBg: UIView!
    @IBOutlet weak var popupBg: UIView!
    private let checkOn = UIImage(named:"check_on")
    private let checkOff = UIImage(named:"check_off")
    var postNum = 0
    var getPostNum = 0
    var reportNum = 0
    @IBOutlet weak var finalPop: UIView!
    //신고항목
    @IBOutlet weak var reportTitle1: UILabel!
    @IBOutlet weak var reportTitle2: UILabel!
    @IBOutlet weak var reportTitle3: UILabel!
    @IBOutlet weak var reportTitle4: UIView!
    
    //체크박스 뷰상태
    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    @IBOutlet weak var check3: UIImageView!
    @IBOutlet weak var check4: UIImageView!
    @IBOutlet weak var check5: UIImageView!
    @IBOutlet weak var check6: UIImageView!
    @IBOutlet weak var check7: UIImageView!
    //체크박스눌리는영역
    @IBOutlet weak var check1Area: UIView!
    @IBOutlet weak var check2Area: UIView!
    @IBOutlet weak var check3Area: UIView!
    @IBOutlet weak var check4Area: UIView!
    @IBOutlet weak var check5Area: UIView!
    @IBOutlet weak var check6Area: UIView!
    @IBOutlet weak var check7Area: UIView!
    
    @IBAction func reportBtn(_ sender: Any) {
        //신고목록서버호출
//        getReportList()
        
        //신고하기
        print("서버호출 :\(postNum)")
        repostRequest(postNum)
    }
    
    // MARK: - viewDidLoadx
    override func viewDidLoad() {
        
        //게시글번호 가져오기
        print("가져온값:\(postNum)")
    

        //팝업라운드
        popupBg.cournerRound12()
        //기본세팅
        self.check1.image = UIImage(named:"check_off")
        self.check2.image = UIImage(named:"check_off")
        self.check3.image = UIImage(named:"check_off")
        self.check4.image = UIImage(named:"check_off")
        self.check5.image = UIImage(named:"check_off")
        self.check6.image = UIImage(named:"check_off")
        self.check7.image = UIImage(named:"check_off")
        
        //신고완료팝업
        finalPop.cournerRound12()
        //완료팝업닫기
        let tapGestureRecognizer0 = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        finalPop.addGestureRecognizer(tapGestureRecognizer0)
        
        //전체배경눌러끄기
        let tapGestureBG = UITapGestureRecognizer(target: self, action: #selector(closeBGPopup))
        blackBg.addGestureRecognizer(tapGestureBG)
        
        // 토글액션
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkAction1))
        check1Area.addGestureRecognizer(tapGestureRecognizer)
        // 토글액션
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(checkAction2))
        check2Area.addGestureRecognizer(tapGestureRecognizer2)
        // 토글액션
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(checkAction3))
        check3Area.addGestureRecognizer(tapGestureRecognizer3)
        // 토글액션
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(checkAction4))
        check4Area.addGestureRecognizer(tapGestureRecognizer4)
        // 토글액션
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(checkAction5))
        check5Area.addGestureRecognizer(tapGestureRecognizer5)
        // 토글액션
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(checkAction6))
        check6Area.addGestureRecognizer(tapGestureRecognizer6)
        // 토글액션
        let tapGestureRecognizer7 = UITapGestureRecognizer(target: self, action: #selector(checkAction7))
        check7Area.addGestureRecognizer(tapGestureRecognizer7)
        
    }
    
    //신고완료팝업닫기
    @objc func closePopup(sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    //신고완료팝업닫기
    @objc func closeBGPopup(sender: UITapGestureRecognizer){
        //창모두닫기
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func checkAction1(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if self.check1.image === self.checkOff{
                self.check1.image = UIImage(named:"check_on")
                self.reportNum = 2
                
            }else{
                self.check1.image = UIImage(named:"check_off")
                
            }
        }
    }
    
    @objc func checkAction2(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if self.check2.image === self.checkOff{
                self.check2.image = UIImage(named:"check_on")
                self.reportNum = 3
                
            }else{
                self.check2.image = UIImage(named:"check_off")
                
            }
        }
    }
    
    @objc func checkAction3(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if self.check3.image === self.checkOff{
                self.check3.image = UIImage(named:"check_on")
                self.reportNum = 4
            }else{
                self.check3.image = UIImage(named:"check_off")
                
            }
        }
    }
    
    @objc func checkAction4(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if self.check4.image === self.checkOff{
                self.check4.image = UIImage(named:"check_on")
                self.reportNum = 5
            }else{
                self.check4.image = UIImage(named:"check_off")
                
            }
        }
    }
    
    @objc func checkAction5(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if self.check5.image === self.checkOff{
                self.check5.image = UIImage(named:"check_on")
                self.reportNum = 6
            }else{
                self.check5.image = UIImage(named:"check_off")
                
            }
        }
    }
    
    @objc func checkAction6(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if self.check6.image === self.checkOff{
                self.check6.image = UIImage(named:"check_on")
                self.reportNum = 7
            }else{
                self.check6.image = UIImage(named:"check_off")
                
            }
        }
    }
    
    @objc func checkAction7(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if self.check7.image === self.checkOff{
                self.check7.image = UIImage(named:"check_on")
                self.reportNum = 8
            }else{
                self.check7.image = UIImage(named:"check_off")
                
            }
        }
    }
    
    
    //MARK: - 신고하기POST
    func repostRequest(_ postNum: Int) {
        
        print(postNum)
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        let url = "https://dev.joeywrite.shop/app/posts/report"
        
        let param :Parameters = [
            "postId": postNum,
            "reasonId" : reportNum
            
        ]
        print("⭐️신고파라미터:\(param)")

        AF.request(url,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json",
                             "Accept":"application/json",
                             "X-ACCESS-TOKEN" : token
                            ])
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result{
            case .success(_):
                
                guard let jsonObject = try! res.result.get() as? [String :Any] else {
                    print("올바른 응답값이 아닙니다.")
                    return
                }
                
                print("서버호출")
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.reportFinalModel = try JSONDecoder().decode(ReportFinalModel.self, from: dataJSON)
                    
                    print("⭐️reportFinalModel:\(self.reportFinalModel)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.popupBg.isHidden = true //팝업숨김
                        self.reportFinalBg.isHidden = false //신고완료팝업
                        self.reportText.text = "해당 게시글이 신고되었습니다."
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
             
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                   self.popupBg.isHidden = true //팝업숨김
                self.reportFinalBg.isHidden = false //신고완료팝업
                self.reportText.text = "해당 게시글이 신고를 실패하였습니다."
                }
            }
        }
    }
    
    //MARK: - 신고목록API(사용X)get
    func getReportList() {

        let url = "https://dev.joeywrite.shop/app/posts/report/reason"
        print("⭐️신고목록호출:\(url)")

        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json",
                             "Accept":"application/json"
                            ])
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result{
            case .success(_):
                
                guard let jsonObject = try! res.result.get() as? [String :Any] else {
                    print("올바른 응답값이 아닙니다.")
                    return
                }
                
                print("서버호출")
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.badListModel = try JSONDecoder().decode(BadListModel.self, from: dataJSON)
                    
//                    self.reportTitle1.text = self.badListModel?.result?.reasonID
                    
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
            }
        }
    }
    
    //MARK: - savePop
    func saveOkPop(){
        //저장얼럿띄우기
        let storyBoard = UIStoryboard.init(name: "UIPopupReportOK", bundle: nil)
        let popupVC = storyBoard.instantiateViewController(identifier: "UIPopupReportOK")
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: false, completion: nil)
        
    }
    
}


