//
//  SheetPresentationController.swift
//  CloudOnMobile
//
//  Created by Karol P on 21/12/2021.
//

import UIKit

/// ViewController with scrollView.
protocol ScrollableViewController: UIViewController {
    var scrollView: UIScrollView? { get }
}

/// Class for showing view controller with bottom sheet.
final class SheetPresentationController: UIViewController {
    /// The preferred status bar style for the view controller.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        backgroundViewController.preferredStatusBarStyle
    }

    private let backgroundViewController: UIViewController

    private let sheetContentViewController: ScrollableViewController

    private let controller: SheetPresentationBehaviourController

    init(
        backgroundViewController: UIViewController,
        sheetContentViewController: ScrollableViewController
    ) {
        self.backgroundViewController = backgroundViewController
        self.sheetContentViewController = sheetContentViewController
        controller = SheetPresentationBehaviourController(
            initialDetent: .small,
            detents: [.large, .small]
        )
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension SheetPresentationController {
    func setupView() {
        addChild(backgroundViewController)
        addChild(sheetContentViewController)
        view.addSubview(backgroundViewController.view)
        backgroundViewController.view.addConstraints {
            $0.equalEdges()
        }
        controller.prepareForUsage(
            rootView: view,
            bottomSheetContent: sheetContentViewController.view,
            scrollView: sheetContentViewController.scrollView
        )
        backgroundViewController.didMove(toParent: self)
        sheetContentViewController.didMove(toParent: self)
    }
}
