//
//  tabSecondVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/31.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher


class tabSecondVC :UIViewController{
    
    var aCDailyModel:ACDailyModel?
    var getFilterId = ""
    var postID = 0
    
    @IBOutlet weak var timeBtn: UIImageView!
    private let timeOn = UIImage(named:"Property=Time")// 최신순(마지막작성글)
    private let timeOff = UIImage(named:"Property=Reverse")// 시간순
    @IBOutlet weak var collectionView: UICollectionView!
    let dissmissDailyVC = Notification.Name("dissmissDailyVC")
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: "AnnotatedPhotoCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier:"AnnotatedPhotoCell")
        let nibName2 = UINib(nibName: "smallCell", bundle: nil)
        collectionView.register(nibName2, forCellWithReuseIdentifier:"smallCell")
        let nibName3 = UINib(nibName: "DailySmallCell", bundle: nil)
        collectionView.register(nibName3, forCellWithReuseIdentifier:"DailySmallCell")
        let nibName4 = UINib(nibName: "DailyBigCell", bundle: nil)
        collectionView.register(nibName4, forCellWithReuseIdentifier:"DailyBigCell")
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        // 핀터레스트레이이아웃
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        let tapTimeBtn
        = UITapGestureRecognizer(target: self, action: #selector(timeAction(tapGestureRecognizer:)))
        timeBtn.addGestureRecognizer(tapTimeBtn)
        timeBtn.isUserInteractionEnabled = true
        
        //기본세팅
        self.timeBtn.image = UIImage(named:"Property=Time")//최신순(마지막작성글)
        //일상호출(최신순)
        getFeedMain(fillter: "desc")
        //noti
        NotificationCenter.default.addObserver(self, selector: #selector(self.dailyVCupdate(_:)), name: dissmissDailyVC, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: dissmissDailyVC, object: nil)
    }
    
    
    // MARK: - timeAction
    @objc func timeAction(tapGestureRecognizer: UITapGestureRecognizer){
        
        if self.timeBtn.image === self.timeOff {
            self.timeBtn.image = UIImage(named:"Property=Time")
            getFeedMain(fillter: "desc")
            
        }else{
            self.timeBtn.image = UIImage(named:"Property=Reverse")// 최신순(마지막작성글)
            getFeedMain(fillter: "asc")
            
        }
    }
    
    // MARK: - noti
    @objc func dailyVCupdate(_ noti: Notification) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            print("secondTabVC: 업뎃노티피케이션 호출")
            
            if self.timeBtn.image === self.timeOff {
                self.timeBtn.image = UIImage(named:"Property=Time")// 최신순(마지막작성글)
                self.getFeedMain(fillter: "desc")
                
            }else{
                self.timeBtn.image = UIImage(named:"Property=Reverse")// 시간순
                self.getFeedMain(fillter: "asc")
            }
        }
    }
    
    // MARK: - 피드서버호출(기본)
    func getFeedMain(fillter:String) {
        
        let url = "https://dev.joeywrite.shop/app/archives/daily?chronological=\(fillter)"
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
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
                    self.aCDailyModel = try JSONDecoder().decode(ACDailyModel.self, from: dataJSON)
                    print("⭐️aCDailyModel:\(  self.aCDailyModel)")
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

extension tabSecondVC :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //        return 100
        return self.aCDailyModel?.result?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 문답피드상세페이지띄우기
        let vc = UIStoryboard(name:"FeedDailyDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDailyDetailVC") as! FeedDailyDetailVC
        //            vc.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .popover // 화면다안가리면 괜찮음..생명주기문제
        vc.FeedNum = self.aCDailyModel?.result?[indexPath.item].postID
        
        self.present(vc, animated: true){ }
    }
    
    
    //셀표기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //큰셀
        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3 ) {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyBigCell", for: indexPath)
            if let DailyBigCell = cell as? DailyBigCell {
                // 제목
                DailyBigCell.cationLabel.text = self.aCDailyModel?.result?[indexPath.item].dailyTitle
                
                // 이미지
                if ((aCDailyModel?.result?[indexPath.item].dailyImage) != nil) {
                    let imgInfo  = aCDailyModel?.result?[indexPath.item].dailyImage
                    if imgInfo != nil {
                        
                        // 킹피셔를 사용한 이미지 처리방법
                        if let imageURL = aCDailyModel?.result?[indexPath.item].dailyImage {
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
            //일상셀(작은쏄)
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailySmallCell", for: indexPath)
            
            if let smallCell = cell as? DailySmallCell {
                // 제목
                smallCell.captionLabel.text = self.aCDailyModel?.result?[indexPath.item].dailyTitle ?? "No title"
                
                // 이미지
                if ((aCDailyModel?.result?[indexPath.item].dailyImage) != nil) {
                    let imgInfo  = aCDailyModel?.result?[indexPath.item].dailyImage
                    if imgInfo != nil {
                        
                        // 킹피셔를 사용한 이미지 처리방법
                        if let imageURL = aCDailyModel?.result?[indexPath.item].dailyImage {
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
}//end




//MARK: - PINTEREST LAYOUT DELEGATE
extension tabSecondVC : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        //    return photos[indexPath.item].image.size.height
        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
            return 310
        }else{
            return 180
        }
    }
}



