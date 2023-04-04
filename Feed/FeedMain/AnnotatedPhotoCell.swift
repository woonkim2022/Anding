
import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
  
  @IBOutlet weak var containerView: UIView!
    
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var captionLabel: UILabel!
  @IBOutlet weak var bgView: UIView!

    //쎌 피드쏄안에 있음 셀스토리보드따로없음
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }

}
