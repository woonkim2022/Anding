//
//  UIPopScarpDelVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/09.
//

import Foundation
import UIKit

class ScarpDelVC :UIViewController{
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var whiteBg: UIView!
    var number: String?
    var errorMsg :String?

    override func viewDidLoad() {
        
        whiteBg.cournerRound12()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        bgView.addGestureRecognizer(tapGestureRecognizer)
//        text.text = "총 \(number ?? "0")개의 기록이 삭제되었어요."
        text.text = "스크랩이 삭제되었어요."
    }
    
    // 저장완료팝업
    @objc func closePopup(sender: UITapGestureRecognizer){
        //창모두닫기
//        closeAllwindow()
        
        // 저장팝업만닫기
        dismiss(animated: true,completion: nil)
    }

 
    
//    func closeAllwindow(){
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
//
//            // 아래스택뷰모두닫기
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
//
//            // This is to get the SceneDelegate object from your view controller
//            // then call the change root view controller function to change to main tab bar
//            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
//
//        }
//    }
}
