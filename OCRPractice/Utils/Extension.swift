//
//  Extension.swift
//  OCRPractice
//
//  Created by 현수빈 on 4/24/24.
//

import UIKit

public extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}


public extension Array {
    
    func find<T: Equatable>(_ keyPath: KeyPath<Element, T>, value: T) -> Element? {
        return first(where: { $0[keyPath: keyPath] == value })
    }
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
