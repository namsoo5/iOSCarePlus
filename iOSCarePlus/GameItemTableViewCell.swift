//
//  GameItemTableViewCell.swift
//  iOSCarePlus
//
//  Created by 남수김 on 2020/12/16.
//

import Alamofire
import Kingfisher
import UIKit

class GameItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var gameCurrentPriceLabel: UILabel!
    @IBOutlet private weak var gameOriginPriceLabel: UILabel!
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var gameImageView: UIImageView!
    private var model: GameItemModel? {
        didSet {
            setUIFromModel()
        }
    }
    private let getGamePriceURL: String = "https://api.ec.nintendo.com/v1/price"
    
    func setModel(_ model: GameItemModel) {
        self.model = model
    }
    
    // 함수의 기능은 한가지만해야하므로 데이터 넣어주는 로직은 따로 구성한다
    func setUIFromModel() {
        guard let model = model else { return }
        
        let imageURL: URL? = URL(string: model.imageURL)
        gameImageView.kf.setImage(with: imageURL)
        
        gameImageView.layer.cornerRadius = 9
        gameImageView.layer.borderWidth = 1
        gameImageView.layer.borderColor = UIColor(red: 236 / 255.0, green: 236 / 255.0, blue: 236 / 255.0, alpha: 1).cgColor
        
        gameTitleLabel.text = model.gameTitle
        gameOriginPriceLabel.text = "\(model.gameOriginPrice)"
        if let discount: Int = model.gameDiscountPrice {
            gameCurrentPriceLabel.text = "\(discount)"
        } else {
            gameCurrentPriceLabel.isHidden = true
        }
    }
    
    /*
    private func  gamePriceAPICall(id: Int) {
        // "?country=KR&ids=\(id)&lang=ko"
        AF.request(getGamePriceURL,
                   method: .get,
                   parameters: ["country": "KR", "id": "\(id)", "lang": "ko"])
            .response { response in
                guard let data = response.data else { return }
                
                let decoder: JSONDecoder = JSONDecoder()
//                self?.model = try? decoder.decode(.self, from: data)
            }
    }
 */
}
