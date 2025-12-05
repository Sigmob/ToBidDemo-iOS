//
//  SkipButton.swift
//  WindMillSDK
//
//  Created by Codi on 2025/9/6.
//

import UIKit

/// 跳过按钮状态枚举
enum SkipButtonState {
    case skipping(seconds: Int) // 倒计时中，显示剩余秒数
    case circularCountdown(seconds: Int) // 纯倒计时显示状态
    case canClose // 可以关闭，显示关闭文字
}

/// 跳过按钮组件，支持倒计时显示和状态切换
class SkipButton: UIButton {
    // MARK: - 私有属性
    
    public var cornerRadius = 15.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            circularCountdownView?.layer.cornerRadius = cornerRadius
        }
    }
    
    /// 倒计时计时器
    private var countdownTimer: TBTimer?
    
    /// 剩余倒计时秒数
    private var remainingSeconds: Int = 0
    
    /// 总倒计时秒数
    private var totalSeconds: Int = 0
    
    /// 当前按钮状态
    private var currentState: SkipButtonState = .canClose {
        didSet {
            updateButtonUI()
        }
    }
    
    /// 圆形倒计时视图
    private var circularCountdownView: UIView?
    
    
    // MARK: - 可配置属性
    
    /// 跳过按钮的文字前缀
    public var skipTextPrefix: String = "跳过"
    
    /// 关闭按钮的文字
    public var closeText: String = "关闭"
    
    /// 按钮背景颜色
    public var buttonBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            backgroundColor = buttonBackgroundColor
        }
    }
    
    /// 按钮文字颜色
    public var buttonTextColor: UIColor = UIColor.white {
        didSet {
            setTitleColor(buttonTextColor, for: .normal)
            setTitleColor(buttonTextColor.withAlphaComponent(0.8), for: .highlighted)
        }
    }
    
    /// 按钮字体
    public var buttonFont: UIFont = .systemFont(ofSize: 14.0) {
        didSet {
            titleLabel?.font = buttonFont
            guard let countdownLabel = circularCountdownView?.viewWithTag(1001) as? UILabel else { return }
            countdownLabel.font = buttonFont
        }
    }
    
    /// 按钮左右padding
    public var horizontalPadding: CGFloat = 10.0 {
        didSet {
            updateContentEdgeInsets()
        }
    }
    
    /// 按钮上下padding
    public var verticalPadding: CGFloat = 0.0 {
        didSet {
            updateContentEdgeInsets()
        }
    }
    
    /// 竖线左右两侧的间距
    public var pipeSymbolSpacing: CGFloat = 4.0
    
    /// 纯倒计时显示的秒数阈值（当剩余秒数大于此值时显示纯倒计时）
    public var showCircularCountdownSeconds: Int = 3 { 
        didSet {
            if case .skipping(_) = currentState {
                updateButtonUI()
            }
        }
    }
    
    /// 是否启用圆形倒计时样式
    public var showCircularCountdown: Bool = true { 
        didSet {
            if case .skipping(_) = currentState {
                updateButtonUI()
            }
        }
    }
    
    /// 圆形倒计时的边框颜色
    public var circularBorderColor: UIColor = UIColor.white.withAlphaComponent(0.6)
    
    /// 圆形倒计时的填充颜色
    private var circularFillColor: UIColor = .clear
    
    /// 按钮边框颜色（新增）
    public var borderColor: UIColor = UIColor.clear { 
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// 按钮边框宽度（新增）
    public var borderWidth: CGFloat = 0.0 { 
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // MARK: - 回调闭包
    
    /// 按钮点击回调 - 新增了状态参数
    public var didTapHandler: ((SkipButtonState) -> Void)?
    
    /// 倒计时结束回调
    public var didFinishCountdownHandler: (() -> Void)?
    
    // MARK: - 初始化
    
    /// 初始化方法
    /// - Parameter frame: 按钮frame
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    /// 从xib或storyboard初始化
    /// - Parameter coder: 编码器
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    /// 便捷初始化方法，直接设置倒计时秒数
    /// - Parameters:
    ///   - frame: 按钮frame
    ///   - countdownSeconds: 倒计时秒数
    public convenience init(frame: CGRect = .zero, countdownSeconds: Int = 5) {
        self.init(frame: frame)
        startCountdown(seconds: countdownSeconds)
    }
    
    func timerStoped() {
        countdownTimer?.cancel()
        countdownTimer = nil
    }
    
    // MARK: - 生命周期
    
    deinit {
        stopCountdown()
    }
    
    // MARK: - 私有方法
    
    /// 设置按钮基础属性
    private func setupButton() {
        // 设置默认样式
        backgroundColor = buttonBackgroundColor
        setTitleColor(buttonTextColor, for: .normal)
        setTitleColor(buttonTextColor.withAlphaComponent(0.8), for: .highlighted)
        titleLabel?.font = buttonFont
        clipsToBounds = true
        
        // 设置边框样式（新增）
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        // 设置内容内边距
        updateContentEdgeInsets()
        
        // 设置按钮点击事件
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // 设置默认状态为可关闭
        currentState = .canClose
    }
    
    /// 更新内容内边距
    private func updateContentEdgeInsets() {
        contentEdgeInsets = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
    }
    
    /// 更新按钮UI显示 - 根据剩余秒数切换纯倒计时和跳过+倒计时样式
    private func updateButtonUI() {
        if frame.size.height > 0 {
            layer.cornerRadius = frame.size.height / 2.0
        }
        if let circularView = circularCountdownView , circularView.frame.size.height > 0 {
            circularView.layer.cornerRadius = circularView.frame.size.height / 2.0
        }
        // 移除之前的圆形倒计时视图
        circularCountdownView?.removeFromSuperview()
        circularCountdownView = nil
        
        switch currentState {
        case .skipping(let seconds):
            if showCircularCountdown && seconds > showCircularCountdownSeconds {
                // 剩余秒数大于阈值，显示纯圆形倒计时
                currentState = .circularCountdown(seconds: seconds)
                return
            } else if seconds > 0 {
                // 剩余秒数小于等于阈值，显示跳过+倒计时
                // 根据pipeSymbolSpacing计算空格数量
                let spacesCount = Int(pipeSymbolSpacing / 2.0)
                let spaces = String(repeating: " ", count: spacesCount)
                
                // 在跳过文本和倒计时之间添加带空格的竖线
                setTitle("\(skipTextPrefix)\(spaces)|\(spaces)\(seconds)", for: .normal)
            }
        case .circularCountdown(let seconds):
            // 创建并添加圆形倒计时视图
            setupCircularCountdownView(seconds: seconds)
            setTitle("", for: .normal)
        case .canClose:
            // 倒计时结束，显示关闭文字
            setTitle(closeText, for: .normal)
        }
    }
    
    /// 设置圆形倒计时视图 - 修复文字居中问题
    private func setupCircularCountdownView(seconds: Int) {
        if circularCountdownView?.viewWithTag(1001) != nil {
            return
        }
        // 创建圆形倒计时视图
        let circularView = UIView()
        circularView.translatesAutoresizingMaskIntoConstraints = false
        circularView.backgroundColor = circularFillColor
        
        
        // 创建倒计时标签
        let countdownLabel = UILabel()
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.textAlignment = .center
        countdownLabel.textColor = buttonTextColor
        countdownLabel.font = buttonFont
        countdownLabel.text = "\(seconds)"
        countdownLabel.tag = 1001
        
        
        // 添加标签到圆形视图
        circularView.addSubview(countdownLabel)
        
        // 添加圆形视图到按钮
        addSubview(circularView)
        circularCountdownView = circularView
        circularCountdownView?.nx_snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        countdownLabel.nx_snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// 按钮点击处理 - 传递当前状态给回调
    @objc private func buttonTapped() {
        // stopCountdown()
        // 将当前状态传递给回调函数
        didTapHandler?(currentState)
    }
    
    /// 倒计时更新
    @objc private func updateCountdown() {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            // 倒计时结束
            stopCountdown()
            currentState = .canClose
            didFinishCountdownHandler?()
        } else {
            // 更新倒计时显示
            if showCircularCountdown && remainingSeconds > showCircularCountdownSeconds {
                currentState = .circularCountdown(seconds: remainingSeconds)
            } else {
                currentState = .skipping(seconds: remainingSeconds)
            }
        }
    }
    
    // MARK: - 公共方法
    
    /// 开始倒计时
    /// - Parameter seconds: 倒计时秒数
    public func startCountdown(seconds: Int) {
        stopCountdown() // 先停止之前的倒计时
        
        totalSeconds = max(0, seconds)
        remainingSeconds = totalSeconds
        
        if remainingSeconds > 0 {
            if showCircularCountdown && remainingSeconds > showCircularCountdownSeconds {
                currentState = .circularCountdown(seconds: remainingSeconds)
            } else {
                currentState = .skipping(seconds: remainingSeconds)
            }
            
            // 创建计时器
            countdownTimer = TBTimer(interval: 1.0, repeats: true) { [weak self] in
                self?.updateCountdown()
            }
            countdownTimer?.start()
        } else {
            currentState = .canClose
        }
    }
    
    /// 停止倒计时
    public func stopCountdown() {
        countdownTimer?.cancel()
        countdownTimer = nil
    }
    
    /// 重置按钮状态
    public func reset() {
        stopCountdown()
        currentState = .canClose
    }
    
    /// 立即切换到关闭状态
    public func switchToCloseState() {
        stopCountdown()
        currentState = .canClose
    }
}
