//
//  BookDetailVC.swift
//  Anding
//
//  Created by woonKim on 2022/11/12.
//

import UIKit
import Alamofire

class BookDetailVC: UIViewController {
    
    @IBOutlet weak var backTapView: UIView!
    
    var bookTotalPage: Int?
    
    @IBOutlet weak var bookDetailImage: UIImageView!
    
    @IBOutlet weak var bookDetailTitleLbl: UILabel!
    @IBOutlet weak var bookDetailDailyTitle: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    
    @IBOutlet weak var bookDetailDailyImage: UIImageView!
    
    @IBOutlet weak var bookDetailQuestionTxView: UITextView!
    @IBOutlet weak var bookDetailTxView: UITextView!
//    @IBOutlet weak var bookDetailDailyTxView: UITextView!

    @IBOutlet weak var bookCurrentPageLbl: UILabel!
    @IBOutlet weak var bookTotalPageLbl: UILabel!
    
    
    @IBOutlet weak var backBtnView: UIView!
    
    var getFirstPage = false
    
    var bookDetailModel: BookPage?

    var token = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjozLCJpYXQiOjE2NjcwNDU1MjAsImV4cCI6MTY2ODUxNjc0OX0.0bn5CZEueKOqOdlci4e_yoFBSqhB-miI0Xiqz3sGiaU"
    
    var bookId = 0
    var bookTitleFromBookVC = ""
    
    var bookCurrentPage = 1
    var left = 1
    var right = 0

