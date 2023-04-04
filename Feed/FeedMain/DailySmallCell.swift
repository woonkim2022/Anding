//
//  DailySmallCell.swift
//  Anding
//
//  Created by 이청준 on 2022/10/29.
//

import UIKit

class DailySmallCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }

}
