//
//  ArchiveVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/06.
//

import Foundation
import UIKit
import Tabman
import Pageboy

class ArchiveVC : UIViewController {
    
    @IBOutlet weak var tabArea: UIView!
    
    @IBAction func bookmakeBtn(_ sender: Any) {
        
        let vc = UIStoryboard(name:"BookMakeVC" , bundle: nil).instantiateViewController(withIdentifier: "BookMakeVC") as! BookMakeVC
        
        vc.modalPresentationStyle = .popover
       
        self.present(vc, animated: true){ }
    }
    
    //MARK: - 검색창띄우기
    @IBAction func searchBtn(_ sender: Any) {
        // 피드상세페이지띄우기
        let vc = UIStoryboard(name:"SearchVC" , bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true){ }
    }
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
          
        
      }
}

