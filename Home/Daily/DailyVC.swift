//
//  DailyVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/13.
//

import Foundation
import UIKit
import Alamofire

class DailyVC :UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // UI이미지 담을 변수(갤러리에서 가져온이미지)
    var newImage: UIImage? = nil
    var selectColor = ""
    var placeHolderText = "내용을 입력하세요"
    var dateString = ""
    var qnaword: String?//선택한질문
    var ftID:String? //필터아이디
    let plist = UserDefaults.standard
    var tmpContents = ""
    
    var saveImage: UIImage? = nil
    var bgColor = [String]()
    var contentsText = [String]()
    var tmpText = ""
    
    @IBOutlet weak var nextBtn: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var allView: UIView!
    @IBOutlet weak var topBg: UIView!
    @IBOutlet weak var bottomBg: UIStackView!
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.font = .systemFont(ofSize: 16)
            textView.text = placeHolderText
            textView.textColor = UIColor.gray
            textView.delegate = self
        }
    }
    @IBOutlet weak var textCount: UILabel!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    //갤러리 창
    @IBAction func pictureBtn(_ sender: Any) {
        // 기본이미지 피커 인스턴스를 생성한다.
        let picker = UIImagePickerController()
        
        picker.delegate = self // 이미지피커컨트롤러 인스턴스의 델리게이트 속성 현재뷰 컨트롤러 인스턴스로설정
        picker.allowsEditing = true // 피커이미지편집 허용
        
        // 이미지피커 화면을 표시한다.
        self.present(picker, animated: true)
    }
    
    
    
    //MARK: - viewdidload
    override func viewDidLoad() {
        textViewSetupView()
        
        // 화면이동
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextBtnAction))
        nextBtn.addGestureRecognizer(tapGestureRecognizer)
        
        //키보드
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.textView.inputAccessoryView = toolbar
    }
    
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "tmpContents")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // 이미지선택시 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 선택된이미지를 미리보기에 출력
        self.imageView.image = info[.editedImage] as? UIImage
        // 갤러리에서 받아온이미지를 글로벌변수 newImage에 넣는다.
        newImage = info[.editedImage] as? UIImage
        // print("UIImage :\(info[.editedImage] as? UIImage)")
        //갤러리에서 가져온이미지
        saveImage = newImage?.resized(toWidth: 300.0)
        
        // 이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false)
        
        
        let plist = UserDefaults.standard
        let getText = plist.string(forKey: "tmpContents")
        textView.text = getText
        reloadInputViews()
        
    }
    
    @objc func nextBtnAction(sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name:"DailyDetailVC" , bundle: nil).instantiateViewController(withIdentifier: "DailyDetailVC") as! DailyDetailVC
        
        vc.contentsText = textView.text
        //이미지넘기기
        vc.rImg = saveImage
        self.present(vc, animated: true){ }
        
    }
    
    
    
    // MARK: -  UITextView PlaceHolder 설정
    func textViewSetupView() {
        if textView.text == placeHolderText{
            textView.textColor = UIColor.gray
            
            
        } else if textView.text == "" {
            textView.text = placeHolderText
            
            textView.textColor = UIColor.gray
        }
    }
    
}




// 이미지 사이즈 줄이기
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}


// MARK: - 텍스트뷰
extension DailyVC : UITextViewDelegate, UITextFieldDelegate {
    
    // 편집이 시작될때
    func textViewDidBeginEditing(_ textView: UITextView) {
         textViewSetupView()
         textView.text = ""
        textView.textColor = UIColor.gray
    }
    
    // 편집이 종료될때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textViewSetupView()
        }else{
            //텍스트뷰에 적힌값을 임시저장하기
            tmpContents = textView.text
            plist.setValue(tmpContents, forKey: "tmpContents")//이름이라는 키로 저장
            plist.synchronize()//동기화처리
            print("텍스트저장")
        }
    }
    
    // textCount
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)-> Bool{
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in:stringRange, with: text)
        textCount.text = "\(changedText.count)/2000"
        return changedText.count <= 2000
    }
    
    //리턴키 델리게이트 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()//텍스트필드 비활성화
        return true
    }
}
