//
//  smallCell.swift
//  Anding
//
//  Created by 이청준 on 2022/10/25.
//

import UIKit

class smallCell: UICollectionViewCell {
    @IBOutlet  weak var containerView: UIView!
    @IBOutlet  weak var imageView: UIImageView!
    @IBOutlet  weak var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
}
