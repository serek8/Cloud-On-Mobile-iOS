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

    /// Backend port for the app.
    var port: Int { get }
}

/// Structure describes properties dependent on app scheme.
struct DefaultAppSchemeProperties: AppSchemeProperties {
    // MARK: - AppSchemeProperties

    let host: String
    let port: Int

    // MARK: - Initialization

    /// Initialize app properties based on scheme.
    init() {
        #if DEVELOPMENT
            host = "cloudon.cc"
            port = 9283
        #elseif STAGING
            host = "cloudon.cc"
            port = 9283
        #elseif PRODUCTION
            host = "cloudon.cc"
            port = 9293
        #endif
    }
}
