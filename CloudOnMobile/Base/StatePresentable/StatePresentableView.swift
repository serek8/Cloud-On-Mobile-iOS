//
//  StatePresentableView.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/01/2022.
//

import UIKit

/// Protocol describes view which can present error and empty state.
protocol StatePresentableView {
    /// View representing empty state.
    var emptyStateView: UIView { get }

    /// View representing error state.
    var errorStateView: UIView { get }

    /// Shows empty state.
    func showEmptyState()

    /// Shows error state.
    func showErrorState()

    /// Removes all state views.
    func clearState()
}

extension StatePresentableView where Self: BaseViewController {
    func showEmptyState() {
        DispatchQueue.main.async {
            self.clearState()
            self.containerView.addSubview(self.emptyStateView)
            self.emptyStateView.addConstraints { $0.equalEdges() }
        }
    }

    func showErrorState() {
        DispatchQueue.main.async {
            self.clearState()
            self.containerView.addSubview(self.errorStateView)
            self.errorStateView.addConstraints { $0.equalEdges() }
        }
    }

    func clearState() {
        self.emptyStateView.removeFromSuperview()
        self.errorStateView.removeFromSuperview()
    }
}
