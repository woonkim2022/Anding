//
//  UIBox.swift
//  Anding
//
//  Created by 이청준 on 2022/10/10.
//

import Foundation
import UIKit

extension UIView{
    
    func outLineBlueRound(){
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(displayP3Red: 98/255, green: 152/255, blue: 255/255, alpha: 1).cgColor
        self.layer.cornerRadius = 6
    }
    
    func mainColorBlue(){
        self.backgroundColor = UIColor(argb:0x6298FF)
    }
    
    func cournerRound12(){
        self.layer.cornerRadius = 12
    }
    
    func cournerRound6(){
        self.layer.cornerRadius = 6
    }
    
    func bgColorGray(){
        self.backgroundColor = UIColor(argb:0x3E4048)
    }
    
    func mainColorPurple(){
        self.backgroundColor = UIColor(argb:0x7E73FF)
    }
    
    
}
