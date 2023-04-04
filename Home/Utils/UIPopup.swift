//
//  UIPopup.swift
//  Anding
//
//  Created by 이청준 on 2022/10/11.
//

import UIKit
import Foundation

class UIPopup: UIViewController {

    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var Ptitle: UILabel!
    @IBOutlet weak var decTitle: UILabel!
    
    var Ptext:String?
    var PdecText:String?
    var Qtext:String?
    var QdecText:String?
    var FeedDetailSaveText:String?
    var FeedDetailSaveTextQdecText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.cournerRound12()
        
        // 넘겨받은문구 설정
        if (Ptext != nil){
            // 홈일상등록시 기록저장문구
            Ptitle.text = Ptext
            decTitle.text = PdecText
        }else{
            // 디폴트문구
            Ptitle.text = "문답이 저장되었습니다."
            decTitle.text = "문답을 모아서 자서전을 만들 수 있어요:)"
        }
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        blackView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc func closePopup(sender: UITapGestureRecognizer){
        //창모두닫기
        closeAllwindow()
    }

    func closeAllwindow(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           
            // 아래스택뷰모두닫기
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
    }
    
}
