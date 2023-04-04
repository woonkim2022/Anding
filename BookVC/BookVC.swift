//
//  BookVC.swift
//  Anding
//
//  Created by woonKim on 2022/10/21.
//

import UIKit
import Alamofire

class BookVC: UIViewController {

    var titleTxViewTextFromServer = ""
    var titleTxViewTextColorFromServer = ""
    
    let lineImg = UIImage(named: "BookCoverLine")
    
    let objet1Img = UIImage(named: "BookCoverObjet1")
    let objet2Img = UIImage(named: "BookCoverObjet2")
    let objet3Img = UIImage(named: "BookCoverObjet3")
    let objet4Img = UIImage(named: "BookCoverObjet4")
    let objet5Img = UIImage(named: "BookCoverObjet5")
    
    var bookModel: BookGet?
    
//    var ids: [Int] = []
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
//    var token = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjozLCJpYXQiOjE2NjcwNDU1MjAsImV4cCI6MTY2ODUxNjc0OX0.0bn5CZEueKOqOdlci4e_yoFBSqhB-miI0Xiqz3sGiaU"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        bookCollectionView.collectionViewLayout = createLayoutBookCollectionView()

        getBook()
    }
    
    
    
    func getBook() {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        let url = "https://dev.joeywrite.shop/app/autobiographies"
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]

        AF.request(url,
                   method: .get,
                   parameters: nil,
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
                    
                    self.bookModel = try JSONDecoder().decode(BookGet.self, from: dataJSON)
                    print("⭐️bookModel:\( self.bookModel)")
                    
                    DispatchQueue.main.async {
                        self.bookCollectionView.reloadData()
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
    
    private func createLayoutBookCollectionView() -> UICollectionViewCompositionalLayout {

        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 8.5, bottom: 6, trailing: 0)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(455), heightDimension: .fractionalHeight(1)), subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0)
        // return
        return UICollectionViewCompositionalLayout(section: section)
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
}

extension BookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookModel?.bookGetResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print("⭐️id선택중:\(    self.bookModel?.bookGetResult?[indexPath.item].id )")
        print("⭐️id선택중:선택중입니다")

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailVC") as? BookDetailVC else {
            return
        }
        vc.bookId = self.bookModel?.bookGetResult?[indexPath.item].id ?? 0
        var string = self.bookModel?.bookGetResult?[indexPath.item].title ?? ""
        vc.bookTitleFromBookVC = string.trimmingCharacters(in: .whitespacesAndNewlines)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = bookCollectionView.dequeueReusableCell(withReuseIdentifier: "bookCollectionViewCell", for: indexPath) as? bookCollectionViewCell else {
                return UICollectionViewCell()
        }
//        cell.titleTxView.text = self.bookModel?.result?[indexPath.item].title!
//        cell.bookOpenBtn.tag = indexPath.row
//        cell.bookOpenBtn.addTarget(self, action: #selector(bookDetail(sender:)), for: .touchUpInside)
    
        cell.titleTxView.text = self.bookModel?.bookGetResult?[indexPath.item].title
        cell.subTitleTxView.text = self.bookModel?.bookGetResult?[indexPath.item].detail
        cell.backgroundColor = hexStringToUIColor(hex: self.bookModel?.bookGetResult?[indexPath.item].coverColor ?? "")
        cell.titleTxView.textColor = hexStringToUIColor(hex: self.bookModel?.bookGetResult?[indexPath.item].titleColor ?? "")
        
        cell.ids = self.bookModel?.bookGetResult?[indexPath.item].id ?? 0
        
        if self.bookModel?.bookGetResult?[indexPath.item].objetColor == 1 {
            cell.objet.image = objet1Img
        } else if self.bookModel?.bookGetResult?[indexPath.item].objetColor == 2 {
            cell.objet.image = objet2Img
        } else if self.bookModel?.bookGetResult?[indexPath.item].objetColor == 3 {
            cell.objet.image = objet3Img
        } else if self.bookModel?.bookGetResult?[indexPath.item].objetColor == 4 {
            cell.objet.image = objet4Img
        } else if self.bookModel?.bookGetResult?[indexPath.item].objetColor == 5 {
            cell.objet.image = objet5Img
        }
        cell.subTitleTxView.textContainer.maximumNumberOfLines = 2
        cell.bookCoverLine.image = self.lineImg
        cell.layer.cornerRadius = 5.26316
        
        return cell
        
        return UICollectionViewCell()
    }
    
    @objc func bookDetail(sender: UIButton) {
//        print(indexPath.row)
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookDetailVC") as? BookDetailVC else {
//            return
//        }
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
   

}


class bookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookCoverLine: UIImageView!
    @IBOutlet weak var titleTxView: UITextView!
    @IBOutlet weak var objet: UIImageView!
    @IBOutlet weak var subTitleTxView: UITextView!
//    var ids: [Int] = []
    var ids = 0
    @IBOutlet weak var bookOpenBtn: UIButton!
}
