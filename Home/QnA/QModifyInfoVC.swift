//
//  QModifyInfoVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/12.
//

import Foundation
import UIKit
import Alamofire

// 수정후 다시 서버호출하는 뷰컨
class QModifyInfoVC :UIViewController {
    
    var feedModifyModel : FeedModifyModel?
    var FeedNum = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shareArea: UIView!//체크박스클릭영역
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var dateString: UILabel!
    private let checkOn = UIImage(named:"p_check_on")
    private let checkOff = UIImage(named:"p_check_off")
    var Qtext = ""
    var QdecText = [String]()
    //배열받아오기QfirstVC에서
    var QnAPackage = [String]()
    var shareValue = ""
    //    var bgColor2 = UIColor()
    
    @IBOutlet weak var QsaveBtn: UIButton!
    @IBAction func QsaveBtn(_ sender: Any) {
        
        // Qmodify에서 받아온 게시글번호
        // 저장서버호출
        ModifyQnA(getNum: FeedNum)
        
        // 저장완료팝업(밑에뷰다끄기안에있음)
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
        //QfirstVC에서 가져온값 넣기
        print("⭐️QnAdetailVC-----QnAPackage:\(QnAPackage)")
        //날짜
        date()
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
    
    // MARK: - saveBTn 등록API호출
    func ModifyQnA(getNum :Int) {
        
        var token = UserDefaults.standard.value(forKey:"token") as! String
        let url = "https://dev.joeywrite.shop/app/posts/update/\(getNum)"
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Accept" : "application/json",
            "X-ACCESS-TOKEN" : token
        ]
        //QfirstVC에서 가져온값 넣기
        print("⭐️QnAdetailVC-----QnAPackage:\(QnAPackage)")
        
        if QnAPackage[4] == "" && QnAPackage[4].isEmpty {
            QnAPackage[4] = "#7E73FF" // 메인색보라
        }
        
        let jsonData: [String: Any] = [
            "filterId": QnAPackage[0],// 1은 화면에 표시만
            "qnaQuestionId":QnAPackage[2],
            "contents": QnAPackage[3],
            "qnaBackgroundColor": QnAPackage[4],//배경컬러,체크여부추가하기
            "feedShare" : shareValue
            
        ] as Dictionary
        
        
        // 딕셔너리를 string으로 저장
        var jsonObj : String = ""
        do {
            let jsonCreate = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            
            // json데이터를 변수에 삽입
            jsonObj = String(data: jsonCreate, encoding: .utf8) ?? ""
            print("⭐️만든문답수정제이순 jsonObj :" , jsonObj)
        } catch {
            print(error.localizedDescription)
        }
        
        // post에 담긴 제이슨
        let alamo = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("\(jsonObj)".data(using:.utf8)!, withName: "posts", mimeType: "application/json")
            
        }, to: url,method: .put, headers: header)
            .validate(contentType: ["application/json"])
        
        alamo.response { response in
            
            switch response.result {
            case .success(let value):
                do {
                    
                    let jsonDecoder = JSONDecoder()
                    let parsedData = try jsonDecoder.decode(FeedUploadModel.self, from: value!)
                    print( "⭐️문답수정응답:= : \(parsedData)!")
                    
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


extension QModifyInfoVC: UITableViewDelegate,UITableViewDataSource {
    
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
        
        cell.title.text = QnAPackage[1]// 문답내용
        
        // 태그이미지
        if self.QnAPackage[0] == "d"{
            cell.tagImg.image = UIImage(named: "EndTag")//마무리
            cell.QsImg.image = UIImage(named: "TopicEnd")
        }else if(self.QnAPackage[0] == "b"){
            cell.tagImg.image = UIImage(named: "BucketTag")//버킷
            cell.QsImg.image = UIImage(named: "TopicBucket")
        }else if(self.QnAPackage[0] == "r"){
            cell.tagImg.image = UIImage(named: "RelationshipTag")//관계
            cell.QsImg.image = UIImage(named: "TopicRelationship")
        }else if(self.QnAPackage[0] == "f"){
            cell.tagImg.image = UIImage(named: "FamilyTag")//가족
            cell.QsImg.image = UIImage(named: "TopicFamily")
        }else if(self.QnAPackage[0] == "s"){
            cell.tagImg.image = UIImage(named: "secretTag")//비밀
            cell.QsImg.image = UIImage(named: "TopicSecret")
        }else if(self.QnAPackage[0] == "m"){
            cell.tagImg.image = UIImage(named: "MemoryTag")//기억
            cell.QsImg.image = UIImage(named: "TopicMemory")
        }else if(self.QnAPackage[0] == "i"){
            cell.tagImg.image = UIImage(named: "MyTag")//사용자가작성한질문
            cell.QsImg.image = UIImage(named: "TopicForMe")
        }
        return cell
    }
}

