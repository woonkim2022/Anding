//
//  BookMakeVC2.swift
//  Anding
//
//  Created by woonKim on 2022/10/31.
//

import UIKit

class BookMakeVC2: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIColorPickerViewControllerDelegate {
    
    let line1Img = UIImage(named: "BookMake2Line1")
    let bookCoverLineImg = UIImage(named: "BookCoverLine")
    let bookCoverObjetImg = UIImage(named: "Objet")
  
    var titleTxViewDefault = ""
    var titleColor: UIColor?
    
    var titleColorPick = BookMakeTitleColor()
    
    var cellClickCount = 0
    
    var postIds: [Int] = []
    
    var bookTotalPage = 0

    @IBOutlet weak var bookCoverColor: UIButton!
    
    @IBOutlet weak var bookCover: UIView!
    @IBOutlet weak var pickTitleTextColor: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var line1: UIImageView!
    @IBOutlet weak var bookCoverLine: UIImageView!
    @IBOutlet weak var bookCoverObjet: UIImageView!
    
    @IBOutlet weak var titleTxView: UITextView!
    @IBOutlet weak var inputTxView: UITextView!

    @IBOutlet weak var titleColorCollectionView: UICollectionView!
    
    @IBOutlet weak var backTapView: UIView!
    
    // UI View에 백그라운드 이미지 넣기
//    var imageView: UIImageView = {
//         let imageView = UIImageView(frame: .zero)
//         imageView.image = UIImage(named: "BookCustomizeCover")
//         imageView.contentMode = .scaleToFill
//         imageView.translatesAutoresizingMaskIntoConstraints = false
//         return imageView
//     }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // 백 버튼 뷰
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))

        // 백 버튼 뷰
        backTapView.addGestureRecognizer(tapGesture)
        
        line1.image = line1Img
        bookCoverLine.image = bookCoverLineImg
        
        // UI View에 백그라운드 이미지 넣기
//        bookCover.insertSubview(imageView, at: 0)
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: bookCover.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: bookCover.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: bookCover.trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: bookCover.bottomAnchor)
//        ])
        bookCoverObjet.image = bookCoverObjetImg
        titleTxViewDefault = titleTxView.text
        
        bookCover.layer.cornerRadius = 5.26316
        bookCover.backgroundColor = hexStringToUIColor(hex: "#7E73FF")
        
        inputTxView.delegate = self
        inputTxView.layer.cornerRadius = 6
        inputTxView.layer.borderWidth = 1
        inputTxView.layer.borderColor = UIColor.white.cgColor
        inputTxView.textColor = .white
        inputTxView.autocorrectionType = .no
        inputTxView.textContainerInset = UIEdgeInsets(top: 20, left: 8, bottom: 15, right: 15)
    
        titleTxView.textContainer.maximumNumberOfLines = 3
        
        pickTitleTextColor.layer.cornerRadius = 6
        pickTitleTextColor.layer.borderWidth = 1
        pickTitleTextColor.layer.borderColor = UIColor.white.cgColor
        
        let nibName = UINib(nibName: "TitleColorCollectionViewCell", bundle: nil)
        titleColorCollectionView.register(nibName, forCellWithReuseIdentifier:"TitleColorCollectionViewCell")
        
        titleColorCollectionView.delegate = self
        titleColorCollectionView.dataSource = self
        titleColorCollectionView.tag = 1
        titleColorCollectionView.collectionViewLayout =
        createLayoutTitleColorCollectionView()
    }
    
    

    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookMakeVC3") as? BookMakeVC3 else {
            return
        }
        vc.postIds = postIds
        vc.titleViewTxFromBookMake2 = titleTxView.text
        vc.bookCoverColorFromBookMake2 = bookCover.backgroundColor
        vc.titleColorFromBookMake2 = titleTxView.textColor
        vc.bookTotalPage = bookTotalPage
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        titleTxView.text = inputTxView.text
        
        if inputTxView.text == "" {
            titleTxView.text = titleTxViewDefault
        }
        print(inputTxView.text!.count)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            
        inputTxView.text = ""
    }
    
    @objc func dismissMyKeyboard() {
           view.endEditing(true)
       }
       

    
    private func createLayoutTitleColorCollectionView() -> UICollectionViewCompositionalLayout {

        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.99), heightDimension: .fractionalHeight(0.99)), subitem: item, count: 8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 7, trailing: 0)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
        // return
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @IBAction func bookCoverColorPickBtn(_ sender: Any) {
        
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.title = "자서전 표지 색상"
        colorPickerVC.delegate = self
        colorPickerVC.supportsAlpha = false
        colorPickerVC.isModalInPresentation = true
        present(colorPickerVC, animated: true)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        bookCover.backgroundColor = color
        
        print("백그라운드hexStringFromColor\(hexStringFromColor(color: bookCover.backgroundColor!))")
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        bookCover.backgroundColor = color
    }
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}

extension BookMakeVC2: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 상단컬렉션뷰 셀설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titleColorPick.titleColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        if indexPath.row == 0 {
            titleTxView.textColor = hexStringToUIColor(hex: "#FFFFFF")
        }
        else if indexPath.row == 1 {
            titleTxView.textColor = hexStringToUIColor(hex: "#D56666")
        } else if indexPath.row == 2 {
            titleTxView.textColor = hexStringToUIColor(hex: "#FF9D73")
        } else if indexPath.row == 3 {
            titleTxView.textColor = hexStringToUIColor(hex: "#FFF386")
        } else if indexPath.row == 4 {
            titleTxView.textColor = hexStringToUIColor(hex: "#5EE69C")
        } else if indexPath.row == 5 {
            titleTxView.textColor = hexStringToUIColor(hex: "#4462FF")
        } else if indexPath.row == 6 {
            titleTxView.textColor = hexStringToUIColor(hex: "#7E73FF")
        } else if indexPath.row == 7 {
            titleTxView.textColor = hexStringToUIColor(hex: "#000000")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleColorCollectionViewCell.identifier, for: indexPath) as! TitleColorCollectionViewCell
            
        cell.index = indexPath.row
        
        // 기본이 딤드되어있고, 누르면 On되는 상태
        cell.imgView.image = self.titleColorPick.titleColor[indexPath.row]
        
        // 스크롤 사용해도 선택한 버튼 안풀리게
        if indexPath.row == 1 {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
}



// 키보드 숨기기
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
