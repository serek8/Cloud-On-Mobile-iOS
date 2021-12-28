//
//  AppSchemeProperties.swift
//  CloudOnMobile
//
//  Created by Karol P on 28/12/2021.
//

import Foundation

protocol AppSchemeProperties {
    /// Backend host for the app.
    var host: String { get }
}

/// Structure describes properties dependent on app scheme.
struct DefaultAppSchemeProperties: AppSchemeProperties {
    // MARK: - AppSchemeProperties

    let host: String

    // MARK: - Initialization

    /// Initialize app properties based on scheme.
    init() {
        #if DEVELOPMENT
            host = "192.168.50.10"
        #elseif STAGING
            host = "192.168.50.10"
        #elseif PRODUCTION
            host = "cloudon.cc"
        #endif
    }
}
