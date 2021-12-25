//
//  SheetPresentationBehaviourController.swift
//  CloudOnMobile
//
//  Created by Karol P on 21/12/2021.
//

import UIKit

/// Class responsible for controlling swipe behavior
final class SheetPresentationBehaviourController {
    enum Detent {
        case large
        case medium
        case small
    }

    private var maxHeight: CGFloat {
        detents.max(by: { $0.height < $1.height })?.height ?? 0
    }

    private var minHeight: CGFloat {
        detents.min(by: { $0.height < $1.height })?.height ?? 0
    }

    private weak var bottomScrollView: UIScrollView?

    private lazy var panGestureRecognizer = with(UIPanGestureRecognizer()) {
        $0.addTarget(self, action: #selector(handlePan))
    }

    private var rootView: UIView?
    private var detent: Detent
    private var topConstraint = NSLayoutConstraint()

    private let bottomSheet = SheetPresentationContainerView()

    private let velocityRequiredForStateChange: CGFloat = 700

    private let detents: [Detent]

    /// Initialize SheetPresentationBehaviourController
    /// - Parameters:
    ///   - initialDetent: Initial detent.
    ///   - detents: Possible detents switching.
    init(
        initialDetent: Detent,
        detents: [Detent]
    ) {
        detent = initialDetent
        self.detents = detents.sorted(by: { $0.height < $1.height })
    }

    /// Method that setups component for usage. Must be called when view is setup to degree allowing for adding bottom sheet.
    /// Bottom sheet content is added as subview here, wrapped in another view indicating possibility for swipe for end-user.
    /// - Parameters:
    ///   - rootView: view of BottomSheetContainer component (has both background view and bottom sheet view as children)
    ///   - bottomSheetContent: view to be displayed inside of bottom sheet
    func prepareForUsage(
        rootView: UIView?,
        bottomSheetContent: UIView
    ) {
        self.rootView = rootView
        setupView(bottomSheetContent: bottomSheetContent)
    }
}

// MARK: - Private

private extension SheetPresentationBehaviourController {
    func setupView(bottomSheetContent: UIView) {
        guard let rootView = rootView else { return }
        rootView.addSubview(bottomSheet)

        topConstraint = bottomSheet.topAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -detent.height)
        bottomScrollView?.isScrollEnabled = false

        bottomSheet.addConstraints { [
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equalConstant(.height, maxHeight)
        ] }

        topConstraint.isActive = true

        bottomSheet.fill(with: bottomSheetContent)
        bottomSheet.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let yTranslation = gestureRecognizer.translation(in: bottomSheet).y
        let yVelocity = gestureRecognizer.velocity(in: bottomSheet).y

        switch gestureRecognizer.state {
        case .began,
             .changed:
            let touchLocationInBottomSheet = gestureRecognizer.location(in: bottomSheet)
            handlePanChanged(
                yTranslation: yTranslation,
                yVelocity: yVelocity,
                touchLocationInBottomSheet: touchLocationInBottomSheet
            )
        case .ended:
            handlePanEnded(
                gestureEndYPosition: gestureRecognizer.location(in: rootView).y.magnitude,
                yVelocity: yVelocity
            )
        case .cancelled,
             .failed,
             .possible:
            break
        @unknown default:
            break
        }
    }

    func handlePanChanged(
        yTranslation: CGFloat,
        yVelocity: CGFloat,
        touchLocationInBottomSheet: CGPoint
    ) {
        let traveledDistance = detent.height - yTranslation

        guard
            (minHeight...maxHeight).contains(traveledDistance)
        else {
            return
        }

        topConstraint.constant = -traveledDistance
        bottomScrollView?.isScrollEnabled = false
        rootView?.layoutIfNeeded()
    }

    func handlePanEnded(
        gestureEndYPosition: CGFloat,
        yVelocity: CGFloat
    ) {
        let shouldChangeState = yVelocity.magnitude > velocityRequiredForStateChange
        if shouldChangeState {
            if yVelocity < 0 {
                animate(to: detent.next(detents: detents))
            } else {
                animate(to: detent.previous(detents: detents))
            }
        } else {
            let state = detent.state(translation: gestureEndYPosition, detents: detents)
            animate(to: state)
        }
    }

    func animate(to visibility: Detent) {
        topConstraint.constant = -visibility.height
        bottomScrollView?.isScrollEnabled = visibility.isScrollable

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.rootView?.layoutIfNeeded()
            }
        ) { [weak self] _ in
            self?.detent = visibility
        }
    }
}

private extension SheetPresentationBehaviourController.Detent {
    var isScrollable: Bool {
        switch self {
        case .large:
            return true
        case .medium,
             .small:
            return false
        }
    }

    var height: CGFloat {
        switch self {
        case .large:
            return UIScreen.main.bounds.height * 0.9
        case .medium:
            return UIScreen.main.bounds.height * 0.45
        case .small:
            return UIScreen.main.bounds.height * 0.2
        }
    }

    func state(translation: CGFloat, detents: [Self]) -> Self {
        var closest: CGFloat = .infinity
        var closestDetent: Self?

        detents.forEach { detent in
            let difference = abs(detent.height - (UIScreen.main.bounds.height - translation))
            if difference < closest {
                closest = difference
                closestDetent = detent
            }
        }

        return closestDetent ?? self
    }

    func next(detents: [Self]) -> Self {
        detents.first(where: { $0.height > self.height }) ?? self
    }

    func previous(detents: [Self]) -> Self {
        detents.reversed().first(where: { $0.height < self.height }) ?? self
    }
}
