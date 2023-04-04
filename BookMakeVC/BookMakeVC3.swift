//
//  BookMakeVC3.swift
//  Anding
//
//  Created by woonKim on 2022/11/02.
//

import UIKit
import Alamofire

class BookMakeVC3: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var backTapView: UIView!
    
    let line1Img = UIImage(named: "BookMake2Line1")
    let bookCoverLineImg = UIImage(named: "BookCoverLine")
    let bookCoverObjetImg = UIImage(named: "Objet")
    let temporalObjetImg = UIImage(named: "temporalObjet")
    
    var titleViewTxFromBookMake2 = ""
    var titleColorFromBookMake2: UIColor?
    var bookCoverColorFromBookMake2: UIColor?
    var colorWell: UIColorWell!
    var objet = BookMakeObjet()
    var cellClickCount = 0
    
    var postIds: [Int] = []
    var sendBookCoverColor = ""
    var sendTitleColor = ""
    
    var objetColor = 0
    
    let bookMakePostUrl = "https://dev.joeywrite.shop/app/autobiographies"
    
    var token = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjozLCJpYXQiOjE2NjcwNDU1MjAsImV4cCI6MTY2ODUxNjc0OX0.0bn5CZEueKOqOdlci4e_yoFBSqhB-miI0Xiqz3sGiaU"
    
    var subTitlePlaceHolder = "이름이나 날짜 등 간단한 정보를 적어주세요."
    
    var bookTotalPage = 0
  
    @IBOutlet weak var bookCover: UIView!
    @IBOutlet weak var line1: UIImageView!
    @IBOutlet weak var bookCoverLine: UIImageView!
    @IBOutlet weak var bookCoverObjet: UIImageView!
    
    @IBOutlet weak var titleTxView: UITextView!
    @IBOutlet weak var subTitleTxView: UITextView!
    @IBOutlet weak var inputSubTitleTxView: UITextView!
    
    @IBOutlet weak var objetCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백 버튼 뷰
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))

        // 백 버튼 뷰
        backTapView.addGestureRecognizer(tapGesture)
        
        line1.image = line1Img
        bookCoverLine.image = bookCoverLineImg

        bookCoverObjet.image = bookCoverObjetImg
        bookCover.layer.cornerRadius = 5.26316
        bookCover.backgroundColor = bookCoverColorFromBookMake2
        titleTxView.text = titleViewTxFromBookMake2
        titleTxView.textColor = titleColorFromBookMake2
        titleTxView.textContainer.maximumNumberOfLines = 3
    
        inputSubTitleTxView.delegate = self
        inputSubTitleTxView.layer.cornerRadius = 6
        inputSubTitleTxView.layer.borderWidth = 1
        inputSubTitleTxView.layer.borderColor = UIColor.white.cgColor
        inputSubTitleTxView.textColor = .white
        inputSubTitleTxView.autocorrectionType = .no
        inputSubTitleTxView.textContainerInset = UIEdgeInsets(top: 20, left: 8, bottom: 15, right: 15)
     
        subTitleTxView.textContainer.maximumNumberOfLines = 2
        
        let nibName = UINib(nibName: "ObjetCollectionViewCell", bundle: nil)
        objetCollectionView.register(nibName, forCellWithReuseIdentifier:"ObjetCollectionViewCell")
        objetCollectionView.delegate = self
        objetCollectionView.dataSource = self
        objetCollectionView.collectionViewLayout =
        createLayoutObjetCollectionView()
        
        
        sendBookCoverColor = hexStringFromColor(color: bookCover.backgroundColor!)
        sendTitleColor = hexStringFromColor(color: titleTxView.textColor!)
        
        print("⭐️최종titleText:\(titleViewTxFromBookMake2)")
        print("⭐️최종bookCoverColor:\(sendBookCoverColor)")
        print("⭐️최종titleColor:\(sendTitleColor)")
        print("⭐️최종postIds:\(postIds)")
        print("⭐️최종추가설명:\(inputSubTitleTxView.text!)")
        print("⭐️최종오브제컬러:\(objetColor)")
        print("⭐️초기 추가 설명 글자 수:\(inputSubTitleTxView.text!.count)")
        print("⭐️초기 추가 설명 글자 수:\(type(of: inputSubTitleTxView.text!))")
        print("⭐️초기 추가 설명 글자 수:\(type(of: subTitleTxView.text!))")
        print("⭐️초기 추가 설명 글자 수:\(inputSubTitleTxView.text!)")
        print("⭐️초기 추가 설명 글자 수:\(subTitleTxView.text!)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
           self.view.endEditing(true)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
//     자서전 스토리보드로 바로 넘어가면 아래에 탭바가 안나옴
//        let book = UIStoryboard(name: "BookVC", bundle: nil)
//        let vc = book.instantiateViewController(identifier: "BookVC")
//
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
//
//     보내야 하는 객체 구조
//        {
//            "title" : "조이의 자서전",
//            "detail" : "꽃가루를 날려어~",
//            "coverColor" : "#7aca2a",
//            "titleColor" : "#000e4b",
//            "objetColor" : 2,
//            "postIds" : [170,152,169,168,167]
//        }
        
        let token = UserDefaults.standard.value(forKey:"token") as! String

        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]

        var params: Parameters = ["title" : titleViewTxFromBookMake2,
                                  "detail" : subTitleTxView.text!,
                                  "coverColor" : sendBookCoverColor,
                                  "titleColor" : sendTitleColor,
                                  "objetColor" : objetColor,
                                  "postIds" : postIds]

        if subTitleTxView.text! == "추가 설명을 적어주세요." {

            params = ["title" : titleViewTxFromBookMake2,
                                  "coverColor" : sendBookCoverColor,
                                  "titleColor" : sendTitleColor,
                                  "objetColor" : objetColor,
                                  "postIds" : postIds]

        } else {

            params = ["title" : titleViewTxFromBookMake2,
                                      "detail" : subTitleTxView.text!,
                                      "coverColor" : sendBookCoverColor,
                                      "titleColor" : sendTitleColor,
                                      "objetColor" : objetColor,
                                      "postIds" : postIds]
        }

        AF.request(bookMakePostUrl,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in

            switch response.result {
                case .success(let obj):
                print(obj)

                print("⭐️통신성공")
                    do {
                    } catch let DecodingError.dataCorrupted(context) {
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

                case .failure(let e):
                print(e.localizedDescription)
                print("⭐️통신실패")
            }
        }
        
        let alert = UIAlertController(title: "자서전 제작이 완료 되었습니다.", message: .none, preferredStyle: .alert)
    
        let ok = UIAlertAction(title: "확인", style: .default, handler: { action in
            let main = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = main.instantiateViewController(identifier: "TabBarController")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        })
        alert.addAction(ok)

        present(alert, animated: true, completion: nil)
        return
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        subTitleTxView.text = inputSubTitleTxView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            
        inputSubTitleTxView.text = ""
    }
    
    private func createLayoutObjetCollectionView() -> UICollectionViewCompositionalLayout {

        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -6, bottom: 0, trailing: 0)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(421), heightDimension: .fractionalHeight(1)), subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 0, trailing: 0)
        // return
        return UICollectionViewCompositionalLayout(section: section)
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
}

extension BookMakeVC3: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return objet.ObjetImageOff.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        cellClickCount += 1
        
        if indexPath.row == 0 {
            bookCoverObjet.image = UIImage(named: "BookCoverObjet1")
            self.objetColor = 1
        } else if indexPath.row == 1 {
            bookCoverObjet.image = UIImage(named: "BookCoverObjet2")
            self.objetColor = 2
        } else if indexPath.row == 2 {
            bookCoverObjet.image = UIImage(named: "BookCoverObjet3")
            self.objetColor = 3
        } else if indexPath.row == 3 {
            bookCoverObjet.image = UIImage(named: "BookCoverObjet4")
            self.objetColor = 4
        } else if indexPath.row == 4 {
            bookCoverObjet.image = UIImage(named: "BookCoverObjet5")
            self.objetColor = 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ObjetCollectionViewCell.identifier, for: indexPath) as! ObjetCollectionViewCell
            
        cell.index = indexPath.row
        
        // 기본이 딤드되어있고, 누르면 On되는 상태
        cell.imgView.image = self.objet.ObjetImageOff[indexPath.row]
        
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
    }
}




