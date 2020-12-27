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
    private var getNewGameListURL: String {
            "https://ec.nintendo.com/api/KR/ko/search/new?count=\(newCount)&offset=\(newOffset)"
    }
    private var newCount: Int = 10
    private var newOffset: Int = 0
    var model: NewGameResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    private var isEnd: Bool = false
//    private var isEnd: Bool {
//        model?.contents.count == model?.total
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameListAPICall()
    }
    
    private func newGameListAPICall() {
        AF.request(getNewGameListURL).responseJSON { [weak self] response in
            guard let data = response.data else { return }
            
            let decoder: JSONDecoder = JSONDecoder()
            guard let model: NewGameResponse = try? decoder.decode(NewGameResponse.self, from: data) else {
                return
            }
            if self?.model == nil {
                self?.model = model
            } else {
                if model.contents.isEmpty {
                    self?.isEnd = true
                }
                self?.model?.contents.append(contentsOf: model.contents)
            }
        }
    }
    
    private func isIndicatorCell(_ indexPath: IndexPath) -> Bool {
        indexPath.row == model?.contents.count
    }
}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEnd {
            return (model?.contents.count ?? 0)
        } else {
            guard model != nil else { return 0 } // 통신 전에 셀이 1개 그려지는 현상 방지
            
            return (model?.contents.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isIndicatorCell(indexPath) {
            guard let cell: IndicatorCell = tableView.dequeueReusableCell(withIdentifier: "IndicatorCell", for: indexPath) as? IndicatorCell else {
                return .init()
            }
            cell.animationIndicatorView()
            return cell
        }
        
        // !로하는이유는 우리는 이타입이 있다는것을 확실히 알고있고 만약 문제가있다면 바로 피드백을 받는게 좋음
        guard let content = model?.contents[indexPath.row] else { return .init() }
        let cell: GameItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GameItemTableViewCell",
                                                                        for: indexPath) as! GameItemTableViewCell
        var screenshotURLs: [String] = []
        content.screenshots.forEach { $0.images.forEach { screenshotURLs.append($0.url) } }
        // 서버 변경시 다 변경해야하는 불편함 -> 최소한의 코드만 변경하기위해서 모델을 새로 정의하여 랩핑하는 방식을 사용
        let model: GameItemModel = GameItemModel(gameTitle: content.formalName,
                                                 gameOriginPrice: 1_000,
                                                 gameDiscountPrice: nil,
                                                 imageURL: content.heroBannerURL,
                                                 screenshot: screenshotURLs)
        cell.setModel(model)
        return cell
    }
}

extension GameListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isIndicatorCell(indexPath) {
            newOffset += 10
            newGameListAPICall()
        }
    }
}
