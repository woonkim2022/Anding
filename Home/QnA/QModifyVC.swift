//
//  QModifyVC.swift
//  Anding
//
//  Created by 이청준 on 2022/11/12.
//

import Foundation
import UIKit
import Alamofire

// 수정버튼 눌러서 이전 작성내용가져오기
class QModifyVC : UIViewController, UIColorPickerViewControllerDelegate{
    
    var postNum = 0
    var fillterID = ""
    
    var qnaModel : QnaModel?
    var scrapModel : ScrapModel?
    var topic = Topic()
    var placeHolderText = "내용입력"
    var qnaword: String?//선택한질문
    var ftID: String? //필터아이디
    var ftqID: String?//문답아이디
    var QnAList = [String]()
    var bgColor = ""
    
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
        // 서버호출
        getPostDetail(postNum)
        // 필터아이디 가져오기
        ftID = fillterID
        
        // 키보드
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.textView.inputAccessoryView = toolbar
        
        // 다음버튼
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextBtnAction))
        nextBtn.addGestureRecognizer(tapGestureRecognizer)
        
        // UI
        textViewSetupView()
        topicBox.cournerRound12()
        topicBox.outLineBlueRound()
        topicTitle.text = qnaword
        
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
    }
    
    //MARK: - 상세페이지호출
    func getPostDetail(_ postNum: Int) {
        
        let getPostNum = postNum

        let url = "https://dev.joeywrite.shop/app/posts/detail/\(getPostNum)"
        print("⭐️일상상세url호출:\(url)")
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json",
                             "Accept":"application/json"
                            ])
        .validate(statusCode: 200..<300)
        .responseJSON() { res in
            switch res.result{
            case .success(_):
                
                guard let jsonObject = try! res.result.get() as? [String :Any] else {
                    print("올바른 응답값이 아닙니다.")
                    return
                }
                
                print("서버호출")
                do{
                    // Any를 JSON으로 변경
                    let dataJSON = try JSONSerialization.data(withJSONObject:try! res.result.get(), options: .prettyPrinted)
                    // JSON디코더 사용
                    
                    self.qnaModel = try JSONDecoder().decode(QnaModel.self, from: dataJSON)
                    
                    print("⭐️qnaModel:\(self.qnaModel)")
                    
                    self.topicTitle.text = self.qnaModel?.result?.qnaQuestion ?? "문답내용" //질문아이디값받아아와서 다시뿌리기
                    self.qnaword = self.qnaModel?.result?.qnaQuestion ?? "문답내용"
                    self.textView.text = self.qnaModel?.result?.contents ?? ""
                    // getQId값에 맞는 이미지뿌리기(이미지수급시..)
                    self.ftqID = self.qnaModel?.result?.qnaQuestionID ?? "문답아이디없음"
                    
                    let getColor = self.qnaModel?.result?.qnaBackgroundColor
                    self.contentView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
                    self.bgView.backgroundColor = self.hexStringToUIColor(hex: getColor ?? "#7E73FF")
                    
                    //가지고온 bgColor다음페이지로 넘기기
                    self.bgColor = self.qnaModel?.result?.qnaBackgroundColor ?? "#7E73FF"
//                    self.dateString.text = self.qnaModel?.result?.createdAt
                    
                    let imgInsert = self.qnaModel?.result?.qnaQuestionID ?? "d-1"
//                    self.imageView.image = UIImage(named: imgInsert)
//                    self.otherNickname = self.qnaModel?.result?.nickname ?? "닉네임없음"
                   
                    
                } // 디코딩 에러잡기
                catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                
                
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
            }
        }
    }

    
    //MARK: - 서버에서 받은 헥스 스트링을 UI Color로 변환하는 함수
    func hexStringToUIColor(hex:String) -> UIColor {
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
    
    // MARK: -  colorPicker
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
        let vc = UIStoryboard(name:"QModifyInfoVC" , bundle: nil).instantiateViewController(withIdentifier: "QModifyInfoVC") as! QModifyInfoVC
        
        if (textView.text != nil && textView.text != placeHolderText){
            
            QnAList.append(ftID ?? "문답필터X")//0
            QnAList.append(qnaword ?? "질문X")//1
            QnAList.append(ftqID ?? "문답아이디X")//2
            //다음버튼누를때 내용저장
            QnAList.append(textView.text)
            // 배경 컬러값 저장하기
            QnAList.append(bgColor)
            //배열넘기기(홈에서받아온 필터아이디,배경컬러,질문작성내용,문답ID)
            vc.QnAPackage = QnAList
            vc.FeedNum = postNum
            
            print("➡️질문꾸러미:\(QnAList)")
            // 문답내용
            self.present(vc, animated: true){ }
        }else{
            print("입력값없음 안넘어감")
        }
    }
}


// MARK: - 텍스트뷰
extension QModifyVC : UITextViewDelegate, UITextFieldDelegate {
    
    // 편집이 시작될때
    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.text = ""
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
}

//UIcolor를 스트링으로
func hexStringFromColor(color: UIColor) -> String {
    let components = color.cgColor.components
    let r: CGFloat = components?[0] ?? 0.0
    let g: CGFloat = components?[1] ?? 0.0
    let b: CGFloat = components?[2] ?? 0.0
    
    let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    print(hexString)
    return hexString
}


