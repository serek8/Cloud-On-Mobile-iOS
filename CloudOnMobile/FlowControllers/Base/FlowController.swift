//
//  FlowController.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import UIKit

/// Describes class managing part of application flow.
protocol FlowController: AnyObject {
    /// Parent flow controller.
    var parent: FlowController? { get set }

    /// FlowControllers presented by this FlowController
    var children: [FlowController] { get set }

    /// Navigation start of flow controller.
    var navigationController: UINavigationController { get }

    /// Represents ViewController that is currently presented.
    var currentViewController: UIViewController { get }

    /// Transition that was used to present the flow controller.
    var presentation: FlowControllerPresentation { get }

    /// Adds flow controller to children array.
    ///
    /// - Parameters:
    ///   - flowController: flow controller to be added.
    func add(flowController: FlowController)

    /// Removes currently presented flow controller.
    func removeFlowController()
}

// MARK: - Default Implementation

extension FlowController {
    var currentViewController: UIViewController {
        precondition(!navigationController.viewControllers.isEmpty, "We can't present only navigation controller")
        return navigationController.viewControllers.last!
    }

    func add(flowController: FlowController) {
        children.append(flowController)
        flowController.parent = self
        switch flowController.presentation {
        case let .modal(style):
            flowController.navigationController.modalPresentationStyle = style
            navigationController.present(flowController.navigationController, animated: true, completion: nil)
        case .push:
            navigationController.pushViewController(flowController.navigationController, animated: true)
        case .root:
            break
        }
    }

    func removeFlowController() {
        guard let parentFlowController = parent else { return }
        if let index = children.firstIndex(where: { $0 === self }) {
            children.remove(at: index)
        }
        switch presentation {
        case .modal:
            navigationController.dismiss(animated: true, completion: nil)
        case .push:
            navigationController.popToViewController(parentFlowController.currentViewController, animated: true)
        case .root:
            break
        }
    }
}
