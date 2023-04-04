//
//  FeedVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/06.
//

import Foundation
import UIKit
import AVFoundation
import Alamofire

class FeedVC: UIViewController{
    
    var feedMainModel:FeedMainModel?
    var feedResult: [FeedMainModelResult]?

    var getFilterId = ""
    var postID = 0
    var qID = ""
    // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
    let AlltagOn = UIImage(named:"Alltag")
    let AlltagOff = UIImage(named:"Alltag_d")
    let DailyOn = UIImage(named:"DailyTag_on")
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
    @IBOutlet weak var collectionView: UICollectionView! //피드콜렉션
    @IBOutlet weak var Alltag: UIImageView!
    @IBOutlet weak var DailyTag: UIImageView!
    @IBOutlet weak var EndTag: UIImageView!
    @IBOutlet weak var RealtionTag: UIImageView!
    @IBOutlet weak var BucketTag: UIImageView!
    @IBOutlet weak var SecretTag: UIImageView!
    @IBOutlet weak var FamilyTag: UIImageView!
    @IBOutlet weak var MemoryTag: UIImageView!
    @IBOutlet weak var MyTag: UIImageView!
    

    
    // MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        let nibName = UINib(nibName: "AnnotatedPhotoCell", bundle: nil)
        collectionView?.register(nibName, forCellWithReuseIdentifier:"AnnotatedPhotoCell")
        let nibName2 = UINib(nibName: "smallCell", bundle: nil)
        collectionView?.register(nibName2, forCellWithReuseIdentifier:"smallCell")
        let nibName3 = UINib(nibName: "DailySmallCell", bundle: nil)
        collectionView?.register(nibName3, forCellWithReuseIdentifier:"DailySmallCell")
        let nibName4 = UINib(nibName: "DailyBigCell", bundle: nil)
        collectionView?.register(nibName4, forCellWithReuseIdentifier:"DailyBigCell")
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        // 핀터레스트레이이아웃
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        //서버호출
        getFeedMain()
        
        
        // MARK: - 태그세팅
        UISetting()
        
