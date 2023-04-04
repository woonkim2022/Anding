//
//  BookMakeChapterCollectionView.swift
//  Anding
//
//  Created by woonKim on 2022/10/25.
//

import Foundation
import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {
    
    var topic = ChapterTopic()
    var index : Int = 0
    var isTag = false

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    static let identifier = "ChapterCollectionViewCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "ChapterCollectionViewCell", bundle: nil)
    }
    
    override var isSelected: Bool {
        
           didSet {
                   if isSelected {
                       imgView.image = topic.TopicImageOn[index]
                   } else {
                        imgView.image = topic.TopicImageOff[index]
                   }
               }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
