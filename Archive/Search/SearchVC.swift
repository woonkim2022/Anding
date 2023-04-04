//
//  SearchVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/01.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class SearchVC :UIViewController, UITextFieldDelegate{

    var feedMainModel:FeedMainModel?
    //피드 모델에 값이 있으면 가져온다.
    var feedResult: [FeedMainModelResult]?
    var getFilterId = ""
    var postID = 0
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldBox: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var closeBtn: UIButton!
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - viewdidload
    override func viewDidLoad() {
        textFieldBox.cournerRound6()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        textField.delegate = self
        
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
        
        //서버호출
//        getFeedMain()
    }
    
    // MARK: - 피드서버호출(기본)
    func getFeedMain() {
        
        //        let getPostNum = postNum
        //        print("⭐️게시글번호ID:\(getPostNum)")
        
        //받아온값 넣어서 호출
        //        let url = "https://dev.joeywrite.shop/app/posts/detail/\(getPostNum)"
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
    
    
}

extension SearchVC :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.feedMainModel?.result?.count ?? 0
//        return 100
        return self.feedMainModel?.result?.count ?? 0
        //        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        getFilterId = self.feedMainModel?.result?[indexPath.item].filterID ?? "d"
        
        if getFilterId == "e"{
            // 문답피드상세페이지띄우기
            let vc = UIStoryboard(name:"FeedDailyDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDailyDetailVC") as! FeedDailyDetailVC
            
            vc.modalPresentationStyle = .fullScreen
            
            //선택한 행의 내용을 feedResult에 담는다.
            //        vc.feedResult = self.feedMainModel?.result?[indexPath.item]
            vc.FeedNum = self.feedMainModel?.result?[indexPath.item].postID
            
            self.present(vc, animated: true){ }
        }else{
            // 문답피드상세페이지띄우기
            let vc = UIStoryboard(name:"FeedDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "FeedDetailVC") as! FeedDetailVC
            
            vc.modalPresentationStyle = .fullScreen
            
            //선택한 행의 내용을 feedResult에 담는다.
            //        vc.feedResult = self.feedMainModel?.result?[indexPath.item]
            vc.FeedNum = self.feedMainModel?.result?[indexPath.item].postID
            
            self.present(vc, animated: true){ }
            
        }
    }
    
    
    //셀표기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // postID = self.feedMainModel?.result?[indexPath.item].postID ?? 0

        getFilterId = self.feedMainModel?.result?[indexPath.item].filterID ?? "d"
        
        //큰셀
        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3 ) {
            
            //문답(큰셀)
            if getFilterId != "e"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
                if let annotateCell = cell as? AnnotatedPhotoCell {
                    // 제목
                    annotateCell.captionLabel.text = self.feedMainModel?.result?[indexPath.item].qnaQuestion ?? self.feedMainModel?.result?[indexPath.item].dailyTitle

                    // 배경color
                    //                annotateCell.containerView.backgroundColor = UIColor.purple
                    //필터아이디에 따른 비주얼이미지적용
                    getFilterId = self.feedMainModel?.result?[indexPath.item].filterID ?? "e"
                    if self.getFilterId == "d"{
                        annotateCell.imageView.image = UIImage(named: "TopicEnd")
                    }else if(self.getFilterId == "r"){
                        annotateCell.imageView.image = UIImage(named: "TopicRelationship")
                    }else if(self.getFilterId == "b"){
                        annotateCell.imageView.image =  UIImage(named: "TopicBucket")
                    }else if(self.getFilterId == "s"){
                        annotateCell.imageView.image =  UIImage(named: "TopicSecret")
                    }else if(self.getFilterId == "f"){
                        annotateCell.imageView.image = UIImage(named: "TopicFamily")
                    }else if(self.getFilterId == "m"){
                        annotateCell.imageView.image = UIImage(named: "TopicMemory")
                    }else if(self.getFilterId == "m"){
                        annotateCell.imageView.image = UIImage(named: "TopicForMe")
                    }
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
                    //  annotateCell.containerView.backgroundColor = UIColor.purple
                    //필터아이디에 따른 비주얼이미지적용
                    getFilterId = self.feedMainModel?.result?[indexPath.item].filterID ?? "d"
                    if self.getFilterId == "d"{
                        smallCell.imageView.image = UIImage(named: "TopicEnd")
                    }else if(self.getFilterId == "r"){
                        smallCell.imageView.image = UIImage(named: "TopicRelationship")
                    }else if(self.getFilterId == "b"){
                        smallCell.imageView.image =  UIImage(named: "TopicBucket")
                    }else if(self.getFilterId == "s"){
                        smallCell.imageView.image =  UIImage(named: "TopicSecret")
                    }else if(self.getFilterId == "f"){
                        smallCell.imageView.image = UIImage(named: "TopicFamily")
                    }else if(self.getFilterId == "m"){
                        smallCell.imageView.image = UIImage(named: "TopicMemory")
                    }else if(self.getFilterId == "u"){
                        smallCell.imageView.image = UIImage(named: "TopicForMe")
                    }
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
    
}//end







//MARK: - PINTEREST LAYOUT DELEGATE
extension SearchVC : PinterestLayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {

        if (indexPath.item % 4 == 0 || indexPath.item % 4 == 3) {
            return 310
        }else{
            return 180
        }
    }
}

