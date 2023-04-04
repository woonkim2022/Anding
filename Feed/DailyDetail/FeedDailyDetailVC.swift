//
//  DailyVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/23.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class FeedDailyDetailVC :UIViewController{
    
    var dailyDetailModel : DailyDetailModel?
    var scrapModel : ScrapModel?
    var postNum = 0
    var FeedNum : Int? //게시글번호
    var otherNickname = ""
    var scrapTabMyNum = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var dateString: UILabel!
    @IBOutlet weak var closeBtn: UIImageView!
    let token = UserDefaults.standard.value(forKey:"token") as! String
    var myNickName = UserDefaults.standard.value(forKey:"nickName") as! String
    let dissmissDailyVC: Notification.Name = Notification.Name("dissmissDailyVC")
    
    
    //MARK: - 더보기버튼
    @IBAction func moreBtn(_ sender: Any) {
        
        if myNickName == otherNickname {
            myPop()
        }else{
            otherPop()
        }
    }
    
    func otherPop(){
        //게시글수정, 신고버튼팝업띄우기
        let actionSheet = UIAlertController(title: "게시글 메뉴", message: nil, preferredStyle: .actionSheet)
        
        // 신고하기버튼
        actionSheet.addAction(UIAlertAction(title: "게시글 신고하기", style: .default, handler: {(ACTION:UIAlertAction) in
            // "문답 신고하기로 이동"
            self.gotoReportVC()
            
        }))
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func myPop(){
        //게시글수정, 신고버튼팝업띄우기
        let actionSheet = UIAlertController(title: "게시글 메뉴", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "게시글 수정", style: .default, handler: {(ACTION:UIAlertAction) in
            // 수정으로 이동하기
            self.gotoModifyVC()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "게시글 삭제", style: .default, handler: {(ACTION:UIAlertAction) in
            
            // 게시글삭제팝업
            self.gotoDeletePopVC()
        }))
        
        // 신고하기버튼
        actionSheet.addAction(UIAlertAction(title: "게시글 신고하기", style: .default, handler: {(ACTION:UIAlertAction) in
            
            // "문답 신고하기로 이동"
            self.gotoReportVC()
            
        }))
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK: - 스크랩하기 팝업
    @IBAction func saveBtn(_ sender: Any) {
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        
        // 버튼두개팝업 띄우기
        let vc = UIStoryboard(name:"UIPopupTwoBtn" , bundle: nil).instantiateViewController(withIdentifier: "UIPopupTwoBtn") as! UIPopupTwoBtn
        vc.modalPresentationStyle = .overCurrentContext
        vc.postNum = FeedNum
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        getPostDetail(FeedNum ?? 0)
        
        //        if scrapTabMyNum != nil {
        //            getPostDetail(scrapTabMyNum ?? 0)
        //        }
        print("⏰일상게시글 번호\(FeedNum)")
        
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(escBtn(tapGestureRecognizer:)))
        closeBtn.addGestureRecognizer(tapImageViewRecognizer)
        closeBtn.isUserInteractionEnabled = true
    }
    
    
    //MARK: - 닫기버튼
    @objc func escBtn(tapGestureRecognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: dissmissDailyVC, object: nil, userInfo: nil)
    }
    
    
    //MARK: - 수정하기페이지로이동
    func gotoModifyVC(){
        let VC = UIStoryboard(name:"DailyModifyVC", bundle: nil).instantiateViewController(withIdentifier: "DailyModifyVC") as! DailyModifyVC
        
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        // 게시글번호
        VC.postNum = FeedNum
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: true){ }
    }
    
    //MARK: - 신고하기페이지로이동
    func gotoReportVC(){
        let VC = UIStoryboard(name:"FeedReportVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedReportVC") as! FeedReportVC
        guard let FeedNum = FeedNum else {
            return
        }
        VC.postNum = FeedNum
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: true){ }
    }
    
    //MARK: - 삭제하기페이지로이동
    func gotoDeletePopVC(){
        // 삭제 팝업열기
        let vc = UIStoryboard(name:"DeletePopVC", bundle: nil).instantiateViewController(withIdentifier: "DeletePopVC") as! DeletePopVC
        
        //게시글번호
        //게시글번호
        guard let FeedNum = FeedNum else {
            return
        }
        vc.postNum = FeedNum
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    
    //MARK: - 일상상세페이지호출
    func getPostDetail(_ postNum: Int) {
        
        let getPostNum = postNum
        
        let url = "https://dev.joeywrite.shop/app/posts/detail/\(getPostNum)"
        print("⭐️일상상세url호출:\(url)")
        
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
                
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.dailyDetailModel = try JSONDecoder().decode(DailyDetailModel.self, from: dataJSON)
                    
                    print("⭐️dailyDetailModel:\(self.dailyDetailModel)")
                    
                    self.titleLabel.text = self.dailyDetailModel?.result?.dailyTitle ?? ""
                    self.contents.text = self.dailyDetailModel?.result?.contents
                    self.dateString.text = self.dailyDetailModel?.result?.createdAt
                    self.otherNickname = self.dailyDetailModel?.result?.nickname ?? "닉네임없음"
                    
                    let imgInfo  = self.dailyDetailModel?.result?.dailyImage
                    if imgInfo != nil {
                        if let imageURL = self.dailyDetailModel?.result?.dailyImage{
                            guard let url = URL(string: imageURL) else {
                                return
                            }
                            // cell.postImg.kf.setImage(with:url)
                            self.imageView.kf.indicatorType = .activity
                            self.imageView.kf.setImage(
                                with: url,
                                placeholder: UIImage(named: "placeholderImage"),
                                options: [
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(1)),
                                    .cacheOriginalImage
                                ])
                            {
                                result in
                                switch result {
                                case .success(_): break
                                    //                        print("HeratVC 킹피셔 Task done")
                                case .failure(let err):
                                    print(err.localizedDescription)
                                }
                            }
                        }
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
            }
        }
    }
}