        // MARK: - 전체
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(btnAlltag(tapGestureRecognizer:)))
        self.Alltag.addGestureRecognizer(tapImageViewRecognizer)
        self.Alltag.isUserInteractionEnabled = true
        
        // MARK: - 일상
        let tapImageDaily
        = UITapGestureRecognizer(target: self, action: #selector(btnDailytag(tapGestureRecognizer:)))
        self.DailyTag.addGestureRecognizer(tapImageDaily)
        self.DailyTag.isUserInteractionEnabled = true
        
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
        
    }//viewdidload
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.Alltag.image == self.AlltagOn{
            getFeedMain()
        }else if(self.DailyTag.image === self.DailyOn){
            getFeedCategory(filterID:"e")
        }else if(self.EndTag.image === self.EndOn){
            getFeedCategory(filterID:"d")
        }else if(self.RealtionTag.image === self.RealtionOn){
            getFeedCategory(filterID:"r")
        }else if(self.BucketTag.image === self.BucketOn){
            getFeedCategory(filterID:"b")
        }else if(self.SecretTag.image === self.SecretOn){
            getFeedCategory(filterID:"s")
        }else if(self.FamilyTag.image === self.FamilyOn){
            getFeedCategory(filterID:"f")
        }else if(self.MemoryTag.image === self.MemoryOn){
            getFeedCategory(filterID:"m")
        }else if(self.MyTag.image === self.MyOn){
            getFeedCategory(filterID:"i")
        }
    }
    
    // MARK: - 태그클릭
    @objc func btnAlltag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.Alltag.image === self.AlltagOff{
                self.Alltag.image = UIImage(named:"Alltag")//on
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named: "BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //피드전체호출
                getFeedMain()
                
            }else{
                self.Alltag.image = UIImage(named:"Alltag_d")
                print("AlltagOff")
            }
    }
    
    @objc func btnDailytag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.DailyTag.image === self.DailyOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
                self.DailyTag.image = UIImage(named:"DailyTag_on")//on
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named: "BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출 일상
                getFeedCategory(filterID:"e")
                
            }else{
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                
            }

    }
    
    @objc func btnEndtag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.EndTag.image === self.EndOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag")//on
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named: "BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출 마무리
                getFeedCategory(filterID:"d")
                
            }else{
                self.EndTag.image = UIImage(named:"EndTag_d")
                print("EndTagTagOff")
            }
    }
    
    @objc func btnRealtiontag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.RealtionTag.image === self.RealtionOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag")//on
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.BucketTag.image = UIImage(named: "BucketTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"r")
                
            }else{
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                
            }

    }
    
    @objc func btnBuckettag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.BucketTag.image === self.BucketOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag")//on
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"b")
                
            }else{
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                
            }

    }
    
    @objc func btnSecrettag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기

            if self.SecretTag.image === self.SecretOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag")//on
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"s")
                
            }else{
                self.SecretTag.image = UIImage(named:"secretTag_d")
            }
    }
    
    @objc func btnFamilytag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.FamilyTag.image === self.FamilyOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag")//on
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"f")
                
            }else{
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
            }
    }
    
    @objc func btnMemorytag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
            if self.MemoryTag.image === self.MemoryOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag")//on
                self.MyTag.image = UIImage(named:"MyTag_d")
                //서버호출
                getFeedCategory(filterID:"m")
                
            }else{
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                
            }
    }
    
    @objc func btnMytag(tapGestureRecognizer: UITapGestureRecognizer){
        // all,일상, 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
  
            if self.MyTag.image === self.MyOff{
                self.Alltag.image = UIImage(named:"Alltag_d")
                self.DailyTag.image = UIImage(named:"DailyTag_d")
                self.EndTag.image = UIImage(named:"EndTag_d")
                self.RealtionTag.image = UIImage(named:"RelationshipTag_d")
                self.BucketTag.image = UIImage(named:"BucketTag_d")
                self.SecretTag.image = UIImage(named:"secretTag_d")
                self.FamilyTag.image = UIImage(named:"FamilyTag_d")
                self.MemoryTag.image = UIImage(named:"MemoryTag_d")
                self.MyTag.image = UIImage(named:"MyTag")//on
                //서버호출
                getFeedCategory(filterID:"i")
                
            }else{
                self.MyTag.image = UIImage(named:"MyTag_d")
                
            }
    }
    
    // MARK: - 태그세팅
    func UISetting(){
        Alltag.image = UIImage(named:"Alltag")
        DailyTag.image = UIImage(named:"DailyTag_d")
        EndTag.image = UIImage(named: "EndTag_d")
        RealtionTag.image =  UIImage(named: "RelationshipTag_d")
        BucketTag.image = UIImage(named: "BucketTag_d")
        SecretTag.image = UIImage(named: "secretTag_d")
        FamilyTag.image = UIImage(named: "FamilyTag_d")
        MemoryTag.image = UIImage(named: "MemoryTag_d")
        MyTag.image = UIImage(named: "MyTag_d")
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
    
    
    
    // MARK: - 피드서버호출(기본)
    func getFeedMain() {
        let url = "https://dev.joeywrite.shop/app/feeds"
        
        //LCId=&MCId=&SCId=
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
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용
                    
                    self.feedMainModel = try JSONDecoder().decode(FeedMainModel.self, from: dataJSON)
                    print("⭐️feedMainModel:\(  self.feedMainModel)")
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
    
    func getFeedCategory(filterID:String) {
        
        let getPostNum = filterID
        let url = "https://dev.joeywrite.shop/app/feeds?filter-id=\(getPostNum)"

        print(url)
        
        //LCId=&MCId=&SCId=
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
                
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.feedMainModel = try JSONDecoder().decode(FeedMainModel.self, from: dataJSON)
                    print("⭐️feedMainModel:\(  self.feedMainModel)")
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

extension FeedVC :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedMainModel?.result?.count ?? 0
        //        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        getFilterId = self.feedMainModel?.result?[indexPath.item].filterID ?? "d"
        
        if getFilterId == "e"{
            let vc = UIStoryboard(name:"FeedDailyDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDailyDetailVC") as! FeedDailyDetailVC
            
            vc.modalPresentationStyle = .fullScreen
            vc.FeedNum = self.feedMainModel?.result?[indexPath.item].postID
            self.present(vc, animated: true){ }
            
        }else{

            let vc = UIStoryboard(name:"FeedDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDetailVC") as! FeedDetailVC
            vc.modalPresentationStyle = .fullScreen
            vc.FeedNum = self.feedMainModel?.result?[indexPath.item].postID
            self.present(vc, animated: true){ }
        }
    }
    
    
    //셀표기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        getFilterId = self.feedMainModel?.result?[indexPath.item].filterID ?? "d"
        
        //큰셀
        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3 ) {
            
            //문답(큰셀)
            if getFilterId != "e"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
                if let annotateCell = cell as? AnnotatedPhotoCell {
                    // 제목
                    annotateCell.captionLabel.text = self.feedMainModel?.result?[indexPath.item].qnaQuestion
                    
                    // 배경color
                    let getColor = self.feedMainModel?.result?[indexPath.item].qnaBackgroundColor
                    annotateCell.bgView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
            
                    self.qID = self.feedMainModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                    let imgInsert = self.feedMainModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                    annotateCell.imageView.image = UIImage(named: imgInsert)
                }
                return cell
                //일상(큰셀)
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyBigCell", for: indexPath)
                if let DailyBigCell = cell as? DailyBigCell {
                    // 제목
                    DailyBigCell.cationLabel.text = self.feedMainModel?.result?[indexPath.item].dailyTitle
                    
                    // 이미지
                    if ((feedMainModel?.result?[indexPath.item].dailyImage) != nil) {
                        let imgInfo  = feedMainModel?.result?[indexPath.item].dailyImage
                        if imgInfo != nil {
                            
                            // 킹피셔를 사용한 이미지 처리방법
                            if let imageURL =  feedMainModel?.result?[indexPath.item].dailyImage {
                                // 이미지처리방법
                                guard let url = URL(string: imageURL) else {
                                    //리턴할 셀지정하기
                                    return cell
                                }
                                // 이미지를 다운받는동안 인디케이터보여주기
                                DailyBigCell.dImageView.kf.indicatorType = .activity
                                //            print("이미지url \(url)")
                                DailyBigCell.dImageView.kf.setImage(
                                    with: url,
                                    placeholder: UIImage(named: "ex"),
                                    options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                                    ])
                                {
                                    result in
                                    switch result {
                                    case .success(_):
                                        print("")
                                    case .failure(let err):
                                        print(err.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                return cell
            }
            
            
            //작은쎌
        } else {
            //문답셀(작은쏄)
            if getFilterId != "e"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCell", for: indexPath)
                
                if let smallCell = cell as? smallCell {
                    // 제목
                    smallCell.captionLabel.text = self.feedMainModel?.result?[indexPath.item].qnaQuestion
                    // 배경color
                    let getColor = self.feedMainModel?.result?[indexPath.item].qnaBackgroundColor
                    smallCell.containerView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
                    //이미지
                    getFilterId = self.feedMainModel?.result?[indexPath.item].filterID ?? "e"
                    self.qID = self.feedMainModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                    let imgInsert = self.feedMainModel?.result?[indexPath.item].qnaQuestionID ?? "d-1"
                    smallCell.imageView.image = UIImage(named: imgInsert)
                }
                return cell
                
                //일상셀(작은쏄)
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailySmallCell", for: indexPath)
                
                if let smallCell = cell as? DailySmallCell {
                    // 제목
                    smallCell.captionLabel.text = self.feedMainModel?.result?[indexPath.item].dailyTitle ?? "No title"
                    
                    // 이미지
                    if ((feedMainModel?.result?[indexPath.item].dailyImage) != nil) {
                        let imgInfo  = feedMainModel?.result?[indexPath.item].dailyImage
                        if imgInfo != nil {
                            
                            // 킹피셔를 사용한 이미지 처리방법
                            if let imageURL =  feedMainModel?.result?[indexPath.item].dailyImage {
                                // 이미지처리방법
                                guard let url = URL(string: imageURL) else {
                                    //리턴할 셀지정하기
                                    return cell
                                }
                                // 이미지를 다운받는동안 인디케이터보여주기
                                smallCell.dImageView.kf.indicatorType = .activity
                                //            print("이미지url \(url)")
                                smallCell.dImageView.kf.setImage(
                                    with: url,
                                    placeholder: UIImage(named: "ex"),
                                    options: [
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                                    ])
                                {
                                    result in
                                    switch result {
                                    case .success(_):
                                        print("")
                                    case .failure(let err):
                                        print(err.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                return cell
            }
        }
    }
}




//MARK: - PINTEREST LAYOUT DELEGATE
extension FeedVC : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        //  return photos[indexPath.item].image.size.height
        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
            return 310
        }else{
            return 180
        }
    }
}

