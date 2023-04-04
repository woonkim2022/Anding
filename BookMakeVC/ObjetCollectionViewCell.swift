//
//  ObjetCollectionViewCell.swift
//  Anding
//
//  Created by woonKim on 2022/11/04.
//

import Foundation
import UIKit

class ObjetCollectionViewCell: UICollectionViewCell {
    
    var objet = BookMakeObjet()
    var index : Int = 0
    var isTag = false

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    static let identifier = "ObjetCollectionViewCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "ObjetCollectionViewCell", bundle: nil)
    }
    
    override var isSelected: Bool {
        
           didSet {
                   if isSelected {
                       imgView.image = objet.ObjetImageOn[index]
                   } else {
                       imgView.image = objet.ObjetImageOff[index]
                   }
               }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
