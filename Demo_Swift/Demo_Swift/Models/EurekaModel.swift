//
//  EurekaModel.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/30.
//

enum COPPA: UInt32 {
    case Unknown = 0
    case YES = 1
    case NO = 2
    case UnUsed = 999
}

enum GDPR: UInt32 {
    case Unknown = 0
    case Accept = 1
    case Denied = 2
    case UnUsed = 999
}

enum AgeState: UInt32 {
    case Adult = 0
    case Children = 1
    case UnUsed = 999
}

enum PersonalizedState: UInt32 {
    case On = 0
    case Off = 1
    case UnUsed = 999
}

struct SegmentItem<T: Equatable>: CustomStringConvertible, Equatable {
    let name: String
    let value: T
    init(name: String, value: T) {
        self.name = name
        self.value = value
    }
    var description: String {
        return name
    }
}
