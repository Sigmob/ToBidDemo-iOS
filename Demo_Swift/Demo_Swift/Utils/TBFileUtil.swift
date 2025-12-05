//
//  TBFileUtil.swift
//  WindMillSDK
//
//  Created by Codi on 2025/7/24.
//

import Foundation

struct TBFileUtil {
    private init() {}
    // MARK: - 路径获取
    /// 获取沙盒根目录路径
    enum Sandbox {
        case documents
        case library
        case caches
        case temp
        
        var path: URL {
            switch self {
            case .documents:
                return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            case .library:
                return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            case .caches:
                return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            case .temp:
                return URL(fileURLWithPath: NSTemporaryDirectory())
            }
        }
    }
    
    /// 获取项目路径
    enum Directory {
        case root
        case log(_ name: String)
        
        var path: URL {
            switch self {
            case .root:
                return URL(fileURLWithPath: "\(Sandbox.documents.path.path)/Demo")
            case .log(let name):
                return URL(fileURLWithPath: "\(Directory.root.path.path)/\(name)")
            }
        }
    }
    
    /// 获取目录下所有文件（非递归）
    static func listFiles(in directory: URL,
                          options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]) throws -> [URL] {
        return try FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil,
            options: options
        )
    }
    
    /// 递归获取目录下所有文件（包含子目录）
    static func listFilesRecursively(in directory: URL,
                                     options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]) -> [URL] {
        let fileManager = FileManager.default
        var result = [URL]()
        
        guard let enumerator = fileManager.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: options
        ) else { return [] }
        
        for case let fileURL as URL in enumerator {
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory) {
                if !isDirectory.boolValue {
                    result.append(fileURL)
                }
            }
        }
        return result
    }
    
    
    
    
}
