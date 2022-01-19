//
//  OnboardingPage.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import UIKit

enum OnboardingPage: CaseIterable {
    case intro
    case sendingDocuments
}

extension OnboardingPage {
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }

    var image: UIImage {
        switch self {
        case .intro:
            return UIImage(imageLiteralResourceName: "onboardingMap")
        case .sendingDocuments:
            return UIImage(imageLiteralResourceName: "onboardingMap")
        }
    }

    var title: String {
        switch self {
        case .intro:
            return "intro"
        case .sendingDocuments:
            return "sendingDocuments"
        }
    }

    var description: String {
        switch self {
        case .intro:
            return "intro Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor."
        case .sendingDocuments:
            return "sendingDocuments Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor."
        }
    }
}
