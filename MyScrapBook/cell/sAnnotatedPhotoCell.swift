//
//  sAnnotatedPhotoCell.swift
//  Anding
//
//  Created by 이청준 on 2022/11/04.
//

import UIKit
class sAnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var seleteView: UIView!
    @IBOutlet weak var cellCount: UILabel!
    @IBOutlet weak var circle: UIImageView!
    var index : Int = 0
    var num : Int = 1
    
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
    
    
    //쎌 피드쏄안에 있음 셀스토리보드따로없음
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
}
