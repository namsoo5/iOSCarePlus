//
//  SeletableButton.swift
//  iOSCarePlus
//
//  Created by 남수김 on 2021/01/06.
//

import UIKit

class SeletableButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTitleColor(UIColor(named: "black"), for: .selected)
        setTitleColor(UIColor(named: "veryLightPink"), for: .normal)
        tintColor = .clear
    }
}
