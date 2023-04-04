//
//  rootTabVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/31.
//

import Foundation
import UIKit
import Tabman
import Pageboy
import Alamofire

class rootTabVC : TabmanViewController{
    
    var aQcountModel:AQcountModel?
    var aRcountModel:ARcountModel?
    var qcount = 0
    var rcount = 0
    let plist = UserDefaults.standard
    var viewControllers: Array<UIViewController> = []
    
    
    //MARK: - viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabmanSetting()
        //일상갯수가져오기
        rCount()
        rcount =  self.aRcountModel?.result?.dailyPostCount ?? 0
        
        //문답갯수가져오기
        qCount()
        qcount =  self.aQcountModel?.result?.qnaPostCount ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            //일상게시글 갯수
            self.rcount =  self.aRcountModel?.result?.dailyPostCount ?? 0
            //문답게시글 갯수
            self.qcount = self.aQcountModel?.result?.qnaPostCount ?? 0
            self.reloadData()
        }
    }
    
    
    // 문답게시글갯수
    func qCount() {
        let url = "https://dev.joeywrite.shop/app/archives/qna-post/cnt"
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
                    
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.aQcountModel = try JSONDecoder().decode(AQcountModel.self, from: dataJSON)
                    
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
    
    
    // 일상게시글갯수
    func rCount() {
        let url = "https://dev.joeywrite.shop/app/archives/daily-post/cnt"
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
                    
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.aRcountModel = try JSONDecoder().decode(ARcountModel.self, from: dataJSON)
                    
                }
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
    
    
    //MARK: - tabman
    func tabmanSetting(){
        //뷰컨2개 넣어주기
        let vc1 = UIStoryboard.init(name: "tabFirstVC", bundle: nil).instantiateViewController(withIdentifier: "tabFirstVC") as! tabFirstVC
        let vc2 = UIStoryboard.init(name: "tabSecondVC", bundle: nil).instantiateViewController(withIdentifier: "tabSecondVC") as! tabSecondVC
        
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        self.dataSource = self
        self.isScrollEnabled = false //스와이프금지
        
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.backgroundView.style = .clear
        
        bar.layout.contentMode = .fit
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // 버튼컬러
        bar.buttons.customize { (button) in
            button.tintColor = .gray
            button.selectedTintColor = .white
        }
        //인디케이터
        bar.indicator.tintColor = UIColor(displayP3Red: 126/255, green: 115/255, blue: 255/255, alpha: 1)//선택바컬러
        //        bar.indicator.overscrollBehavior = .bounce//오버스크롤동작
        bar.indicator.overscrollBehavior = .compress
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
}//viewdid

extension rootTabVC: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        
        // MARK: - Tab 안 글씨들
        switch index {
            
        case 0:
            let item = TMBarItem(title: "")
            item.title = "문답\(qcount)"
            return item
            
        case 1:
            
            let item = TMBarItem(title: "")
            item.title = "일상\(rcount)"
            return item
            
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    //    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
    //        return nil
    //    }
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        
        return nil
        
//        let num = plist.string(forKey: "Tab")
        
//        if num == "0" {
//            return .at(index: 0)
//        }else{
//            return .at(index: 1)
//        }
    }
}
