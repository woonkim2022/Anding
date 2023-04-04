//
//  ScrapVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/04.
//

import Foundation
import UIKit

class ScrapVC :UIViewController{
    
    @IBOutlet weak var closeBtn: UIImageView!
    @IBOutlet weak var editBtn: UIImageView!
    @IBOutlet weak var titleText: UILabel!

    
    @IBOutlet weak var delBtn: UIImageView!
    
    @IBAction func delBtn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        
        titleText.text = "나의 스크랩북"
        
        //닫기
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(btnAlltag(tapGestureRecognizer:)))
        closeBtn.addGestureRecognizer(tapImageViewRecognizer)
        closeBtn.isUserInteractionEnabled = true

        //기본세팅
        self.titleText.text = "나의 스크랩북"
    }
    

    
    @objc func editBtnAction(tapGestureRecognizer: UITapGestureRecognizer){
          // 수정버튼
            self.titleText.text = "삭제할 기록을 선택해주세요"
            self.editBtn.isHidden = true
            self.delBtn.isHidden = false
    }
    
    
    @objc func btnAlltag(tapGestureRecognizer: UITapGestureRecognizer){
          // 닫기 버튼
         dismiss(animated: true, completion: nil)
      }
 

    
}
