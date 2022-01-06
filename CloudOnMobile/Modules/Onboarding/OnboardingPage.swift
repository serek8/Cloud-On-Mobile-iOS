//
//  OnboardingPage.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import UIKit

enum OnboardingPage: CaseIterable {
    case intro
}

extension OnboardingPage {
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }

    var image: UIImage {
        switch self {
        case .intro:
            return UIImage(imageLiteralResourceName: "onboardingMap")
        }
    }

    var title: String {
        switch self {
        case .intro:
            return "Heading"
        }
    }

    var description: String {
        switch self {
        case .intro:
            return "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor."
        }
    }
}
