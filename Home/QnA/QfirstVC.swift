//
//  QfirstVC.swift
//  Anding
//
//  Created by 이청준 on 2022/10/08.
//

import Foundation
import UIKit
import Alamofire

class QfirstVC :UIViewController, UIColorPickerViewControllerDelegate{
    
    var topic = Topic()
    var placeHolderText = "내용입력"
    var qnaword: String?//선택한질문
    var ftID: String? //필터아이디
    var ftqID: String?//문답아이디
    var QnAList = [String]()
    var bgColor = ""
    var BGcolor = ""
    var Qword = ""
    var tofillterID = ""
    var FTID = ""
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topicTitle: UITextView!
    @IBOutlet weak var tagImg: UIImageView! // 가져오기
    @IBOutlet weak var nextBtn: UIStackView!
    @IBOutlet weak var topicBox: UIView! // 컬러,테두리 가져오기
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
        self.dismiss(animated: true, completion: nil)//뷰컨닫기
    }
    
    
    @objc func dismissMyKeyboard() {
          view.endEditing(true)
      }

    override func viewDidLoad() {
        //키보드
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
         let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
         let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
         toolbar.setItems([flexSpace, doneBtn], animated: false)
         toolbar.sizeToFit()
         self.textView.inputAccessoryView = toolbar


        //다음버튼
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextBtnAction))
        nextBtn.addGestureRecognizer(tapGestureRecognizer)
        
        textViewSetupView()
//        addColorWell()
        topicBox.cournerRound12()
        topicBox.outLineBlueRound()
        topicTitle.text = qnaword
        tofillterID = ftID ?? "d"
        
        
        //상단태그이미지 // 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
        if ftID == "d"{
            tagImg.image = UIImage(named: "EndTag")//마무리
            topicBox.layer.backgroundColor =  self.topic.boxColor[0]
            topicBox.layer.borderColor = self.topic.boxBorder[0]
        }else if(ftID == "b"){
            tagImg.image = UIImage(named: "BucketTag")//버킷
            topicBox.layer.backgroundColor =  self.topic.boxColor[2]
            topicBox.layer.borderColor = self.topic.boxBorder[2]
        }else if(ftID == "r"){
            tagImg.image = UIImage(named: "RelationshipTag")//관계
            topicBox.layer.backgroundColor =  self.topic.boxColor[1]
            topicBox.layer.borderColor = self.topic.boxBorder[1]
        }else if(ftID == "f"){
            tagImg.image = UIImage(named: "FamilyTag")//가족
            topicBox.layer.backgroundColor =  self.topic.boxColor[4]
            topicBox.layer.borderColor = self.topic.boxBorder[4]
        }else if(ftID == "s"){
            tagImg.image = UIImage(named: "secretTag")//비밀
            topicBox.layer.backgroundColor =  self.topic.boxColor[3]
            topicBox.layer.borderColor = self.topic.boxBorder[3]
        }else if(ftID == "m"){
            tagImg.image = UIImage(named: "MemoryTag")//기억
            topicBox.layer.backgroundColor =  self.topic.boxColor[5]
            topicBox.layer.borderColor = self.topic.boxBorder[5]
        }else if(ftID == "i"){
            tagImg.image = UIImage(named: "MyTag")//사용자가작성한질문
            topicBox.layer.backgroundColor =  self.topic.boxColor[6]
            topicBox.layer.borderColor = self.topic.boxBorder[6]
        }

        // QnAList:["b", "꼭 만나보고 싶은 사람이 있나요?", "b-3"]
        //홈에서받아온 필터아이디,배경컬러,질문작성내용
        print("ftID:\(self.ftID ?? "문답필터못가져옴")")
        print("qftID:\(self.ftID ?? "문답아이디못가져옴")")
        // QnAList리스트에 담기
//        QnAList.append(ftID ?? "문답필터못가져옴")//0
//        QnAList.append(qnaword ?? "질문없음")//1
//        QnAList.append(ftqID ?? "문답아이디못가져옴")//2
//        print("QfirstVC - QnAList:\(QnAList)")
    }

    
    
    // 컬러피커
    @IBAction func bgColorAction(_ sender: Any) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.supportsAlpha = false
        colorPickerVC.isModalInPresentation = true
        present(colorPickerVC, animated: true)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
           let color = viewController.selectedColor
           self.contentView.backgroundColor = color
           self.view.backgroundColor = color
           bgColor = hexStringFromColor(color:self.view.backgroundColor!)
       }
       
       func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
           let color = viewController.selectedColor
           self.contentView.backgroundColor = color
           self.view.backgroundColor = color
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
    
    
    // MARK: -  NextBtn
    @objc func nextBtnAction(sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name:"QnAdetailVC" , bundle: nil).instantiateViewController(withIdentifier: "QnAdetailVC") as! QnAdetailVC
        
        if (textView.text != nil && textView.text != placeHolderText){
    
            vc.contentsText = textView.text
            vc.BGcolor = bgColor
            vc.Qword = qnaword ?? ""
            vc.ftID = FTID
            vc.ftqID = ftqID ?? ""
            
            // 문답내용
            self.present(vc, animated: true){ }
        }else{
            print("입력값없음 안넘어감")
        }
    }
}


// MARK: - 텍스트뷰
extension QfirstVC : UITextViewDelegate, UITextFieldDelegate {
    
    // 편집이 시작될때
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.gray
    }
    
    // 편집이 종료될때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textViewSetupView()
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//           view.endEditing(true)
//       }
//
       //리턴키 델리게이트 처리
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()//텍스트필드 비활성화
           return true
       }
    
    

}

