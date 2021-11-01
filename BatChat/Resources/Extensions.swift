//
//  Extensions.swift
//  BatChat
//
//  Created by 徐浩博 on 2021/10/30.
//

import UIKit

extension UIView {
    public var width: CGFloat {
        self.frame.size.width
    }
    
    public var height: CGFloat {
        self.frame.size.height
    }
    
    public var top: CGFloat {
        self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        self.frame.size.height + self.frame.origin.y
    }
    
    public var left: CGFloat {
        self.frame.origin.x
    }
    
    public var right: CGFloat {
        self.frame.size.width + self.frame.origin.x
    }
}

extension Notification.Name {
    static let didLoginNotification = Notification.Name("didLoginNotification")
}
