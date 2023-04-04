//
//  ModifyInfoVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/12.
//

import Foundation
import UIKit
import Alamofire
import RxCocoa
import RxSwift

class ModifyInfoVC :UIViewController , UITextFieldDelegate {
    
    var feedModifyModel : FeedModifyModel?
    var dailyDetailModel:DailyDetailModel?
    
    @IBOutlet weak var shareArea: UIView!//체크박스클릭영역
    @IBOutlet weak var checkBox: UIImageView!
    private let checkOn = UIImage(named:"p_check_on")
    private let checkOff = UIImage(named:"p_check_off")
    var Ptext = ""
    var PdecText = [String]()
    var disposeBag : DisposeBag = DisposeBag()
    var shareValue = ""
    var titleText = ""
    
    @IBOutlet weak var dateString: UILabel!
    var contentsText: String? //작성내용받아오기
    var rImg: UIImage? //이미지받아오기
    var rTitle = ""
    var postNum = 0
    var getNum = 0
    
    @IBOutlet weak var dailyTitle: UITextField!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var titleCount: UILabel!
    @IBOutlet weak var QsaveBtn: UIButton!
    
    //MARK: - saveBtnAction
    @IBAction func QsaveBtn(_ sender: Any) {
        
        // 수정업로드서버호출
        ModifyImg(rImg,FeedNum: postNum)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        UISetting()
        date()
        // 토글액션
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkAction))
        shareArea.addGestureRecognizer(tapGestureRecognizer)
        
        self.checkBox.image = UIImage(named:"p_check_off")
        
        // 받아온내용
        print("ModifyInfoVC 작성내용 :\(contentsText)")
        print("DailyDetailVC 이미지 :\(rImg)")
        
        photoImg.image = rImg ?? UIImage(named: "ex")
        dailyTitle.text = contentsText
        
        // 게시글번호
        getNum = postNum
        // Rx제목적용12자 제목TextField
        //        dailyTitle.delegate = self
        dailyTitle.rx.text.orEmpty
            .map(checkAndTrimId(_:))//글자수제한제크
            .subscribe(onNext: { b in
                if b {
                    self.dailyTitle.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    
    // MARK: - 날짜
    func date(){
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 (E)"
        dateString.text = dateFormatter.string(from: today as Date)
    }
    
    
    //MARK: - savePop
    func saveOkPop(){
        //수정얼럿띄우기
        let storyBoard = UIStoryboard.init(name: "UIPopup", bundle: nil)
        let popupVC = storyBoard.instantiateViewController(identifier: "UIPopup") as! UIPopup
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.Ptext = "기록이 수정되었습니다."
        popupVC.PdecText = "일상 기록은 오직 나만 볼 수 있어요 ;)"
        self.present(popupVC, animated: false, completion: nil)
    }
    
    // MARK: - saveBTn 등록API호출
    func ModifyImg(_ image: UIImage?,FeedNum :Int) {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        let url = "https://dev.joeywrite.shop/app/posts/update/\(FeedNum)"
        
        print(url)
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Accept" : "application/json",
            "X-ACCESS-TOKEN" : token
        ]
        
//        print(token)
        
        // 작성내용,BGcolor,category ID,category~번째 질문 json에 넣어전달
        let jsonData: [String: Any] = [
            "dailyTitle": dailyTitle.text ?? "",
            "contents": contentsText ?? "",
            //               "qnaBackgroundColor": bgColor,//배경컬러,체크여부추가하기
            "filterId":"e",
            "feedShare" : shareValue
            //               "qnaQuestionId" :"없음",
            //               "qnaQuestionMadeFromUser":"유저명"
            
        ] as Dictionary
        
        
        // 딕셔너리를 string으로 저장
        var jsonObj : String = ""
        do {
            let jsonCreate = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            
            // json데이터를 변수에 삽입
            jsonObj = String(data: jsonCreate, encoding: .utf8) ?? ""
            //            print("⭐️만든제이순 jsonObj:" , jsonObj)
        } catch {
            print(error.localizedDescription)
        }
        
        // post에 담긴 제이슨
        let alamo = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("\(jsonObj)".data(using:.utf8)!, withName: "posts", mimeType: "application/json")
            
            // 갤러리 가져온이미지파일
            if let img = self.rImg?.jpegData(compressionQuality: 1) {
                multipartFormData.append(img, withName: "file", fileName: "\(String(describing: image)).jpg", mimeType: "image/jpeg")
            }
            
//            else{
                // 이미지 작성안했을때 기본이미지
//                multipartFormData.append(UIImage(named:"ex")!.jpegData(compressionQuality: 1)!, withName: "file", fileName: "", mimeType: "")
//                multipartFormData.append(UIImage(named:"ex")!.jpegData(compressionQuality: 1)!, withName: "file", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
//            }
            
        }, to: url, method: .put, headers: header)
            .validate(contentType: ["application/json"])
        
        alamo.response { response in
            
//            print("JSON= \(try! response.result.get())!)")
            
            switch response.result {

            case .success(let value):
                
                do {
                    let parsedData = try JSONDecoder().decode(FeedModifyModel?.self, from: value!)
                    print("🐬일상수정응답:= : \(String(describing: parsedData))")
                    
                    //저장완료팝업(밑에뷰다끄기안에있음)
                    self.saveOkPop()
                    
                } catch {
                    print(error.localizedDescription)
                    print(error)
                }
                
                
                
            case .failure(let value):
                print("failure: \(value)")
            }
        }
    }
    
    
    func UISetting(){
        QsaveBtn.cournerRound12()
    }
    
    //selectsheet
    @objc func checkAction(sender: UITapGestureRecognizer) {
        toggleImage()
    }
    
    func toggleImage(){
        DispatchQueue.main.async {
            if self.checkBox.image === self.checkOff {
                self.checkBox.image = UIImage(named:"p_check_on")
                self.shareValue = "Y"
                print(self.shareValue)
            }else{
                self.checkBox.image = UIImage(named:"p_check_off")
                self.shareValue = "N"
                print(self.shareValue)
            }
        }
    }
    
    //MARK: - textField 글자수 제한하기(현재입력된 문자수표기는?)
    private func checkAndTrimId(_ id: String) -> Bool {
        if id.count > 16 {
            let index = id.index(id.startIndex, offsetBy: 16)
            self.dailyTitle.text = String(id[..<index])
            
            return true
        }
        return false
    }
}

