//
//  tabFirstVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/31.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class tabFirstVC :UIViewController{
    
    var aQallModel: AQallModel?
    var timeOption = ""
    var ftimeOption = ""
    var qID = ""
    
    var getFilterId = ""
    var postID = 0
    // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
    let AlltagOn = UIImage(named:"Alltag")
    let AlltagOff = UIImage(named:"Alltag_d")
    let DailyOn = UIImage(named:"DailyTag")
    let DailyOff = UIImage(named:"DailyTag_d")
    let EndOn = UIImage(named: "EndTag")
    let EndOff = UIImage(named:"EndTag_d")
    let RealtionOn = UIImage(named:"RelationshipTag")
    let RealtionOff = UIImage(named:"RelationshipTag_d")
    let BucketOn = UIImage(named:"BucketTag")
    let BucketOff = UIImage(named:"BucketTag_d")
    let SecretOn = UIImage(named:"secretTag")
    let SecretOff = UIImage(named:"secretTag_d")
    let FamilyOn = UIImage(named:"FamilyTag")
    let FamilyOff = UIImage(named:"FamilyTag_d")
    let MemoryOn = UIImage(named:"MemoryTag")
    let MemoryOff = UIImage(named:"MemoryTag_d")
    let MyOn = UIImage(named:"MyTag")
    let MyOff = UIImage(named:"MyTag_d")

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tagStackView: UIView! //상단태그이미지
    @IBOutlet weak var Alltag: UIImageView!
    @IBOutlet weak var EndTag: UIImageView!
    @IBOutlet weak var RealtionTag: UIImageView!
    @IBOutlet weak var BucketTag: UIImageView!
    @IBOutlet weak var SecretTag: UIImageView!
    @IBOutlet weak var FamilyTag: UIImageView!
    @IBOutlet weak var MemoryTag: UIImageView!
    @IBOutlet weak var MyTag: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeBtn: UIImageView!
    private let timeOn = UIImage(named:"Property=Time")// 최신순(마지막작성글)
    private let timeOff = UIImage(named:"Property=Reverse")//시간순(작성한순서)
    let dismissQnaVC = Notification.Name("dismissQnaVC")

    override func viewDidLoad() {

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: "AnnotatedPhotoCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier:"AnnotatedPhotoCell")
        let nibName2 = UINib(nibName: "smallCell", bundle: nil)
        collectionView.register(nibName2, forCellWithReuseIdentifier:"smallCell")
        
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        // 핀터레스트레이이아웃
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        // 노티4.옵저버를 등록하고, 오면 writeVCNotification함수를 실행한다.
        NotificationCenter.default.addObserver(self, selector: #selector(self.qndUpdate(_:)), name: dismissQnaVC, object: nil)
        
        
        // MARK: - 시간순버튼
        let tapTimeBtn
        = UITapGestureRecognizer(target: self, action: #selector(timeAction(tapGestureRecognizer:)))
        timeBtn.addGestureRecognizer(tapTimeBtn)
        timeBtn.isUserInteractionEnabled = true

        //기본세팅
        self.timeBtn.image = UIImage(named:"Property=Time")// 최신순(마지막작성글)

        //시간순호출
        timeOption = "desc"
        getAllMain(option: timeOption)
        
        // MARK: - 태그세팅
        UISetting()
        
        // MARK: - 전체
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(btnAlltag(tapGestureRecognizer:)))
        self.Alltag.addGestureRecognizer(tapImageViewRecognizer)
        self.Alltag.isUserInteractionEnabled = true
        
        // MARK: - 마무리
        let tapImageEndTag
        = UITapGestureRecognizer(target: self, action: #selector(btnEndtag(tapGestureRecognizer:)))
        self.EndTag.addGestureRecognizer(tapImageEndTag)
        self.EndTag.isUserInteractionEnabled = true
        
        // MARK: - 관계
        let tapImageRtag
        = UITapGestureRecognizer(target: self, action: #selector(btnRealtiontag(tapGestureRecognizer:)))
        self.RealtionTag.addGestureRecognizer(tapImageRtag)
        self.RealtionTag.isUserInteractionEnabled = true
        
        // MARK: - 버킷리스트
        let tapImageBucketTag
        = UITapGestureRecognizer(target: self, action: #selector(btnBuckettag(tapGestureRecognizer:)))
        BucketTag.addGestureRecognizer(tapImageBucketTag)
        BucketTag.isUserInteractionEnabled = true
        
        // MARK: - 비밀
        let tapImageSecretTag
        = UITapGestureRecognizer(target: self, action: #selector(btnSecrettag(tapGestureRecognizer:)))
        self.SecretTag.addGestureRecognizer(tapImageSecretTag)
        self.SecretTag.isUserInteractionEnabled = true
        
        // MARK: - 가족
        let tapImageFamily
        = UITapGestureRecognizer(target: self, action: #selector(btnFamilytag(tapGestureRecognizer:)))
        FamilyTag.addGestureRecognizer(tapImageFamily)
        FamilyTag.isUserInteractionEnabled = true
        
        // MARK: - 기억
        let tapImageMemoryTag
        = UITapGestureRecognizer(target: self, action: #selector(btnMemorytag(tapGestureRecognizer:)))
        self.MemoryTag.addGestureRecognizer(tapImageMemoryTag)
        self.MemoryTag.isUserInteractionEnabled = true
        
        // MARK: - 자기
        let tapImageMyTag
        = UITapGestureRecognizer(target: self, action: #selector(btnMytag(tapGestureRecognizer:)))
        self.MyTag.addGestureRecognizer(tapImageMyTag)
        self.MyTag.isUserInteractionEnabled = true
        
        
    }//viewdid
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: dismissQnaVC, object: nil)
    }
    
    
    // MARK: -  서버에서 받은 헥스 스트링을 UI Color로 변환하는 함수
       func hexStringToUIColor(hex:String) -> UIColor {
               var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

               if (cString.hasPrefix("#")) {
                   cString.remove(at: cString.startIndex)
               }

               if ((cString.count) != 6) {
                   return UIColor.gray
               }

               var rgbValue:UInt64 = 0
               Scanner(string: cString).scanHexInt64(&rgbValue)

               return UIColor(
                   red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                   alpha: CGFloat(1.0)
               )
           }
    
    
    
    
    // MARK: - timeAction
    func request(){
        //시간순
        if self.timeBtn.image === self.timeOff {
            self.timeBtn.image = UIImage(named:"Property=Time")
            
            if self.Alltag.image === self.AlltagOn{
                // 전체시간순역순
                getAllMain(option:  "desc")
                
            }else if(self.EndTag.image === self.EndOn){
                
                getFeedCategory(filterID:"d", option: ftimeOption)
            }else if(self.RealtionTag.image === self.RealtionOn){
                
                getFeedCategory(filterID:"r", option: "desc")
            }else if(self.BucketTag.image === self.BucketOn){
                
                getFeedCategory(filterID:"b", option: "desc")
            }else if(self.SecretTag.image === self.SecretOn){
                
                getFeedCategory(filterID:"s", option: "desc")
            }else if(self.FamilyTag.image === self.FamilyOn){
                
                getFeedCategory(filterID:"f", option: "desc")
            }else if(self.MemoryTag.image === self.MemoryOn){
                
                getFeedCategory(filterID:"m", option: "desc")
            }else if(self.MyTag.image === self.MyOn){
                
                getFeedCategory(filterID:"i", option: "desc")
            }
            
            
            //역순
        }else{
            self.timeBtn.image = UIImage(named:"Property=Reverse")
            
            if self.Alltag.image === self.AlltagOn{
                getAllMain(option: "asc")
            }else if(self.EndTag.image === self.EndOn){
                
                getFeedCategory(filterID:"d", option:"asc")
            }else if(self.RealtionTag.image === self.RealtionOn){
                
                getFeedCategory(filterID:"r", option:"asc")
            }else if(self.BucketTag.image === self.BucketOn){
                
                getFeedCategory(filterID:"b", option:"asc")
            }else if(self.SecretTag.image === self.SecretOn){
                
                getFeedCategory(filterID:"s", option:"asc")
            }else if(self.FamilyTag.image === self.FamilyOn){
                
                getFeedCategory(filterID:"f", option: "asc")
            }else if(self.MemoryTag.image === self.MemoryOn){
                
                getFeedCategory(filterID:"m", option:"asc")
            }else if(self.MyTag.image === self.MyOn){
                
                getFeedCategory(filterID:"i", option:"asc")
            }
        }
    }
    
    
    // MARK: - timeAction
    @objc func timeAction(tapGestureRecognizer: UITapGestureRecognizer){
        request()
    }

    
    // MARK: - noti
    @objc func qndUpdate(_ noti: Notification) {
        
        print("firstTabVC: 업뎃노티피케이션 호출")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.request()
            self.collectionView.reloadData()
        }

    }
    
    // MARK: - 태그세팅
    func UISetting(){
        Alltag.image = UIImage(named:"Alltag")
//        DailyTag.image = UIImage(named:"DailyTag_d")
        EndTag.image = UIImage(named: "EndTag_d")
        RealtionTag.image =  UIImage(named: "RelationshipTag_d")
        BucketTag.image = UIImage(named: "BucketTag_d")
        SecretTag.image = UIImage(named: "secretTag_d")
        FamilyTag.image = UIImage(named: "FamilyTag_d")
        MemoryTag.image = UIImage(named: "MemoryTag_d")
        MyTag.image = UIImage(named: "MyTag_d")
    }
    


    @objc func btnAlltag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기

            if self.Alltag.image === self.AlltagOff{
                self.Alltag.image = UIImage(named:"Alltag")//on
//                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named: "BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //피드전체호출
                getAllMain(option :"desc")
                
            }else{
                self.Alltag.image = UIImage(named:"Alltag_d")
                print("AlltagOff")
            }

    }

    
    @objc func btnEndtag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.EndTag.image === self.EndOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
//                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag")//on
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named: "BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출 마무리
                getFeedCategory(filterID:"d", option: "desc")
                
            }else{
                self.EndTag.image = UIImage(named:"EndTag_d")
                print("EndTagTagOff")
            }
    }
    
    @objc func btnRealtiontag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.RealtionTag.image === self.RealtionOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
//                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag")//on
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.BucketTag.image = UIImage(named: "BucketTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"r", option: "desc")
                
            }else{
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                
            }

    }
    
    @objc func btnBuckettag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.BucketTag.image === self.BucketOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
//                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag")//on
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"b", option: "desc")
                
            }else{
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                
            }

    }
    
    @objc func btnSecrettag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기

            if self.SecretTag.image === self.SecretOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
