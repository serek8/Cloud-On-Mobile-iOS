//
//  FilesPresenter.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/12/2021.
//

import UIKit

final class FilesPresenter: PresenterProtocol {
    weak var viewController: FilesViewControllerProtocol?

    func refreshData() {
        viewController?.fill(
            with: [
                IconTitleSubtitleView.ViewModel(
                    icon: UIImage(imageLiteralResourceName: "illustration"),
                    title: "Title",
                    subtitle: "Subtitle"
                ),
                IconTitleSubtitleView.ViewModel(
                    icon: UIImage(imageLiteralResourceName: "illustration"),
                    title: "Title",
                    subtitle: "Subtitle"
                ),
                IconTitleSubtitleView.ViewModel(
                    icon: UIImage(imageLiteralResourceName: "illustration"),
                    title: "Title",
                    subtitle: "Subtitle"
                ),
                IconTitleSubtitleView.ViewModel(
                    icon: UIImage(imageLiteralResourceName: "illustration"),
                    title: "Title",
                    subtitle: "Subtitle"
                ),
                IconTitleSubtitleView.ViewModel(
                    icon: UIImage(imageLiteralResourceName: "illustration"),
                    title: "Title",
                    subtitle: "Subtitle"
                )
            ]
        )
    }
}
