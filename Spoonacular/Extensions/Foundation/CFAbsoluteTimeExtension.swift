//
//  CFAbsoluteTimeExtension.swift
//  Spoonacular
//
//  Created by Marcos Kobuchi on 31/10/22.
//

import Foundation

#if DEBUG
extension CFAbsoluteTime {
    
    var humanReadable: String {
        var suffix = "s"
        var time = self
        
        if time > 100 {
            suffix = "m"
            time /= 60
        } else if time < 1e-6 {
            suffix = "ns"
            time *= 1e9
        } else if time < 1e-3 {
            suffix = "µs"
            time *= 1e6
        } else if time < 1 {
            suffix = "ms"
            time *= 1000
        }
        
        return "\(String(format: "%.2f", time))\(suffix)"
    }
    
}
#endif
