//
//  HomeVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/06.
//

import Foundation
import UIKit
import Alamofire

class HomeVC : UIViewController{
    
    var qmodel : Qmodel?
    var qresult: QResult?
    
    var topic = Topic()
    private let qnAImg = UIImage(named:"BtnWrite")
    private let routineImg = UIImage(named:"BtnWriteR")
    var dateString = ""
    var qnaword = [String]()//질문저장
    var categoryID = ""
    var qID = ""
    var FTID = ""
    
    @IBOutlet weak var todayDate: UILabel!//오늘날짜
    @IBOutlet weak var topicBox: UIView!//문항박스
    @IBOutlet weak var qtitle: UITextView! //문항타이틀
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var qImg: UIImageView! //이미지썸네일
    @IBOutlet weak var tagSImg: UIImageView! //태그이미지
    @IBOutlet weak var leftQna: UILabel!//문항남은갯수
    @IBOutlet weak var qBtnToggle: UIImageView!//문답토글이미지
    @IBOutlet weak var btnWrite: UIButton!//기록버튼
    @IBOutlet weak var togleView: UIView!//문답일상버튼
    @IBOutlet weak var qcountViewArea: UIStackView!
    @IBOutlet weak var dText: UILabel!
    @IBOutlet weak var mImg: UIImageView!
    
    
    @IBAction func scrap(_ sender: Any) {
        // 스크랩페이지
        let vc = UIStoryboard(name:"ScrapVC" , bundle: nil).instantiateViewController(withIdentifier: "ScrapVC") as! ScrapVC
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true){ }
    }
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier:"HomeCollectionViewCell")
        // UI
        UISetting()
        date()
        
        //홈초기화면 마무리내용호출
        getTest("d")
        
        //토글액션
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleAction))
        togleView.addGestureRecognizer(tapGestureRecognizer)
        
        //날짜
        self.todayDate.text = dateString
        self.qcountViewArea.isHidden = false
    }
    
    // MARK: - 날짜
    func date(){
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 (E)"
        dateString = dateFormatter.string(from: today as Date)
        print(dateString)
    }
    
    // MARK: -  기본세팅
    func UISetting(){
        //토픽아웃라인
        topicBox.outLineBlueRound()
        // 컬렉션뷰
        collectionView.bgColorGray()
        //버튼라운드
        btnWrite.layer.cornerRadius = 12
        // 토글이미지
        self.qBtnToggle.image = UIImage(named:"BtnWrite")
        // 일상텍스트,이미지 히든
        self.dText.isHidden = true
        self.mImg.isHidden = true
        //문답이미지
        self.qImg.image = UIImage(named:"TopicEnd")
    }
    
    
    // MARK: -  문답일상선택
    @objc func toggleAction(sender: UITapGestureRecognizer) {
        toggleImage()
    }
    
    func toggleImage() {
        DispatchQueue.main.async {
            if self.qBtnToggle.image === self.qnAImg {
                // 일상
                self.qBtnToggle.image = UIImage(named:"BtnWriteR")
                self.topicBox.isHidden = true
                self.collectionView.isHidden = true
                self.qcountViewArea.isHidden = true
                self.qImg.isHidden = true
                self.mImg.image = UIImage(named:"DailyBig")
                self.mImg.isHidden = false
                self.dText.text = "문답이 아닌 나의 일상을 자유롭게 기록해요."
                self.dText.isHidden = false
            }else{
                // 문답
                self.qBtnToggle.image = UIImage(named:"BtnWrite")
                self.topicBox.isHidden = false
                self.collectionView.isHidden = false
                self.qcountViewArea.isHidden = false
                self.qImg.image = UIImage(named:"TopicEnd")
                self.qImg.isHidden = false
                self.mImg.isHidden = true
                self.dText.isHidden = true
            }
        }
    }
    
    
    // 토글버튼액션
    @IBAction func btnWriteAction(_ sender: Any) {
        
        if self.qBtnToggle.image == UIImage(named:"BtnWrite") {
            let vc = UIStoryboard(name:"QfirstVC" , bundle: nil).instantiateViewController(withIdentifier: "QfirstVC") as! QfirstVC
            
            vc.qnaword = self.qmodel?.result?.contents ?? "사용자가 작성하지않은 질문을 가져오는데에 실패하였습니다."
            //필터아이디는 문답만있음
            vc.ftID = categoryID ?? "d"
            vc.ftqID = qID
            vc.FTID = categoryID
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true){ }
            
        }else{
            let vc = UIStoryboard(name:"DailyVC" , bundle: nil).instantiateViewController(withIdentifier: "DailyVC") as! DailyVC
            
            vc.qnaword = self.qmodel?.result?.contents ?? "사용자가 작성하지않은 질문을 가져오는데에 실패하였습니다."
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true){ }
        }
    }
    
    //MARK: - 문답가져오기
    func getTest(_ filterID: String) {
        
        let getID = filterID
        
        let url = "https://dev.joeywrite.shop/app/questions/\(getID)"
        let token = UserDefaults.standard.value(forKey:"token") as! String //로그인시에만 생성됨
        //        var token2 = UserDefaults.standard.value(forKey:"token") as? String //로그인시에만 생성됨(이걸로하면안됨)
        print(token)
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
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
                
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.qmodel = try JSONDecoder().decode(Qmodel.self, from: dataJSON)
                    
                    print("⭐️HomeVC -서버응답 -qmodel:\(self.qmodel)")
                    
                    self.qtitle.text = self.qmodel?.result?.contents ?? "사용자가 작성하지않은 질문을 가져오는데에 실패하였습니다."
                    self.leftQna.text = self.qmodel?.result?.remaningNumberOfFilter?.description ?? "0"
                    self.qID = self.qmodel?.result?.qnaQuestionID ?? "문답아이디를 가져오지못했습니다."
                    var imgInsert = self.qmodel?.result?.qnaQuestionID?.description ?? "d-1"
                    self.qImg.image = UIImage(named: imgInsert)
                    
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


// MARK: - extension
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topic.TopicImageOff.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //카테고리별 호출
        self.categoryID = self.topic.categoryID[indexPath.row]
        self.getTest(self.categoryID)
        self.topicBox.layer.backgroundColor = self.topic.boxColor[indexPath.row]
        self.topicBox.layer.borderColor = self.topic.boxBorder[indexPath.row]
        self.tagSImg.image = self.topic.sTagImg[indexPath.row]
        self.leftQna.text = "0"
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        cell.index = indexPath.row
        cell.delegate = self
        
        cell.imgView.image = self.topic.TopicImageOff[indexPath.row]
        
        return cell
    }
}




extension HomeVC: HomeCellDelegate{
    func selectBtn(Index: Int) {
    }
}
