//
//  Fillable.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

/// Describes object that can be filled with ViewModel.
protocol Fillable {
    /// Representation of the data model that fills the view.
    associatedtype ViewModel

    /// Fills view with view model.
    func fill(with model: ViewModel)
}
