//
//  QnAdetail.swift
//  Anding
//
//  Created by 이청준 on 2022/10/10.
//

import Foundation
import UIKit
import Alamofire

class QnAdetailVC :UIViewController{
    
    var feedUploadModel : FeedUploadModel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shareArea: UIView!//체크박스클릭영역
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var dateString: UILabel!
    private let checkOn = UIImage(named:"p_check_on")
    private let checkOff = UIImage(named:"p_check_off")

    var contentsText = ""
    var BGcolor = ""
    var Qword = ""
    var ftID = ""
    var ftqID = ""
    
    var Qtext = ""
    var QdecText = [String]()
    //배열받아오기QfirstVC에서
    var QnAPackage = [String]()
    var shareValue = ""
    //    var bgColor2 = UIColor()
    
    @IBOutlet weak var QsaveBtn: UIButton!
    @IBAction func QsaveBtn(_ sender: Any) {
        
        //저장서버호출
        upLoadQnA()
        
        //저장완료팝업(밑에뷰다끄기안에있음)
        saveOkPop()
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: "qnaDetailCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier:"qnaDetailCell")
        
        UISetting()
        // 토글액션
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkAction))
        shareArea.addGestureRecognizer(tapGestureRecognizer)
        
        self.checkBox.image = UIImage(named:"p_check_off")
        // 체크,기본값은 N
        shareValue = "N"
        tableView.reloadData()

        //날짜
        date()
        
        // 가져온값
        print("⭐️",contentsText, BGcolor,Qword, ftID,ftqID)
    }
    
    // MARK: - 날짜(하드코딩되있음)
    func date(){
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 (E)"
        dateString.text = dateFormatter.string(from: today as Date)
    }
    
    
    //MARK: - savePop
    func saveOkPop(){
        //저장얼럿띄우기
        let storyBoard = UIStoryboard.init(name: "UIPopup", bundle: nil)
        
        let popupVC = storyBoard.instantiateViewController(identifier: "UIPopup")
        //투명도가 있으면 투명도에 맞춰서 나오게 해주는 코드(뒤에있는 배경이 보일 수 있게)
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: false, completion: nil)
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
    
    // MARK: - 문답서버호출 등록API호출
    func upLoadQnA() {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        let url = "https://dev.joeywrite.shop/app/posts"
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Accept" : "application/json",
            "X-ACCESS-TOKEN" : token
        ]
        
        if ftID == "" || ftID == nil {
            ftID = "d"
        }

        
        let jsonData: [String: Any] = [
            "filterId": ftID,
            "qnaQuestionId": ftqID,
            "contents": contentsText,
            "qnaBackgroundColor": BGcolor ,//배경컬러,체크여부추가하기
            "feedShare" : shareValue
            
        ] as Dictionary
        
        
        // 딕셔너리를 string으로 저장
        var jsonObj : String = ""
        do {
            let jsonCreate = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            
            // json데이터를 변수에 삽입
            jsonObj = String(data: jsonCreate, encoding: .utf8) ?? ""
            print("⭐️만든문답제이순 jsonObj : " , jsonObj)
        } catch {
            print(error.localizedDescription)
        }
        
        
        // post에 담긴 제이슨
        let alamo = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("\(jsonObj)".data(using:.utf8)!, withName: "posts", mimeType: "application/json")
            
        }, to: url, method: .post, headers: header)
            .validate(contentType: ["application/json"])
        
        alamo.response { response in
            
            switch response.result {
            case .success(let value):
                do {
                    
                    let jsonDecoder = JSONDecoder()
                    let parsedData = try jsonDecoder.decode(FeedUploadModel.self, from: value!)
                    print( "⭐️문답업로드응답:= : \(parsedData)!")
                    
                    //저장완료팝업(밑에뷰다끄기안에있음)
                    self.saveOkPop()
                    
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let value):
                print("failure: \(value)")
            }
        }
    }
    
    
}


extension QnAdetailVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    // 셀 높이 컨텐츠에 맞게 자동으로 설정// 컨텐츠의 내용높이 만큼이다.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qnaDetailCell", for: indexPath) as! qnaDetailCell
        
        cell.title.text = Qword // 문답내용
        
        // 태그이미지
        if self.ftID == "d"{
            cell.tagImg.image = UIImage(named: "EndTag")//마무리
            cell.QsImg.image = UIImage(named: "TopicEnd")
        }else if(self.ftID == "b"){
            cell.tagImg.image = UIImage(named: "BucketTag")//버킷
            cell.QsImg.image = UIImage(named: "TopicBucket")
        }else if(self.ftID == "r"){
            cell.tagImg.image = UIImage(named: "RelationshipTag")//관계
            cell.QsImg.image = UIImage(named: "TopicRelationship")
        }else if(self.ftID == "f"){
            cell.tagImg.image = UIImage(named: "FamilyTag")//가족
            cell.QsImg.image = UIImage(named: "TopicFamily")
        }else if(self.ftID == "s"){
            cell.tagImg.image = UIImage(named: "secretTag")//비밀
            cell.QsImg.image = UIImage(named: "TopicSecret")
        }else if(self.ftID == "m"){
            cell.tagImg.image = UIImage(named: "MemoryTag")//기억
            cell.QsImg.image = UIImage(named: "TopicMemory")
        }else if(self.ftID == "i"){
            cell.tagImg.image = UIImage(named: "MyTag")//사용자가작성한질문
            cell.QsImg.image = UIImage(named: "TopicForMe")
        }
        return cell
    }
}

