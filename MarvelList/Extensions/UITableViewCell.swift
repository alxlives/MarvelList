//
//  UITableViewCell.swift
//  MarvelList
//
//  Created by MacDev on 09/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
