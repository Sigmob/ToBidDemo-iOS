//
//  NativeAdTableViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import UIKit
import Foundation
import SnapKit
import MJRefresh
import WindMillSDK

class NativeAdTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // 广告位Id
    var placementId: String?
    
    let viewModel = NativeAdViewModel()
    
    let tableView = UITableView(frame: CGRectZero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "原生广告列表页"
        setupTableView()
        viewModel.tableView = tableView
        viewModel.placementId = placementId
        addRefreshFooter()
        addRefreshHeader()
        viewModel.initDataSources()
        tableView.reloadData()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(FeedNormalTitleCell.self, forCellReuseIdentifier: "FeedNormalTitleCell");
        tableView.register(FeedNormalTitleImgCell.self, forCellReuseIdentifier: "FeedNormalTitleImgCell");
        tableView.register(FeedNormalBigImgCell.self, forCellReuseIdentifier: "FeedNormalBigImgCell");
        tableView.register(FeedNormalThreeImgsCell.self, forCellReuseIdentifier: "FeedNormalThreeImgsCell");
    }
    func addRefreshFooter() {
        MJRefreshAutoNormalFooter {[weak self] in
            self?.viewModel.loadNextPage()
        }.autoChangeTransparency(true)
            .link(to: tableView)
    }
    func addRefreshHeader() {
        MJRefreshNormalHeader { [weak self] in
            self?.viewModel.refresh()
        }.autoChangeTransparency(true)
        .link(to: tableView)
    }
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let data = viewModel.datas[indexPath.row] as? FeedNormalModel {
            return data.height
        }
        if let data = viewModel.datas[indexPath.row] as? WindMillNativeAd {
            if data.feedADMode != .NativeExpress {
                return 120 + 0.5625 * view.bounds.size.width
            }
            let key = PointerUtil.hashValue(data)
            let size = viewModel.heights[key]
            return size?.height ?? 0
        }
        return 0
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = viewModel.datas[indexPath.row] as? FeedNormalModel, let name = data.cellClassName() {
            let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as! FeedNormalCell
            cell.refresh(data: data)
            return cell
        }
        if let data = viewModel.datas[indexPath.row] as? WindMillNativeAd {
            let cid = "cid_\(indexPath.row)"
            let cell = tableView.dequeueReusableCell(withIdentifier: cid) as? NativeAdCell ?? NativeAdCell(nativeAd: data, style: .default, reuseIdentifier: cid)
            cell.refresh(nativeAd: data, viewController: self, delegate: viewModel)
            return cell
        }
        return UITableViewCell()
    }
}
