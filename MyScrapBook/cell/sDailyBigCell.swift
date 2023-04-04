//
//  sDailyBigCell.swift
//  Anding
//
//  Created by 이청준 on 2022/11/04.
//

import UIKit

class sDailyBigCell: UICollectionViewCell {

    @IBOutlet weak var cationLabel: UILabel!
    @IBOutlet weak var dImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seleteView: UIView!
    @IBOutlet weak var checkMark: UIImageView!
    
    var clickCount: Int = 0 {
        didSet {
            // 0 - 기본값
            if clickCount == 0 {
                seleteView.isHidden = true
                checkMark.isHidden = true
                seleteView.layer.borderWidth = 0
                seleteView.layer.cornerRadius = 6
            }
            else {
                // 1 - 선택한것(딤드+테두리)
                seleteView.isHidden = false
                checkMark.isHidden = false
                seleteView.layer.borderWidth = 1
                seleteView.layer.borderColor = UIColor.white.cgColor
                seleteView.layer.cornerRadius = 6
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    

}
