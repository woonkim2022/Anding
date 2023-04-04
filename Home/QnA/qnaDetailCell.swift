//
//  qnaDetailCell.swift
//  Anding
//
//  Created by 이청준 on 2022/10/10.
//

import UIKit

class qnaDetailCell: UITableViewCell {
    

    @IBOutlet weak var tagText: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var tagImg: UIImageView!
    //문답별이미지적용
    @IBOutlet weak var color: UIView!
    @IBOutlet weak var QsImg: UIImageView!
    
    static let identifier = "qnaDetailCell"
    static func nib()-> UINib{
          return UINib(nibName: "qnaDetailCell", bundle: nil)
      }
      
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupLayout() {
        color.layer.cornerRadius = 6
        color.layer.masksToBounds = true
      }
    
}
