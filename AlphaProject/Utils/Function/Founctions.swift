//
//  Founctions.swift
//  AlphaProject
//
//  Created by a on 2022/7/25.
//

import Foundation

func configure<T: AnyObject>(_ object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}
