//
//  BaseViewController.swift
//  PhoneDrive
//
//  Created by Karol P on 09/12/2021.
//

import UIKit

class BaseViewController: UIViewController, AutoKeyboard {
    let containerView = UIView()

    /// Instance of presenter.
    private let presenter: PresenterProtocol

    // MARK: AutoKeyboard

    var automaticallyAdjustKeyboardLayoutGuide = false {
        willSet {
            newValue ? startObservingKeyboardNotifications() : stopObservingKeyboardNotifications()
        }
    }

    var onKeyboardWillAppear: ((Notification) -> Void)?

    var onKeyboardWillDisappear: ((Notification) -> Void)?

    var bottomConstraint: NSLayoutConstraint?

    /// Initialize BaseViewController.
    /// - Parameters:
    ///   - presenter: Instance of presenter.
    ///   - backgroundColor: Background color of the ViewController.
    init(
        presenter: PresenterProtocol,
        backgroundColor: UIColor = AppStyle.current.color(for: .white)
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = backgroundColor
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.onViewDidDisappear()
    }

    // MARK: - Functions

    /// Closes ViewController.
    func closeView() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    func refreshData() async {
        await presenter.refreshData()
    }

    /// - SeeAlso: Swift.deinit
    deinit {
        stopObservingKeyboardNotifications()
    }
}

// MARK: - Private

private extension BaseViewController {
    func setupView() {
        view.addSubview(containerView)
        bottomConstraint = containerView.addConstraints { [
            $0.equal(.top),
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equal(.bottom)
        ] }.last
    }
}
