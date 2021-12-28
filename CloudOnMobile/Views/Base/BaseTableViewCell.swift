//
//  BaseTableViewCell.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import UIKit

/// Base view for tableView cells.
class BaseTableViewCell<View: UIView & Fillable>: UITableViewCell, ReusableView, Fillable {
    private let nestedView = View()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }

    @available(*, unavailable) public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // - SeeAlso: Fillable
    func fill(with model: View.ViewModel) {
        nestedView.fill(with: model)
    }
}

// MARK: - Private

private extension BaseTableViewCell {
    func setupViews() {
        contentView.addSubview(nestedView)
        nestedView.addConstraints { [
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equal(.top, priority: UILayoutPriority(999)),
            $0.equal(.bottom, priority: UILayoutPriority(999))
        ] }
    }
}
