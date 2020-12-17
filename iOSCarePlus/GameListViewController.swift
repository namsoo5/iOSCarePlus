//
//  GameListViewController.swift
//  iOSCarePlus
//
//  Created by 남수김 on 2020/12/16.
//

import Alamofire
import UIKit

class GameListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let getNewGameList: String = "https://ec.nintendo.com/api/KR/ko/search/new?count=30&offset=0"
    var model: NewGameResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameListAPICall()
    }
    
    private func newGameListAPICall() {
        AF.request(getNewGameList).responseJSON { [weak self] response in
            guard let data = response.data else { return }
            
            let decoder: JSONDecoder = JSONDecoder()
            self?.model = try? decoder.decode(NewGameResponse.self, from: data)
        }
    }
}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.contents.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // !로하는이유는 우리는 이타입이 있다는것을 확실히 알고있고 만약 문제가있다면 바로 피드백을 받는게 좋음
        guard let content = model?.contents[indexPath.row] else { return .init() }
        let cell: GameItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GameItemTableViewCell", for: indexPath) as! GameItemTableViewCell
        
        // 서버 변경시 다 변경해야하는 불편함 -> 최소한의 코드만 변경하기위해서 모델을 새로 정의하여 랩핑하는 방식을 사용
        let model: GameItemModel = GameItemModel(gameTitle: content.formalName,
                                                 gameOriginPrice: 1_000,
                                                 gameDiscountPrice: nil,
                                                 imageURL: content.heroBannerURL)
        cell.setModel(model)
        return cell
    }
}
