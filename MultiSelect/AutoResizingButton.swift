//
//  UIButton+Extension.swift
//  MultiSelect
//
//  Created by user on 22/10/19.
//  Copyright © 2019 Contus. All rights reserved.
//

import Foundation
import UIKit
class AutoResizingButton: UIButton {
    override func draw(_ rect: CGRect) {
    }
    override var intrinsicContentSize: CGSize
        {
        get {
            let labelSize = titleLabel?.sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
            let reqiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
            
            return reqiredButtonSize
        }
    }
}
