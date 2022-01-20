//
//  AppDefaults.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/01/2022.
//

import Foundation

/// Protocol contains UserDefaults for application.
protocol AppDefaults: AnyObject {
    /// Indicates if user has completed onboarding.
    var onboardingCompleted: Bool { get set }
}

final class DefaultAppDefaults {
    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
    }

    private let userDefaults: UserDefaults

    /// Initialize DefaultAppDefaults.
    /// - Parameters:
    ///   - userDefaults: Defaults to have values.
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

// MARK: - AppDefaults

extension DefaultAppDefaults: AppDefaults {
    var onboardingCompleted: Bool {
        get {
            userDefaults.bool(forKey: Keys.onboardingCompleted)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.onboardingCompleted)
        }
    }
}
