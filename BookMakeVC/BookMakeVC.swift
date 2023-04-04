//
//  BookMakeVC.swift
//  Anding
//
//  Created by woonKim on 2022/10/23.
//

import UIKit
import SwiftUI
import CoreMedia
import Alamofire
import Kingfisher

class BookMakeVC: UIViewController {
    
    @IBOutlet weak var backTapView: UIView!
    
//    private let images: [UIImage] = Array(1 ... 11).map { UIImage(named: String($0))! }
    
    var materialModel: UserData?
    // 피드 모델에 값이 있으면 가져온다.
    var feedResult: [PostList]?
    
    var selectCellModel: Array = [[String:Any]]()
//    var selectCellModel: [Any]? = []
    var postIds: [Int] = []
    var getFilterId = ""
    var postID = 0
    var cellKingfisher: UIImage?
    
    // 테스트 유저 토큰
//    var token = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjozLCJpYXQiOjE2NjcwNDU1MjAsImV4cCI6MTY2ODUxNjc0OX0.0bn5CZEueKOqOdlci4e_yoFBSqhB-miI0Xiqz3sGiaU"
    
    //
    var token = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjoxOCwiaWF0IjoxNjY4MDc3ODg5LCJleHAiOjE2Njk1NDkxMTh9.JAInaMkzzWQSjbal1jNURfgII11hjAXm16mXb1eZk0w"
    
    var currentCategoryIndex = 0
    var scrapButtonClickCount = 0
    
    // doowoon2 토큰
//    var token = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjoxMywiaWF0IjoxNjY3NTU2MDk5LCJleHAiOjE2NjkwMjczMjh9.A5Rr42aJeSS6TtSWhaRfttHCk9kainVPucIugAFrFm4"

    var topic = ChapterTopic()
    var cellClickCount = 0
    var timeFilterToggle = false
    var scrapToggle = false
    var scrapToggleCount = 0
    var chapterCellCount = 20
    var selectionCellCount = 0
    
    let line1Img = UIImage(named: "bookMakeLine1")
    let line2Img = UIImage(named: "bookMakeLine2")
    let line3Img = UIImage(named: "bookMakeLine3")
    
    var bookTotalPage = 0
    
    @IBOutlet weak var line1: UIImageView!
//    @IBOutlet weak var line2: UIImageView!
    @IBOutlet weak var line3: UIImageView!
    
    @IBOutlet weak var chapterCollectionView: UICollectionView!
    @IBOutlet weak var materialCollectionView: UICollectionView!
    @IBOutlet weak var selectionCollectionView: UICollectionView!
    
    @IBOutlet weak var timeFilter: UIButton!
    @IBOutlet weak var scrap: UIButton!
    
    @IBOutlet weak var chapterCellCountLbl: UILabel!
    @IBOutlet weak var pickCellCountLbl: UILabel!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백 버튼 뷰
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))

        // 백 버튼 뷰
        backTapView.addGestureRecognizer(tapGesture)
        
        line1.image = line1Img
