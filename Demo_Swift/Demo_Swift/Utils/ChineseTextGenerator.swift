//
//  ChineseTextGenerator.swift
//  Demo_Swift
//
//  Created by Codi on 2025/11/5.
//

import Foundation

class ChineseTextGenerator {

    // 常用中文词汇库
    private static let words = [
        "科技", "创新", "发展", "未来", "智能", "数字", "时代", "生活", "工作", "学习",
        "健康", "快乐", "幸福", "成功", "梦想", "希望", "信念", "坚持", "努力", "奋斗",
        "团队", "合作", "沟通", "交流", "分享", "共赢", "信任", "尊重", "理解", "包容",
        "质量", "效率", "服务", "体验", "价值", "品牌", "市场", "用户", "产品", "设计",
        "文化", "艺术", "音乐", "绘画", "文学", "电影", "游戏", "娱乐", "旅行", "探索",
        "自然", "环保", "生态", "绿色", "可持续", "和谐", "平衡", "稳定", "安全", "健康"
    ]
    
    // 常用句子模板
    private static let sentenceTemplates = [
        "{n}是{n}的基础",
        "{n}让{n}变得更加{n}",
        "我们应该{n}，这样才能{n}",
        "在{n}的时代，{n}显得尤为重要",
        "通过{n}，可以实现{n}的目标",
        "{n}和{n}是相辅相成的",
        "坚持{n}，终将迎来{n}",
        "{n}不仅是{n}，更是{n}",
        "让我们一起{n}，共创{n}",
        "{n}需要{n}的支持和{n}的努力"
    ]
    
    /// 生成随机中文句子
    /// - Parameters:
    ///   - templateCount: 使用的模板数量
    ///   - separator: 句子之间的分隔符
    /// - Returns: 随机中文句子字符串
    static func randomSentences(templateCount: Int = 1, separator: String = " ") -> String {
        var sentences: [String] = []
        
        for _ in 0..<templateCount {
            let randomTemplate = sentenceTemplates.randomElement() ?? "{n}"
            var sentence = randomTemplate
            
            // 替换模板中的{n}占位符
            while sentence.contains("{n}") {
                let randomWord = words.randomElement() ?? "内容"
                sentence = sentence.replacingOccurrences(of: "{n}", with: randomWord)
            }
            
            sentences.append(sentence)
        }
        
        return sentences.joined(separator: separator)
    }
}
