//
//  IndicatorCell.swift
//  iOSCarePlus
//
//  Created by 남수김 on 2020/12/23.
//

import UIKit

class IndicatorCell: UITableViewCell {
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    func animationIndicatorView() {
        indicatorView.startAnimating()
    }
}
