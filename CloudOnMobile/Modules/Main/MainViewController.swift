//
//  MainViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import UIKit

final class MainViewController: BaseViewController {
    private let rootStackView = with(UIStackView()) {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
    }

    private let imageView = with(UIImageView()) {
        $0.image = UIImage(imageLiteralResourceName: "illustration")
    }

    private let accessCodeLabel = with(UILabel()) {
        $0.text = L10n.MainViewController.accessCode
        $0.textColor = AppStyle.current.color(for: .white)
        $0.font = AppStyle.current.font(for: .body16Regular)
        $0.textAlignment = .center
    }

    private let codeValueLabel = with(UILabel()) {
        $0.text = "XXXXXX"
        $0.textColor = AppStyle.current.color(for: .white)
        $0.font = AppStyle.current.font(for: .headingTitleRegular)
        $0.textAlignment = .center
        $0.addCharactersSpacing(value: 26)
    }

    private lazy var getCodeButton = {
        let button = ViewsFactory.blueButton
        button.setTitle(L10n.MainViewController.getAccessCode, for: .normal)
        button.addTarget(self, action: #selector(getCodeButtonTapped), for: .touchUpInside)
        return button
    }()

    private let presenter: MainPresenterProtocol

    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Private

private extension MainViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.color(for: .background)
        containerView.addSubview(rootStackView)

        rootStackView.addConstraints { [
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equal(.centerY)
        ] }

        rootStackView.addArrangedSubviews([
            imageView,
            .spacingView(height: 40),
            accessCodeLabel,
            .spacingView(height: 24),
            codeValueLabel,
            .spacingView(height: 64),
            getCodeButton
        ])

        imageView.addConstraints { [
            $0.equalConstant(.height, 120),
            $0.equalConstant(.width, 136)
        ] }

        getCodeButton.addConstraints { [
            $0.equalConstant(.height, 56)
        ] }

        codeValueLabel.addConstraints { [
            $0.equal(.leading, constant: 16),
            $0.equal(.trailing, constant: -16)
        ] }
    }

    @objc func getCodeButtonTapped() {
        Task {
            let result = await presenter.getAccessCode()
            switch result {
            case let .success(code):
                codeValueLabel.text = code
                codeValueLabel.addCharactersSpacing(value: 26)
            case .failure:
                /// - TODO: Handle error
                break
            }
        }
    }
}