//                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag")//on
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"s", option: "desc")
                
            }else{
                self.SecretTag.image = UIImage(named:"secretTag_d")
            }
    }
    
    @objc func btnFamilytag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.FamilyTag.image === self.FamilyOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
//                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag")//on
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"f", option: "desc")
                
            }else{
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
            }
    }
    
    @objc func btnMemorytag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.MemoryTag.image === self.MemoryOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
//                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag")//on
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"m", option: "desc")
                
            }else{
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                
            }
    }
    
    @objc func btnMytag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
  
            if self.MyTag.image === self.MyOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
//                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag")//on
                //서버호출
                getFeedCategory(filterID:"i", option: "desc")
                
            }else{
                self.MyTag.image = UIImage(named:"MyTag_d")
                
            }
    }
    
    // MARK: - 아카이브문답전체호출 시간순역순
    func getAllMain(option :String) {
        
        let time = option
        let url = "https://dev.joeywrite.shop/app/archives/qnas?chronological=\(time)"
        var token = UserDefaults.standard.value(forKey:"token") as! String
        
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
                
                print("내스크랩서버호출")
                do{
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용
                    
                    self.aQallModel = try JSONDecoder().decode(AQallModel.self, from: dataJSON)
                    print("⭐️feedMainModel:\(  self.aQallModel)")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.collectionView.reloadData()
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
    
    
    // MARK: - 아카이브문답필터호출
    func getFeedCategory(filterID: String, option:String) {
        
        let fID = filterID
        let opt = option
        let url = "https://dev.joeywrite.shop/app/archives/qnas?filter-id=\(fID)&chronological=\(opt)"
        var token = UserDefaults.standard.value(forKey:"token") as! String
        
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
                
                print("아카이브문답전체서버호출")
                do{
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용
                    
                    self.aQallModel = try JSONDecoder().decode(AQallModel.self, from: dataJSON)
                    print("⭐️필터aqModel:\(self.aQallModel)")
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
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

extension tabFirstVC :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.aQallModel?.result?.count ?? 0
        //        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name:"FeedDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDetailVC") as! FeedDetailVC
        
        vc.modalPresentationStyle = .popover
        vc.FeedNum = self.aQallModel?.result?[indexPath.item].postID
        
        self.present(vc, animated: true){ }
        
    }
    
    
    
    //셀표기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        getFilterId = self.aQallModel?.result?[indexPath.item].filterID ?? "d"
        
        //큰셀
        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3 ) {
            
            //문답(큰셀)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
            if let aCell = cell as? AnnotatedPhotoCell {
                // 제목
                aCell.captionLabel.text = self.aQallModel?.result?[indexPath.item].qnaQuestion
                // 배경color
                 let getColor = self.aQallModel?.result?[indexPath.item].qnaBackgroundColor
                 aCell.bgView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
                 
                 self.qID = self.aQallModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                 var imgInsert = self.aQallModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                 aCell.imageView.image = UIImage(named: imgInsert)
          
                 return cell
            }
            
       
            //작은쎌
        } else {
            //문답셀(작은쏄)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCell", for: indexPath)
            
            if let smallCell = cell as? smallCell {

                smallCell.captionLabel.text = self.aQallModel?.result?[indexPath.item].qnaQuestion

                let getColor = self.aQallModel?.result?[indexPath.item].qnaBackgroundColor
                smallCell.containerView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
                
                self.qID = self.aQallModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                let imgInsert = self.aQallModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                smallCell.imageView.image = UIImage(named: imgInsert)
      
            }
            return cell
            
        }
        return UICollectionViewCell()
    }
    
}





//MARK: - PINTEREST LAYOUT DELEGATE
extension tabFirstVC : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        //    return photos[indexPath.item].image.size.height 안됨
        // 셀사이즈랜덤?
        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
            return 310
        }else{
            return 180
        }
    }
}

