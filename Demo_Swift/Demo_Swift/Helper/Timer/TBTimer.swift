//
//  TBTimer.swift
//  WindMillSDK
//
//  Created by Codi on 2025/8/13.
//

import Foundation

enum TimerState {
    case running
    case paused
    case cancelled
}
/// 基于DispatchSourceTimer实现，不依赖Runloop
class TBTimer {
    // 定时器状态
    private(set) var state: TimerState = .cancelled

    // 定时器时间间隔
    private let interval: TimeInterval

    // 定时器回调
    private let callback: () -> Void

    // 是否重复执行
    private let repeats: Bool

    // 内部定时器
    private var timer: DispatchSourceTimer?

    // 暂停时的剩余时间
    private var remainingTime: TimeInterval = 0

    // 定时器开始时间
    private var startTime: Date?

    // 初始化方法
    init(interval: TimeInterval, repeats: Bool = true, _ callback: @escaping () -> Void) {
        self.interval = interval
        self.repeats = repeats
        self.callback = callback
    }

    // 开始定时器
    func start() {
        guard state != .running else { return }

        // 如果是从暂停状态恢复，则使用剩余时间
        let timeToWait = state == .paused ? remainingTime : interval

        // 创建新的定时器
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

        // 根据是否重复设置定时器调度
        if repeats {
            timer?.schedule(deadline: .now() + timeToWait, repeating: interval)
        } else {
            timer?.schedule(deadline: .now() + timeToWait)
        }

        timer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.callback()
                // 如果不重复，执行后自动取消
                if !(self?.repeats ?? false) {
                    self?.cancel()
                }
            }
        }

        // 记录开始时间
        startTime = Date()

        // 启动定时器
        timer?.resume()
        state = .running
    }

    // 暂停定时器
    func pause() {
        guard state == .running else { return }

        // 计算剩余时间
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            remainingTime = interval - (elapsedTime.truncatingRemainder(dividingBy: interval))
        } else {
            remainingTime = interval
        }

        // 取消当前定时器
        timer?.cancel()
        timer = nil

        state = .paused
    }

    // 恢复定时器
    func resume() {
        guard state == .paused else { return }
        start()
    }

    // 取消定时器
    func cancel() {
        guard state != .cancelled else { return }

        timer?.cancel()
        timer = nil
        remainingTime = 0
        startTime = nil

        state = .cancelled
    }

    // 析构函数
    deinit {
        cancel()
    }
}
