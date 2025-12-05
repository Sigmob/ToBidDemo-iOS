import Foundation

extension Array {
    /// 将源数组中的每个元素随机插入到当前数组中（修改原数组）
    /// - Parameter sourceArray: 要插入的源数组
    mutating func randomInsert<T>(from sourceArray: [T]) where Element == T {
        for element in sourceArray {
            let randomIndex = Int.random(in: 0...self.count)
            self.insert(element, at: randomIndex)
        }
    }
    
    /// 将源数组中的每个元素随机插入到当前数组中，返回新数组（不修改原数组）
    /// - Parameter sourceArray: 要插入的源数组
    /// - Returns: 插入后的新数组
    func randomInserted<T>(from sourceArray: [T]) -> [T] where Element == T {
        var result = self
        for element in sourceArray {
            let randomIndex = Int.random(in: 0...result.count)
            result.insert(element, at: randomIndex)
        }
        return result
    }
}

