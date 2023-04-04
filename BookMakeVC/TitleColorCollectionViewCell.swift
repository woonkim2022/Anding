//
//  TitleColorCollectionViewCell.swift
//  Anding
//
//  Created by woonKim on 2022/11/08.
//

import Foundation
import UIKit

class TitleColorCollectionViewCell: UICollectionViewCell {
    
    var titleColor = BookMakeTitleColor()
    var index : Int = 0
    var isTag = false

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    static let identifier = "TitleColorCollectionViewCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "TitleColorCollectionViewCell", bundle: nil)
    }
    
    override var isSelected: Bool {
        
           didSet {
                   if isSelected {
                       imgView.image = titleColor.titleColorSelected[index]
                   } else {
                       imgView.image = titleColor.titleColor[index]
                   }
            }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
