//
//  Collection.swift
//  Anding
//
//  Created by woonKim on 2022/11/02.
//

import Foundation
import UIKit

struct TitleColorCollection {
    let image: UIImage?
}

let titleColorImg: [TitleColorCollection] = [TitleColorCollection(image: UIImage(named: "TitleColorRed")),
                                             TitleColorCollection(image: UIImage(named: "TitleColorOrange")),
                                             TitleColorCollection(image: UIImage(named: "TitleColorYellow")),
                                             TitleColorCollection(image: UIImage(named: "TitleColorGreen")),
                                             TitleColorCollection(image: UIImage(named: "TitleColorBlue")),
                                             TitleColorCollection(image: UIImage(named: "TitleColorPurple")),
                                             TitleColorCollection(image: UIImage(named: "TitleColorBlack"))
                    ]

struct MaterialCollection {
    let title: String?
    let image: UIImage?
}

let categoryD: [MaterialCollection] = [MaterialCollection(title: "공지", image: UIImage(named: "categoryD")),
]
