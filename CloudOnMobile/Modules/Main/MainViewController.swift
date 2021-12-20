//
//  MainViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import UIKit

final class MainViewController: BaseViewController<MainPresenter> {
    private let rootStackView = with(UIStackView()) {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
    }

    private let imageView = with(UIImageView()) {
        $0.image = UIImage(imageLiteralResourceName: "illustration")
    }

    private let accessCodeLabel = with(UILabel()) {
        $0.text = "Access code"
        $0.textColor = AppStyle.current.color(for: .white)
        $0.font = AppStyle.current.font(for: .regular, size: 16)
        $0.textAlignment = .center
    }

    private let codeValueLabel = with(UILabel()) {
        $0.text = "XXXXXX"
        $0.textColor = AppStyle.current.color(for: .white)
        $0.font = AppStyle.current.font(for: .regular, size: 36)
        $0.textAlignment = .center
        $0.addCharactersSpacing(value: 26)
    }

    private let getCodeButton = with(UIButton()) {
        $0.setTitle("Get access code", for: .normal)
        $0.titleLabel?.font = AppStyle.current.font(for: .regular, size: 16)
        $0.backgroundColor = AppStyle.current.color(for: .blue)
        $0.layer.cornerRadius = 12
        $0.titleEdgeInsets = UIEdgeInsets(
            top: 16,
            left: 24,
            bottom: 16,
            right: 24
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Private

private extension MainViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.appColor.color(for: .background)
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
    }
}
