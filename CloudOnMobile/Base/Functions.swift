//
//  Functions.swift
//  PhoneDrive
//
//  Created by Karol P on 09/12/2021.
//

import Foundation

/// Runs function block on instance of target.
/// It is useful for configuring object.
/// Usage:
///     let view = with(UIView()) {
///          $0.backgroundColor = .blue
///          $0.layer.cornerRadius = 16
///     }
///
/// - Parameters:
///   - target: Target object
///   - block: Method to be run on target object
@inline(__always) public func with<T>(_ target: T, block: (T) -> Void) -> T {
    block(target)
    return target
}
