//
//  HomeCollectionViewCell.swift
//  Anding
//
//  Created by 이청준 on 2022/10/08.
//
import Foundation
import UIKit

protocol HomeCellDelegate{
    func selectBtn(Index:Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    var topic = Topic()

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    var index : Int = 0
    var delegate : HomeCellDelegate?
    var isTag = false
    
    static let identifier = "HomeCollectionViewCell"
    
    static func nib()-> UINib{
        return UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    }
    
                             
    override var isSelected: Bool{
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
        // Initialization code
        setupLayout()
        
        //셀클릭이벤트
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
        isSelected = false
        //마무리태그 하나만 눌러져있게하기???
//        isTag = true
        if isSelected == false{
            imgView.image = topic.TopicImageOn[0]
        }
    }
    
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
        self.delegate?.selectBtn(Index: index)
    }

    
       func setupLayout() {

           bgView?.layer.cornerRadius = 10
           bgView?.layer.masksToBounds = true
       }
}