    @IBOutlet weak var gestureView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백 버튼 뷰
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))

        // 백 버튼 뷰
        backTapView.addGestureRecognizer(tapGesture)

        bookDetailTitleLbl.text = bookTitleFromBookVC.trimmingCharacters(in: [" "])
        getInitialPage()
    
        bookCurrentPageLbl.text = String(bookCurrentPage)

        print("⭐️bookId:\(bookId)")
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
    
        leftSwipeGestureRecognizer.direction = .left
        rightSwipeGestureRecognizer.direction = .right

        gestureView.addGestureRecognizer(leftSwipeGestureRecognizer)
        gestureView.addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
        // 화면에 표시될 때마다 실행되는 메소드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("⭐️bookTotalPage:\(bookTotalPage)")
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            NSLog("Swipe Left")
//            if bookCurrentPage == 1 {
//                let alert = UIAlertController(title: "첫 페이지 입니다.", message: .none, preferredStyle: .alert)
//
//                let ok = UIAlertAction(title: "확인", style: .default, handler: { action in
//                    let main = UIStoryboard(name: "Main", bundle: nil)
//                    let mainTabBarController = main.instantiateViewController(identifier: "TabBarController")
//
//                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
//                })
//                alert.addAction(ok)
//                present(alert, animated: true, completion: nil)
//                return
//            }
            
            
            if bookCurrentPage != 1 {
                bookCurrentPage -= 1
            }
         
            print(bookCurrentPage)
            bookCurrentPageLbl.text = String(bookCurrentPage)
            getLeftPage()
        }
            
        if (sender.direction == .right) {
            NSLog("Swipe Right")
            
//            if bookCurrentPage == self.bookDetailModel?.bookPage?.lastPage {
//                let alert = UIAlertController(title: "마지막 페이지 입니다.", message: .none, preferredStyle: .alert)
//
//                let ok = UIAlertAction(title: "확인", style: .default, handler: { action in
//                    let main = UIStoryboard(name: "Main", bundle: nil)
//                    let mainTabBarController = main.instantiateViewController(identifier: "TabBarController")
//
//                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
//                })
//                alert.addAction(ok)
//                present(alert, animated: true, completion: nil)
//                return
//            }
            
            if bookCurrentPage < bookTotalPage! {
                bookCurrentPage += 1
            }
            print(bookCurrentPage)
            bookCurrentPageLbl.text = String(bookCurrentPage)
            getRightPage()
        }
    }
    
    func getInitialPage() {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        let url = "https://dev.joeywrite.shop/app/autobiographies/\(bookId)/pages/1"
        
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]

        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result {
            case .success(_):
             
                do {
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    
                    // JSON디코더 사용
                    print("⭐️bookDetailModel:\(dataJSON)")
                    self.bookDetailModel = try JSONDecoder().decode(BookPage.self, from: dataJSON)
                    
                    
                    print("⭐️bookDetailModel:\(self.bookDetailModel)")
                    print("⭐️bookDetailModelfilterID:\( self.bookDetailModel?.bookPage?.filterID)")
                    print("⭐️bookDetailModellastPage:\( self.bookDetailModel?.bookPage?.lastPage!)")
                    
                  
                    
                    // 일상 조건문
                    if self.bookDetailModel?.bookPage?.filterID! == "e" {
                        
                    let imgInfo = self.bookDetailModel?.bookPage?.dailyImage!

                    if imgInfo != nil {
                        if let imageURL = self.bookDetailModel?.bookPage?.dailyImage! {
                            guard let url = URL(string: imageURL) else {
                                return
                            }
                            self.bookDetailDailyImage.kf.indicatorType = .activity
                            self.bookDetailDailyImage.kf.setImage(
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
                        
                        self.bookDetailDailyImage.isHidden = false
                        self.bookDetailImage.isHidden = true
                        
                        self.bookDetailQuestionTxView.text = ""
                        self.bookDetailDailyTitle.text = self.bookDetailModel?.bookPage?.dailyTitle
                        self.bookDetailTxView.text = self.bookDetailModel?.bookPage?.contents ?? ""
                        self.bookDetailTxView.textColor = self.hexStringToUIColor(hex: "#E0E1EB")
                   
                    } else {
                        self.bookDetailImage.isHidden = false
                        
                        self.bookDetailDailyTitle.text = ""
                        self.bookDetailDailyImage.isHidden = true
                        
                        self.view.backgroundColor = self.hexStringToUIColor(hex: self.bookDetailModel?.bookPage?.qnaBackgroundColor ?? "")
                        self.bookDetailQuestionTxView.text = "Q. \(self.bookDetailModel?.bookPage?.qnaQuestion ?? "")"
                        self.bookDetailTxView.text = self.bookDetailModel?.bookPage?.contents ?? ""
                        self.bookDetailTxView.textColor = self.hexStringToUIColor(hex: "#3E4048")
                        var imgInsert = self.bookDetailModel?.bookPage?.qnaQuestionID ?? ""
                        self.bookDetailImage.image = UIImage(named: imgInsert)
                    }
                    
                    // 북 총 페이지 수 할당
                    self.bookTotalPageLbl.text = "\(self.bookDetailModel?.bookPage?.lastPage ?? 0)"
                    self.bookTotalPage = Int(self.bookTotalPageLbl.text ?? "")
                    print("⭐️bookTotalPage:\( Int(self.bookTotalPageLbl.text ?? ""))")
                    
                    
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
    
    func getLeftPage() {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        print("⭐️bookCurrentPage:\(self.bookCurrentPage)")
        
        let url = "https://dev.joeywrite.shop/app/autobiographies/\(bookId)/pages/\(self.bookCurrentPage)"
        
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]

        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result {
            case .success(_):
             
                do {
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    
               
                    
                    // JSON디코더 사용
                    print("⭐️bookDetailModel:\(dataJSON)")
                    self.bookDetailModel = try JSONDecoder().decode(BookPage.self, from: dataJSON)
                    
                    print("⭐️bookDetailModel:\(self.bookDetailModel)")
                    
                    // 일상 조건문
                    if self.bookDetailModel?.bookPage?.filterID! == "e" {
                        
                    let imgInfo  = self.bookDetailModel?.bookPage?.dailyImage ?? ""

                    if imgInfo != nil {
                        if let imageURL = self.bookDetailModel?.bookPage?.dailyImage {
                            guard let url = URL(string: imageURL) else {
                                return
                            }
                            self.bookDetailDailyImage.kf.indicatorType = .activity
                            self.bookDetailDailyImage.kf.setImage(
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
                        self.bookDetailDailyImage.isHidden = false
                        self.bookDetailImage.isHidden = true
                        self.bookDetailQuestionTxView.text = ""
//                        self.bookDetailImage.isHidden = true
                        self.bookDetailDailyTitle.text = self.bookDetailModel?.bookPage?.dailyTitle
                        self.bookDetailTxView.text = self.bookDetailModel?.bookPage?.contents ?? ""
                        self.bookDetailTxView.textColor = self.hexStringToUIColor(hex: "#E0E1EB")
            
                    } else {
                        self.bookDetailImage.isHidden = true
                        self.bookDetailImage.isHidden = false
                        
                        self.bookDetailDailyTitle.text = ""
                        self.bookDetailDailyImage.isHidden = true
                        
                        self.view.backgroundColor = self.hexStringToUIColor(hex: self.bookDetailModel?.bookPage?.qnaBackgroundColor ?? "")
                        self.bookDetailQuestionTxView.text = "Q. \(self.bookDetailModel?.bookPage?.qnaQuestion ?? "")"
                        self.bookDetailTxView.text = self.bookDetailModel?.bookPage?.contents ?? ""
                        self.bookDetailTxView.textColor = self.hexStringToUIColor(hex: "#3E4048")
                        var imgInsert = self.bookDetailModel?.bookPage?.qnaQuestionID ?? ""
                        self.bookDetailImage.image = UIImage(named: imgInsert)
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
    
    func getRightPage() {
        
        let token = UserDefaults.standard.value(forKey:"token") as! String
        
        print("⭐️bookCurrentPage:\(self.bookCurrentPage)")
        
        let url = "https://dev.joeywrite.shop/app/autobiographies/\(bookId)/pages/\(self.bookCurrentPage)"
        
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : token
        ]

        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result {
            case .success(_):
             
                do {
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    
                    // JSON디코더 사용
                    print("⭐️bookDetailModel:\(dataJSON)")
                    self.bookDetailModel = try JSONDecoder().decode(BookPage.self, from: dataJSON)
                    
                    print("⭐️bookDetailModel:\(self.bookDetailModel)")
                    
                    // 일상 조건문
                    if self.bookDetailModel?.bookPage?.filterID! == "e" {
                        
                    let imgInfo  = self.bookDetailModel?.bookPage?.dailyImage ?? ""

                    if imgInfo != nil {
                        if let imageURL = self.bookDetailModel?.bookPage?.dailyImage {
                            guard let url = URL(string: imageURL) else {
                                return
                            }
                            self.bookDetailDailyImage.kf.indicatorType = .activity
                            self.bookDetailDailyImage.kf.setImage(
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
                        self.bookDetailImage.isHidden = true
                        self.bookDetailDailyImage.isHidden = false
                        
                        self.bookDetailQuestionTxView.text = ""
                        self.bookDetailDailyTitle.text = self.bookDetailModel?.bookPage?.dailyTitle
                        self.bookDetailTxView.text = self.bookDetailModel?.bookPage?.contents ?? ""
                        self.bookDetailTxView.textColor = self.hexStringToUIColor(hex: "#E0E1EB")
            
                    } else {
                        self.bookDetailImage.isHidden = false
                        
                        self.bookDetailDailyTitle.text = ""
                        self.bookDetailDailyImage.isHidden = true
                        
                        self.view.backgroundColor = self.hexStringToUIColor(hex: self.bookDetailModel?.bookPage?.qnaBackgroundColor ?? "")
                        self.bookDetailQuestionTxView.text = "Q. \(self.bookDetailModel?.bookPage?.qnaQuestion ?? "")"
                        self.bookDetailTxView.text = self.bookDetailModel?.bookPage?.contents ?? ""
                        self.bookDetailTxView.textColor = self.hexStringToUIColor(hex: "#3E4048")
                        var imgInsert = self.bookDetailModel?.bookPage?.qnaQuestionID ?? ""
                        self.bookDetailImage.image = UIImage(named: imgInsert)
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