//        line2.image = line2Img
        line3.image = line3Img
        
        chapterCollectionView.delegate = self
        chapterCollectionView.dataSource = self
        chapterCollectionView.tag = 1
        
        let nibName = UINib(nibName: "ChapterCollectionViewCell", bundle: nil)
        chapterCollectionView.register(nibName, forCellWithReuseIdentifier:"ChapterCollectionViewCell")
        chapterCollectionView.bgColorGray()
        
        materialCollectionView.delegate = self
        materialCollectionView.dataSource = self
        materialCollectionView.tag = 2
        materialCollectionView.collectionViewLayout = createLayoutMaterialCollectionView()
        
        selectionCollectionView.delegate = self
        selectionCollectionView.dataSource = self
        selectionCollectionView.tag = 3
        selectionCollectionView.collectionViewLayout =
        createLayoutSelectionCollectionView()
        
        pickCellCountLbl.text = "선택한 기록 \(selectCellModel.count)개"
        chapterCellCountLbl.text = "총 \(chapterCellCount)개"
        
        getAll()
        
        print("###\(UserData.self)")
        
        print("⭐️materialModel:\(  self.materialModel?.result.postList?.count)")
        print("###\(self.materialModel?.result.postList?.count)")
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        if selectCellModel.count == 0 {
            let alert = UIAlertController(title: "자서전 내용 선택은 최소 1개 이상이여야 합니다.", message: .none, preferredStyle: .alert)
        
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
                
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookMakeVC2") as? BookMakeVC2 else {
            return
        }
        vc.postIds = postIds
        vc.bookTotalPage = bookTotalPage
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func timeFilterBtn(_ sender: Any) {
        timeFilterToggle.toggle()

        if timeFilterToggle == true {
            timeFilter.setBackgroundImage(UIImage(named: "TimeReverse"), for: UIControl.State.normal)
        } else {
            timeFilter.setBackgroundImage(UIImage(named: "timeFilter"), for: UIControl.State.normal)
        }
        
        if currentCategoryIndex == 0 && timeFilterToggle == true {
            getAllReverse()
        } else if  currentCategoryIndex == 1 && timeFilterToggle == true {
            getCategoryReverse(filterID: "e")
        } else if  currentCategoryIndex == 2 && timeFilterToggle == true {
            getCategoryReverse(filterID: "d")
        } else if  currentCategoryIndex == 3 && timeFilterToggle == true {
            getCategoryReverse(filterID: "r")
        } else if  currentCategoryIndex == 4 && timeFilterToggle == true {
            getCategoryReverse(filterID: "b")
        } else if  currentCategoryIndex == 5 && timeFilterToggle == true {
            getCategoryReverse(filterID: "s")
        } else if  currentCategoryIndex == 6 && timeFilterToggle == true {
            getCategoryReverse(filterID: "f")
        } else if  currentCategoryIndex == 7 && timeFilterToggle == true {
            getCategoryReverse(filterID: "m")
        } else if  currentCategoryIndex == 8 && timeFilterToggle == true {
            getCategoryReverse(filterID: "i")
        }

        if currentCategoryIndex == 0 && timeFilterToggle == false {
            getAll()
        } else if  currentCategoryIndex == 1 && timeFilterToggle == false {
            getCategory(filterID: "e")
        } else if  currentCategoryIndex == 2 && timeFilterToggle == false {
            getCategory(filterID: "d")
        } else if  currentCategoryIndex == 3 && timeFilterToggle == false {
            getCategory(filterID: "r")
        } else if  currentCategoryIndex == 4 && timeFilterToggle == false {
            getCategory(filterID: "b")
        } else if  currentCategoryIndex == 5 && timeFilterToggle == false {
            getCategory(filterID: "s")
        } else if  currentCategoryIndex == 6 && timeFilterToggle == false {
            getCategory(filterID: "f")
        } else if  currentCategoryIndex == 7 && timeFilterToggle == false {
            getCategory(filterID: "m")
        } else if  currentCategoryIndex == 8 && timeFilterToggle == false {
            getCategory(filterID: "i")
        }
    }
    
    @IBAction func scrapTagBtn(_ sender: Any) {
        scrapToggle.toggle()
        if scrapToggle == true {
            scrap.setBackgroundImage(UIImage(named: "ScrapTagActive"), for: UIControl.State.normal)
        } else {
            scrap.setBackgroundImage(UIImage(named: "ScrapTag"), for: UIControl.State.normal)
        }

        cellClickCount += 1
        chapterCollectionView.reloadData()
        
    }
    
    private func createLayoutMaterialCollectionView() -> UICollectionViewCompositionalLayout {

        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 5, trailing: 3)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.45)), subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        // Section
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous

        // return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createLayoutSelectionCollectionView() -> UICollectionViewCompositionalLayout {

        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 8.5, bottom: 6, trailing: 0)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item, count: 4)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 3, trailing: 0)
        // return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @objc func deleteCell(sender: UIButton){
    //cell 삭제 //delete cell at index of collectionview
        self.selectionCollectionView.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
    }
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }
    
    func hexStringToUIColor (hex:String) -> UIColor {
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
    func getAll() {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        let url = "https://dev.joeywrite.shop/app/autobiographies/posts"
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]
        let params: Parameters = ["sort" : "newest"]

        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result {
            case .success(_):

                print("서버호출")
                do {
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용
                    
                    self.materialModel = try JSONDecoder().decode(UserData.self, from: dataJSON)
                    print("⭐️materialModel:\(  self.materialModel)")
                    
                    DispatchQueue.main.async {
                        self.materialCollectionView.reloadData()
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
    
    func getAllReverse() {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        let url = "https://dev.joeywrite.shop/app/autobiographies/posts"
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]
        let params: Parameters = ["sort" : "oldest"]

        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result{
            case .success(_):

                print("서버호출")
                do {
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용
                    
                    self.materialModel = try JSONDecoder().decode(UserData.self, from: dataJSON)
                    print("⭐️materialModel:\(  self.materialModel)")
                    
                    DispatchQueue.main.async {
                        self.materialCollectionView.reloadData()
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
    
    func getCategory(filterID:String) {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String

        let getPostNum = filterID
//        let url = "https://dev.joeywrite.shop/app/autobiographies/posts?sort=newest&filter-id=\(getPostNum)"
        let url = "https://dev.joeywrite.shop/app/autobiographies/posts"
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]
        let params: Parameters = ["sort" : "newest", "filter-id": getPostNum]

        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result {
            case .success(_):
                
                guard let jsonObject = try! res.result.get() as? [String : Any] else {
                    print("올바른 응답값이 아닙니다.")
                    return
                }

                print("서버호출")
                do {
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용

                    self.materialModel = try JSONDecoder().decode(UserData.self, from: dataJSON)

                    print("⭐️materialModel:\(  self.materialModel)")
                    self.materialCollectionView.reloadData()
//                    print("⭐️Cate:\(  self.feedMainModel?.result.postList[0])")
                    
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
    
    func getCategoryReverse(filterID:String) {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String

        let getPostNum = filterID
        let url = "https://dev.joeywrite.shop/app/autobiographies/posts"
        
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]

        let params: Parameters = ["sort" : "oldest", "filter-id": getPostNum]

        //LCId=&MCId=&SCId=
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result {
            case .success(_):
                
                guard let jsonObject = try! res.result.get() as? [String : Any] else {
                    print("올바른 응답값이 아닙니다.")
                    return
                }

                print("서버호출")
                do {
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용

                    self.materialModel = try JSONDecoder().decode(UserData.self, from: dataJSON)
                    print("⭐️materialModel:\(self.materialModel)")
                    self.materialCollectionView.reloadData()
         
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
extension BookMakeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return topic.TopicImageOff.count
        } else if collectionView.tag == 2 {
            chapterCellCountLbl.text = "총 \(self.materialModel?.result.postList?.count ?? 0)개"
          
            return self.materialModel?.result.postList?.count ?? 0
        }
        return self.selectCellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            scrapToggle = false
//            scrap.setBackgroundImage(UIImage(named: "ScrapTag"), for: UIControl.State.normal)
            cellClickCount += 1
            
            if indexPath.row == 0 {
                currentCategoryIndex = 0
                getAll()
            } else if indexPath.row == 1 && timeFilterToggle == false {
                getCategory(filterID: "e")
                currentCategoryIndex = 1
            } else if indexPath.row == 2 && timeFilterToggle == false {
                getCategory(filterID: "d")
                currentCategoryIndex = 2
            } else if indexPath.row == 3 && timeFilterToggle == false {
                getCategory(filterID: "r")
                currentCategoryIndex = 3
            } else if indexPath.row == 4 && timeFilterToggle == false {
                getCategory(filterID: "b")
                currentCategoryIndex = 4
            } else if indexPath.row == 5 && timeFilterToggle == false {
                getCategory(filterID: "s")
                currentCategoryIndex = 5
            } else if indexPath.row == 6 && timeFilterToggle == false {
                getCategory(filterID: "f")
                currentCategoryIndex = 6
            } else if indexPath.row == 7 && timeFilterToggle == false {
                getCategory(filterID: "m")
                currentCategoryIndex = 7
            } else if indexPath.row == 8 && timeFilterToggle == false {
                getCategory(filterID: "i")
                currentCategoryIndex = 8
            }
            
            if indexPath.row == 0 {
                currentCategoryIndex = 0
                getAllReverse()
            } else if indexPath.row == 1 && timeFilterToggle == true {
                getCategoryReverse(filterID: "e")
                currentCategoryIndex = 1
            } else if indexPath.row == 2 && timeFilterToggle == true {
                getCategoryReverse(filterID: "d")
                currentCategoryIndex = 2
            } else if indexPath.row == 3 && timeFilterToggle == true {
                getCategoryReverse(filterID: "r")
                currentCategoryIndex = 3
            } else if indexPath.row == 4 && timeFilterToggle == true {
                getCategoryReverse(filterID: "b")
                currentCategoryIndex = 4
            } else if indexPath.row == 5 && timeFilterToggle == true {
                getCategoryReverse(filterID: "s")
                currentCategoryIndex = 5
            } else if indexPath.row == 6 && timeFilterToggle == true {
                getCategoryReverse(filterID: "f")
                currentCategoryIndex = 6
            } else if indexPath.row == 7 && timeFilterToggle == true {
                getCategoryReverse(filterID: "m")
                currentCategoryIndex = 7
            } else if indexPath.row == 8 && timeFilterToggle == true {
                getCategoryReverse(filterID: "i")
                currentCategoryIndex = 8
            }
            
        } else if collectionView.tag == 2 {
            
//            selectionCellCount += 1
    
            guard let cell = materialCollectionView.dequeueReusableCell(withReuseIdentifier: "materialCollectionViewCell", for: indexPath) as? materialCollectionViewCell else {
                return
            }
            
            if postIds.contains(self.materialModel?.result.postList?[indexPath.item].postID ?? 0) == false {
            
            self.postIds.append(self.materialModel?.result.postList?[indexPath.item].postID ?? 0)
            print("⭐️postIds:\(self.postIds)")
            
            var selectCell: [String : Any] = ["postID": 0, "filterID": "", "qnaBackgroundColor": "", "qnaQuestionID": "",
                                              "dailyTitle": "", "dailyImage": ""]

            selectCell["postID"] = (self.materialModel?.result.postList?[indexPath.item].postID)
            selectCell["filterID"] = (self.materialModel?.result.postList?[indexPath.item].filterID)
            selectCell["qnaBackgroundColor"] = (self.materialModel?.result.postList?[indexPath.item].qnaBackgroundColor)
            selectCell["qnaQuestionID"] = (self.materialModel?.result.postList?[indexPath.item].qnaQuestionID)
            selectCell["qnaQuestion"] = (self.materialModel?.result.postList?[indexPath.item].qnaQuestion)
            selectCell["dailyTitle"] = (self.materialModel?.result.postList?[indexPath.item].dailyTitle)
            selectCell["dailyImage"] = (self.materialModel?.result.postList?[indexPath.item].dailyImage)
            
            selectCellModel.append(selectCell)
            
            print("⭐️selectCellModel:\(self.selectCellModel)")
//            print("⭐️selectCellModel:\(type(of: self.selectCellModel))")
//            print("⭐️selectCellModel:\(self.selectCellModel[0]["filterID"])")
            
            selectionCollectionView.reloadData()
                
            self.pickCellCountLbl.text = "선택한 기록 \(self.selectCellModel.count)개"
            self.bookTotalPage = self.selectCellModel.count
                
            } else {
                let alert = UIAlertController(title: "이미 선택된 항목 입니다.", message: .none, preferredStyle: .alert)
            
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(ok)
                    
                present(alert, animated: true, completion: nil)
                return
            }
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterCollectionViewCell.identifier, for: indexPath) as! ChapterCollectionViewCell
            
        cell.index = indexPath.row
        
        // 기본이 딤드되어있고, 누르면 On되는 상태
        cell.imgView.image = self.topic.TopicImageOff[indexPath.row]
        
        // 화면 진입시 첫번째 태그 On 상태로
        if cellClickCount == 0 {
            if indexPath.item == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
        }
        
        // 스크롤 사용해도 선택한 버튼 안풀리게
        if indexPath.row == 1 {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
            
        } else if collectionView.tag == 2 {
            
        guard let cell = materialCollectionView.dequeueReusableCell(withReuseIdentifier: "materialCollectionViewCell", for: indexPath) as? materialCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.materialTitelTxView.isScrollEnabled = false
            
            getFilterId = self.materialModel?.result.postList?[indexPath.item].filterID ?? "Y"
            
            if self.getFilterId == "e" {
                cell.dailyTitleLbl.text = self.materialModel?.result.postList?[indexPath.item].dailyTitle
                
//                let encodedStr = self.materialModel?.result.postList?[indexPath.item].dailyImage!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//
//                let url = URL(string: encodedStr!)
//                print("@@@@\(url)")
//
//                cell.dailyImageView.kf.setImage(with: url)
//                cell.materialTitelTxView.text = ""
//                cell.cellImageView.isHidden = true
//                cell.dailyImageView.isHidden = false
        
            let imgInfo  = self.materialModel?.result.postList?[indexPath.item].dailyImage!

            if imgInfo != nil {
                if let imageURL = self.materialModel?.result.postList?[indexPath.item].dailyImage! {
                    guard let url = URL(string: imageURL) else {
                        return UICollectionViewCell()
                    }
                    cell.dailyImageView.kf.indicatorType = .activity
                    cell.dailyImageView.kf.setImage(
                        with: url,
                        placeholder: UIImage(named: "placeholderImage")
                    )
                    {
                        result in switch result {
                        case .success(_): break
                        case .failure(let err):
                            print(err.localizedDescription)
                                }
                            }
                        }
                    }
                    cell.materialTitelTxView.text = ""
                    cell.cellImageView.isHidden = true
                    cell.dailyImageView.isHidden = false
            }
            
            if self.getFilterId == "d" {
                var imgInsert = self.materialModel?.result.postList?[indexPath.item].qnaQuestionID
                cell.cellImageView.image = UIImage(named: imgInsert ?? "")
                cell.dailyTitleLbl.text = ""
                cell.materialTitelTxView.text = self.materialModel?.result.postList?[indexPath.item].qnaQuestion
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
                
            } else if(self.getFilterId == "r") {
                var imgInsert = self.materialModel?.result.postList?[indexPath.item].qnaQuestionID
                cell.cellImageView.image = UIImage(named: imgInsert ?? "")
                cell.dailyTitleLbl.text = ""
                cell.materialTitelTxView.text = self.materialModel?.result.postList?[indexPath.item].qnaQuestion
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "b") {
                var imgInsert = self.materialModel?.result.postList?[indexPath.item].qnaQuestionID
                cell.cellImageView.image = UIImage(named: imgInsert ?? "")
                cell.dailyTitleLbl.text = ""
                cell.materialTitelTxView.text = self.materialModel?.result.postList?[indexPath.item].qnaQuestion
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "s") {
                var imgInsert = self.materialModel?.result.postList?[indexPath.item].qnaQuestionID
                cell.cellImageView.image = UIImage(named: imgInsert ?? "")
                cell.dailyTitleLbl.text = ""
                cell.materialTitelTxView.text = self.materialModel?.result.postList?[indexPath.item].qnaQuestion
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "f") {
                var imgInsert = self.materialModel?.result.postList?[indexPath.item].qnaQuestionID
                cell.cellImageView.image = UIImage(named: imgInsert ?? "")
                cell.dailyTitleLbl.text = ""
                cell.materialTitelTxView.text = self.materialModel?.result.postList?[indexPath.item].qnaQuestion
                print("$$$\(type(of: self.materialModel?.result.postList))")
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "m") {
                var imgInsert = self.materialModel?.result.postList?[indexPath.item].qnaQuestionID
                cell.cellImageView.image = UIImage(named: imgInsert ?? "")
                cell.dailyTitleLbl.text = ""
                cell.materialTitelTxView.text = self.materialModel?.result.postList?[indexPath.item].qnaQuestion
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "i") {
                var imgInsert = self.materialModel?.result.postList?[indexPath.item].qnaQuestionID
                cell.cellImageView.image = UIImage(named: imgInsert ?? "")
                cell.dailyTitleLbl.text = ""
                cell.materialTitelTxView.text = self.materialModel?.result.postList?[indexPath.item].qnaQuestion
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            }
            
            cell.layer.cornerRadius = 6
            let getColor = self.materialModel?.result.postList?[indexPath.item].qnaBackgroundColor
            cell.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
            
            print("$$$\(indexPath.row)")
            return cell
        }
        
        else if collectionView.tag == 3 {
         
            
            guard let cell = selectionCollectionView.dequeueReusableCell(withReuseIdentifier: "selectionCollectionViewCell", for: indexPath) as? selectionCollectionViewCell else {
                    return UICollectionViewCell()
            }

            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deletePreview(sender:)), for: .touchUpInside)

            cell.selectTitleTxView.isScrollEnabled = false
            
            getFilterId = "\(self.selectCellModel[indexPath.item]["filterID"]!)"

            if self.getFilterId == "e" {
                
                cell.dailyTitleLbl.text = "\(self.selectCellModel[indexPath.item]["dailyTitle"]!)"
                
                let imgInfo = "\(self.selectCellModel[indexPath.item]["dailyImage"]!)"

                if imgInfo != nil {
                    if let imageURL = Optional(imgInfo) {
                        guard let url = URL(string: imageURL) else {
                            return UICollectionViewCell()
                        }
                        cell.dailyImageView.kf.indicatorType = .activity
                        cell.dailyImageView.kf.setImage(
                            with: url,
                            placeholder: UIImage(named: "placeholderImage")
                        )
                        {
                            result in switch result {
                            case .success(_): break
                            case .failure(let err):
                                print(err.localizedDescription)
                                    }
                                }
                            }
                        }
                        cell.selectTitleTxView.text = ""
                        cell.cellImageView.isHidden = true
                        cell.dailyImageView.isHidden = false
            }
//                cell.dailyImageView.kf.setImage(with: url)
//                cell.selectTitleTxView.text = ""
//                cell.cellImageView.isHidden = true
//                cell.dailyImageView.isHidden = false

            if self.getFilterId == "d" {
                var imgInsert = self.selectCellModel[indexPath.item]["qnaQuestionID"]
                cell.cellImageView.image = UIImage(named: imgInsert as! String)
                cell.dailyTitleLbl.text = ""
                cell.selectTitleTxView.text = self.selectCellModel[indexPath.item]["qnaQuestion"] as? String
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true

            } else if(self.getFilterId == "r") {
                var imgInsert = self.selectCellModel[indexPath.item]["qnaQuestionID"]
                cell.cellImageView.image = UIImage(named: imgInsert as! String)
                cell.dailyTitleLbl.text = ""
                cell.selectTitleTxView.text = self.selectCellModel[indexPath.item]["qnaQuestion"] as? String
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "b") {
                var imgInsert = self.selectCellModel[indexPath.item]["qnaQuestionID"]
                cell.cellImageView.image = UIImage(named: imgInsert as! String)
                cell.dailyTitleLbl.text = ""
                cell.selectTitleTxView.text = self.selectCellModel[indexPath.item]["qnaQuestion"] as? String
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "s") {
                var imgInsert = self.selectCellModel[indexPath.item]["qnaQuestionID"]
                cell.cellImageView.image = UIImage(named: imgInsert as! String)
                cell.dailyTitleLbl.text = ""
                cell.selectTitleTxView.text = self.selectCellModel[indexPath.item]["qnaQuestion"] as? String
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "f") {
                var imgInsert = self.selectCellModel[indexPath.item]["qnaQuestionID"]
                cell.cellImageView.image = UIImage(named: imgInsert as! String)
                cell.dailyTitleLbl.text = ""
                cell.selectTitleTxView.text = self.selectCellModel[indexPath.item]["qnaQuestion"] as? String
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "m") {
                var imgInsert = self.selectCellModel[indexPath.item]["qnaQuestionID"]
                cell.cellImageView.image = UIImage(named: imgInsert as! String)
                cell.dailyTitleLbl.text = ""
                cell.selectTitleTxView.text = self.selectCellModel[indexPath.item]["qnaQuestion"] as? String
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            } else if(self.getFilterId == "i") {
                var imgInsert = self.selectCellModel[indexPath.item]["qnaQuestionID"]
                cell.cellImageView.image = UIImage(named: imgInsert as! String)
                cell.dailyTitleLbl.text = ""
                cell.selectTitleTxView.text = self.selectCellModel[indexPath.item]["qnaQuestion"] as? String
                cell.cellImageView.isHidden = false
                cell.dailyImageView.isHidden = true
            }

            cell.layer.cornerRadius = 6
                    
            let getColor = self.selectCellModel[indexPath.item]["qnaBackgroundColor"]
               
            cell.backgroundColor = self.hexStringToUIColor(hex: "\(getColor ?? "#7E73FF")")

            print("$$$\(indexPath.row)")

            return cell
        }
     
        return UICollectionViewCell()
    }
    
    
    @objc func deletePreview(sender: UIButton) {
     
        self.selectCellModel.remove(at: sender.tag)
        self.postIds.remove(at: sender.tag)
        print("⭐️selectCellModel:\(self.selectCellModel)")
        print("⭐️selectCellModelCount:\(self.selectCellModel.count)")
        print("⭐️postIds:\(self.postIds)")
    
        selectionCollectionView.reloadData()
        self.pickCellCountLbl.text = "선택한 기록 \(self.selectCellModel.count)개"
        self.bookTotalPage = self.selectCellModel.count
    }
}


class materialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var materialTitelTxView: UITextView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var dailyTitleLbl: UILabel!
}

class selectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectTitleTxView: UITextView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var dailyTitleLbl: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    
}





