//
//  OnboardingPageViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 19/01/2022.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    let onboardingPageView = OnboardingPageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        view.addSubview(onboardingPageView)
        onboardingPageView.addConstraints { $0.equalEdges() }
    }
}
