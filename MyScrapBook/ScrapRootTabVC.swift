//
//  ScrapRootTabVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/04.
//

import Foundation
import Tabman
import Pageboy
import Alamofire

class ScrapRootTabVC : TabmanViewController{
    
    var myCountModel : MyCountModel?
    var otherCountModel:OtherCountModel?
    var count = 0
    var otherCount = 0
    let scrapNoti = Notification.Name("scrapNoti")
    let scrapFeedNoti = Notification.Name("scrapFeedNoti")
   
    
    
    var viewControllers: Array<UIViewController> = []
    
    //MARK: - viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabmanSetting()
        //문답갯수가져오기
        myScrapCount()
        self.count = self.myCountModel?.result?.myPostOfClipCount ?? 0
        
        otherScrapCount()
        self.otherCount = self.otherCountModel?.result?.otherPostOfClipCount  ?? 0
        
        //노티등록
//        SetNotification()
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        
        //노티등록
//        SetNotification()
//        SetNotificationFeed()
//        print("ScrapRootTabVC 노티받음")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.count = self.myCountModel?.result?.myPostOfClipCount ?? 0
            self.otherCount = self.otherCountModel?.result?.otherPostOfClipCount  ?? 0
            
            self.reloadData()
        }
        

    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: scrapNoti, object: nil)
//    }
    
    func SetNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.update(_:)), name: scrapNoti, object: nil)
    }
    
    func SetNotificationFeed(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFeed(_:)), name: scrapFeedNoti, object: nil)
    }
    
    @objc func update(_ noti: Notification) {
        OperationQueue.main.addOperation {
            self.myScrapCount()//서버호출
            self.count = self.myCountModel?.result?.myPostOfClipCount ?? 0
            self.reloadData()
        }
    }
    
    @objc func updateFeed(_ noti: Notification) {
        OperationQueue.main.addOperation {
            self.otherScrapCount() //서버호출
            self.otherCount = self.otherCountModel?.result?.otherPostOfClipCount  ?? 0
            self.reloadData()
        }
    }
    
    //MARK: - 내스크랩갯수서버호출
    func myScrapCount() {
        let url = "https://dev.joeywrite.shop/app/posts/clip/my-post/cnt"
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
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.myCountModel = try JSONDecoder().decode(MyCountModel.self, from: dataJSON)
                    print("⭐️aqModel-count:\( self.count)")
                    
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
    
    //MARK: - 다른사람스크랩수호출
    func otherScrapCount() {
        let url = "https://dev.joeywrite.shop/app/posts/clip/other-post/cnt"
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
                
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    self.otherCountModel = try JSONDecoder().decode(OtherCountModel.self, from: dataJSON)
                    print("다른사람게시글수:\(self.otherCountModel)")
                    
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
    
    
    //MARK: - tabman
    func tabmanSetting(){
        //뷰컨2개 넣어주기
        let vc1 = UIStoryboard.init(name: "ScrapTabMyVC", bundle: nil).instantiateViewController(withIdentifier: "ScrapTabMyVC") as! ScrapTabMyVC
        let vc2 = UIStoryboard.init(name: "ScrapTabFeedVC", bundle: nil).instantiateViewController(withIdentifier: "ScrapTabFeedVC") as! ScrapTabFeedVC
        
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        self.dataSource = self
        self.isScrollEnabled = false
        
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
        bar.indicator.overscrollBehavior = .bounce//오버스크롤동작
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    
    
    
}//viewdid

extension ScrapRootTabVC: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        
        // MARK: - Tab 안 글씨들
        switch index {
            
        case 0:
            let item = TMBarItem(title: "")
            item.title = "내가 기록한 \(count)"
            return item
            
        case 1:
            
            let item = TMBarItem(title: "")
            item.title = "피드에서 저장한 \(otherCount)"
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
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
