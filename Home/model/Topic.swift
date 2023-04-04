//
//  Topic.swift
//  Anding
//
//  Created by 이청준 on 2022/10/09.
//

import Foundation
import UIKit

class Topic {
    
    // 마무리, 관계, 버킷리스트,비밀, 가족, 기억, 사용자
    var categoryID = ["d","r","b","s","f","m","i"]
    
    //홈화면메인태그off
    var TopicImageOff =  [UIImage(named: "EndTag_d"),
                          UIImage(named: "RelationshipTag_d"),
                          UIImage(named: "BucketTag_d"),
                          UIImage(named: "secretTag_d"),
                          UIImage(named: "FamilyTag_d"),
                          UIImage(named: "MemoryTag_d"),
                          UIImage(named: "MyTag_d")
    ]
    //홈화면메인태그on
    var TopicImageOn =  [UIImage(named: "EndTag"),
                         UIImage(named: "RelationshipTag"),
                         UIImage(named: "BucketTag"),
                         UIImage(named: "secretTag"),
                         UIImage(named: "FamilyTag"),
                         UIImage(named: "MemoryTag"),
                         UIImage(named: "MyTag")
    ]
    //홈화면메인태그on 하단썸네일
    var sTagImg =  [UIImage(named: "EndTag"),
                    UIImage(named: "RelationshipTag"),
                    UIImage(named: "BucketTag"),
                    UIImage(named: "secretTag"),
                    UIImage(named: "FamilyTag"),
                    UIImage(named: "MemoryTag"),
                    UIImage(named: "MyTag")
    ]
    
    // 메인비주얼
    // 마무리, 관계, 버킷리스트, 비밀, 가족, 기억, 자기
    var TopicImg =     [UIImage(named: "TopicEnd"),//마무리
                      UIImage(named: "TopicRelationship"),//관계
                      UIImage(named: "TopicBucket"),//버킷리스트
                      UIImage(named: "TopicSecret"), //비밀
                      UIImage(named: "TopicFamily"),//가족
                      UIImage(named: "TopicMemory"),//기억
                      UIImage(named: "TopicForMe")//사용자작성
    ]
    
    
    var boxColor =   [ UIColor(red: 0.383, green: 0.596, blue: 1, alpha: 0.3).cgColor,
                     UIColor(red: 0.949, green: 0.639, blue: 0.369, alpha: 0.3).cgColor,
                     UIColor(red: 0.314, green: 0.749, blue: 0.624, alpha: 0.3).cgColor,
                     UIColor(red: 0.904, green: 0.351, blue: 0.418, alpha: 0.3).cgColor,
                     UIColor(red: 0.537, green: 0.6, blue: 0.651, alpha: 0.3).cgColor,
                     UIColor(red: 0.533, green: 0.471, blue: 0.749, alpha: 0.3).cgColor,
                     UIColor(red: 0.851, green: 0.549, blue: 0.627, alpha: 0.3).cgColor]
    
    var boxBorder =    [ UIColor(red: 0.383, green: 0.596, blue: 1, alpha: 1).cgColor,
                       UIColor(red: 0.949, green: 0.639, blue: 0.369, alpha: 1).cgColor,
                       UIColor(red: 0.314, green: 0.749, blue: 0.624, alpha: 1).cgColor,
                       UIColor(red: 0.904, green: 0.351, blue: 0.418, alpha: 1).cgColor,
                       UIColor(red: 0.537, green: 0.6, blue: 0.651, alpha: 1).cgColor,
                       UIColor(red: 0.533, green: 0.471, blue: 0.749, alpha: 1).cgColor,
                       UIColor(red: 0.851, green: 0.549, blue: 0.627, alpha: 1).cgColor]
    
}
