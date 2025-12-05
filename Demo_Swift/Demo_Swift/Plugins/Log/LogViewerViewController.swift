//
//  LogViewerViewController.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/29.
//

import UIKit
import SnapKit

class LogViewerViewController: UIViewController {
    
    public var path: String!
    // MARK: - 属性
    private var logManager: LogManager!
    private var allLogs: [LogEntry] = []
    private var filteredLogs: [LogEntry] = []
    private var currentFilterLevel: LogLevel?
    
    // UI组件
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var levelButtons: [UIButton] = []
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        logManager = LogManager(path)
        levelButtons = LogLevel.allCases.map { self.createLevelButton(for: $0) }
        setupUI()
        loadLogs()
        levelButtonTapped(levelButtons[0])
    }
    
    // MARK: - UI设置
    private func setupUI() {
        view.backgroundColor = .white
        // 导航栏按钮
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "清除", style: .plain, target: self, action: #selector(clearLogsTapped)),
            UIBarButtonItem(title: "导出", style: .plain, target: self, action: #selector(exportLogsTapped))
        ]
        
        // 搜索栏
        searchBar.placeholder = "请输入您要搜索的关键字"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        // 级别筛选按钮栈
        let buttonStack = UIStackView(arrangedSubviews: levelButtons)
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        // 日志表格
        tableView.delegate = self
        tableView.dataSource = self
        // 改为注册自定义 Cell
        tableView.register(LogTextCell.self, forCellReuseIdentifier: "LogCell")
        // 开启自适应行高与估算高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // 约束
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            tableView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // 创建级别筛选按钮
    private func createLevelButton(for level: LogLevel) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(level.rawValue, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
        button.tag = LogLevel.allCases.firstIndex(of: level) ?? 0
        return button
    }
    
    // MARK: - 日志操作
    private func loadLogs() {
        allLogs = logManager.loadLogs()
        filteredLogs = allLogs
        tableView.reloadData()
    }
    
    private func updateLogsFilter() {
        filteredLogs = logManager.filterLogs(allLogs,
                                           searchText: searchBar.text ?? "",
                                           level: currentFilterLevel)
        tableView.reloadData()
    }
    
    // MARK: - 事件处理
    @objc private func levelButtonTapped(_ sender: UIButton) {
        let level = LogLevel.allCases[sender.tag]
        currentFilterLevel = (currentFilterLevel == level) ? nil : level
        
        // 更新按钮样式
        levelButtons.forEach { btn in
            let btnLevel = LogLevel.allCases[btn.tag]
            btn.backgroundColor = (currentFilterLevel == btnLevel) ? .systemRed : .systemBlue
        }
        
        updateLogsFilter()
    }
    
    @objc private func clearLogsTapped() {
        logManager.clearLogs()
        allLogs.removeAll()
        filteredLogs.removeAll()
        tableView.reloadData()
    }
    
    @objc private func exportLogsTapped() {
        guard let url = logManager.exportLogs() else {
            showAlert(title: "导出失败", message: "无法导出日志文件")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        // 适配 iPad：设置弹窗的锚点
        if let popoverController = activityVC.popoverPresentationController {
            // 方法 1：从按钮呈现
            popoverController.barButtonItem = navigationItem.rightBarButtonItem // 如果是导航栏按钮
        }
        present(activityVC, animated: true)
    }
    
    // 显示提示对话框
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - 表格视图数据源和代理
extension LogViewerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogTextCell
        let log = filteredLogs[indexPath.row]
        // 设置文本
        cell.logLabel.text = log.value
        // 根据级别设置文字颜色
        switch log.level {
        case .error: cell.logLabel.textColor = .red
        case .warning: cell.logLabel.textColor = .orange
        case .info: cell.logLabel.textColor = .systemBlue
        default: cell.logLabel.textColor = .darkGray
        }
        return cell
    }
}

// MARK: - 搜索栏代理
extension LogViewerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateLogsFilter()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
