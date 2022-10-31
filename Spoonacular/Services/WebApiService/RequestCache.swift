//
//  RequestCache.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

private extension Int {
    var formatFileSize: String {
        return ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .file)
    }
}

class RequestCache {
    private var cachePath: URL?
    private let identifier: String
    
    init(timeLimit: TimeInterval = 604800, itemsLimit: Int = 1000, sizeLimit: Int = 0, identifier: String = "Generic") {
        let fileManager = FileManager.default
        
        do {
            cachePath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("\(Bundle.main.bundleIdentifier?.capitalized ?? "Melon")/Caches/\(identifier)/")
            
            if let cachePath = cachePath {
                try fileManager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            #if DEBUG
            print("\n----------------------------------\nCould not create cache folder\n----------------------------------\n")
            #endif
            
            cachePath = nil
        }
        
        self.identifier = identifier
        removeExpiredFiles(timeLimit: timeLimit, itemsLimit: itemsLimit, sizeLimit: sizeLimit)
    }
    
    subscript(name: String) -> Data? {
        get {
            if let path = pathFrom(name: name) {
                return try? Data(contentsOf: path)
            }
            
            return nil
        }
        set(newValue) {
            if let newValue = newValue, let path = pathFrom(name: name) {
                try? newValue.write(to: path, options: .atomic)
            }
        }
    }
    
    func removeAllFiles() {
        for file in cachedFiles() {
            #if DEBUG
            print("\n----------------------------------\nCache deleted: \(file.path)\n----------------------------------\n")
            #endif
            
            try? FileManager.default.removeItem(at: file.path)
        }
    }
    
    private func pathFrom(name: String) -> URL? {
        if let sha1 = SHA1.from(string: name) {
            return cachePath?.appendingPathComponent("\(sha1).tmp")
        }
        
        return nil
    }
    
    private func removeExpiredFiles(timeLimit: TimeInterval, itemsLimit: Int, sizeLimit: Int) {
        let expireDate = Date(timeIntervalSinceNow: -timeLimit)
        
        var size = 0
        var items = 0
        
        for file in cachedFiles() {
            if items >= itemsLimit || (sizeLimit > 0 && size >= sizeLimit) || file.accessDate == nil || file.accessDate! < expireDate {
                #if DEBUG
                print("\n----------------------------------\nCache deleted: \(file.path)\n----------------------------------\n")
                #endif
                
                try? FileManager.default.removeItem(at: file.path)
                continue
            }
            
            size += file.fileSize ?? 0
            items += 1
        }
        
        #if DEBUG
        print("\n----------------------------------\nCache identifier: \(identifier)\nSize: \(size.formatFileSize)\nItems: \(items)\n----------------------------------\n")
        #endif
    }
    
    private func cachedFiles() -> [(path: URL, accessDate: Date?, fileSize: Int?)] {
        let fileManager = FileManager.default
        let keys: Set<URLResourceKey> = [.isDirectoryKey, .contentAccessDateKey, .totalFileAllocatedSizeKey]
        
        var files = [(path: URL, accessDate: Date?, fileSize: Int?)]()
        
        if let cachePath = cachePath, let paths = try? fileManager.contentsOfDirectory(at: cachePath, includingPropertiesForKeys: Array(keys), options: .skipsHiddenFiles) {
            files.reserveCapacity(paths.count)
            
            for path in paths {
                guard let values = try? path.resourceValues(forKeys: keys), values.isDirectory == false else {
                    continue
                }
                
                files.append((path: path, accessDate: values.contentAccessDate, fileSize: values.totalFileAllocatedSize))
            }
            
            files.sort { file1, file2 in
                if let date1 = file1.accessDate, let date2 = file2.accessDate {
                    return date1.compare(date2) == .orderedDescending
                }
                
                return true
            }
        }
        
        return files
    }
}
