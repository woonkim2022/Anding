//
//  DailyBigCell.swift
//  Anding
//
//  Created by 이청준 on 2022/10/29.
//

import UIKit

class DailyBigCell: UICollectionViewCell {

    @IBOutlet weak var cationLabel: UILabel!
    @IBOutlet weak var dImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }

}
