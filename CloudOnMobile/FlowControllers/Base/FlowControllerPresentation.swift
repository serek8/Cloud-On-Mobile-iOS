//
//  FlowControllerPresentation.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import UIKit

enum FlowControllerPresentation {
    case modal(style: UIModalPresentationStyle)
    case push
    /// Root case is used for root flow controller, which is initialized from window.
    case root
}
