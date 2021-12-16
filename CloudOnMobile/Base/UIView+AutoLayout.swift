//
//  UIView+AutoLayout.swift
//  PhoneDrive
//
// Based on https://chris.eidhof.nl/post/micro-autolayout-dsl/
// and https://www.netguru.com/blog/painless-nslayoutanchors
//

import UIKit

public typealias ConstraintConstructor = (_ layoutView: UIView) -> NSLayoutConstraint

public extension UIView {
    /// Adds constraints using NSLayoutAnchors, based on description provided in params.
    /// Please refer to helper equal funtions for info how to generate constraints easily.
    ///
    /// - Parameter constraintDescription: closure that returns [Constraint]
    /// - Returns: created constraints
    @discardableResult func addConstraints(constraintDescription: (UIView) -> [ConstraintConstructor]) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [ConstraintConstructor] = constraintDescription(self)
        let nsLayoutConstraints = constraints.map { $0(self) }
        NSLayoutConstraint.activate(nsLayoutConstraints)
        return nsLayoutConstraints
    }

    /// Describes edges that are equal to superview edges
    /// - Returns: created constraints
    func equalEdges() -> [ConstraintConstructor] {
        [
            equal(.top),
            equal(.bottom),
            equal(.leading),
            equal(.trailing)
        ]
    }

    /// Describes constraint that is equal to width or height constant.
    /// Example: `equal(.height, 100) will align view heightAnchor to 100 constant value`
    ///
    /// - Parameters:
    ///   - anchor: constraints key path of current view
    ///   - constant: value
    /// - Returns: created constraint
    func equalConstant<LayoutDimension>(
        _ anchor: KeyPath<UIView, LayoutDimension>,
        _ constant: CGFloat,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        { layoutView in
            layoutView[keyPath: anchor]
                .constraint(equalToConstant: constant)
                .setting(priority: priority)
        }
    }

    // MARK: - equal

    /// Describes constraint that is equal to constraint from superview.
    /// Example: `equal(\.leadingAnchor) will align view leadingAnchor to superview leadingAnchor with defined constant`
    ///
    /// - Parameters:
    ///   - anchor: constraints key path of current view
    ///   - constant: value
    /// - Returns: created constraint
    /// - Warning: This method uses force-unwrap on view's unwrappedSuperview
    func equal<Anchor, Axis>(
        _ anchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutAnchor<Axis> {
        equalTo(unwrappedSuperview, anchor, anchor, constant: constant, priority: priority)
    }

    /// Describes constraint that is equal to constraint from superview.
    /// Example: `equal(\.leadingAnchor) will align view leadingAnchor to superview leadingAnchor`
    ///
    /// - Parameters:
    ///   - anchor: constraints key path of current view
    ///   - constant: value
    /// - Returns: created constraint
    /// - Warning: This method uses force-unwrap on view's unwrappedSuperview
    func equal<Anchor>(
        _ anchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutXAxisAnchor {
        equalTo(unwrappedSuperview, anchor, anchor, constant: constant, priority: priority)
    }

    /// Describes constraint that is equal to constraint from superview.
    /// Example: `equal(\.heightAnchor, multiplier: 0.5) will align view heightAnchor to superview heightAnchor multiplied by 0.5`
    ///
    /// - Parameters:
    ///   - anchor: constraints key path of current view
    ///   - multiplier: value
    /// - Returns: created constraint
    /// - Warning: This method uses force-unwrap on view's unwrappedSuperview
    func equal<LayoutDimension>(
        _ anchor: KeyPath<UIView, LayoutDimension>,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        equalTo(unwrappedSuperview, anchor, anchor, multiplier: multiplier, priority: priority)
    }

    /// Describes constraint that is equal to constraint from other view.
    /// Example: `equalTo(labelView, .centerX, .leading, constant: 16) will align view centerXAnchor to labelView centerXAnchor`
    ///
    /// - Parameters:
    ///   - view: that constrain should relate to
    ///   - fromAnchor: constraints key path of current view
    ///   - toAnchor: constraints key path of related view
    ///   - constant: value
    /// - Returns: created constraint
    func equalTo<Anchor, Axis>(
        _ view: UIView,
        _ fromAnchor: KeyPath<UIView, Anchor>,
        _ toAnchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutAnchor<Axis> {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(equalTo: view[keyPath: toAnchor], constant: constant)
                .setting(priority: priority)
        }
    }

    /// Describes constraint that is equal to constraint from other view.
    /// Example: `equalTo(labelView, \.centerXAnchor) will align view centerXAnchor to superview centerXAnchor`
    ///
    /// - Parameters:
    ///   - view: that constrain should relate to
    ///   - fromAnchor: constraints key path of current view
    ///   - toAnchor: constraints key path of related view
    ///   - constant: value
    /// - Returns: created constraint
    func equalTo<Anchor>(
        _ view: UIView,
        _ fromAnchor: KeyPath<UIView, Anchor>,
        _ toAnchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutXAxisAnchor {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(equalTo: view[keyPath: toAnchor], constant: constant)
                .setting(priority: priority)
        }
    }

    /// Describes constraint that is equal to constraint from other view.
    /// Example: `equalTo(labelView, \.heightAnchor, \.heightAnchor) will align view heightAnchor to labelView heightAnchor`
    ///
    /// - Parameters:
    ///   - view: that constrain should relate to
    ///   - fromAnchor: constraints key path of current view
    ///   - toAnchor: constraints key path of related view
    ///   - multiplier: value
    /// - Returns: created constraint
    func equalTo<LayoutDimension>(
        _ view: UIView,
        _ fromAnchor: KeyPath<UIView, LayoutDimension>,
        _ toAnchor: KeyPath<UIView, LayoutDimension>,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        { layoutView in
            layoutView[keyPath: fromAnchor].constraint(equalTo: view[keyPath: toAnchor], multiplier: multiplier)
                .setting(priority: priority)
        }
    }

    // MARK: - greaterThanOrEqual

    /// Describes constraint that is greater than or equal to constraint from other superview/owningView.
    ///
    /// - Parameters:
    ///   - anchor: Constraints a key path of the receiver element.
    ///   - constant: A value (in points) added to the relation between elements to offset or inset them.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    func greaterThanOrEqual<Anchor, Axis>(
        _ anchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutAnchor<Axis> {
        greaterThanOrEqualTo(unwrappedSuperview, anchor, anchor, constant: constant, priority: priority)
    }

    /// Describes constraint that is greater than or equal to constraint from superview/owningView.
    ///
    /// - Parameters:
    ///   - anchor: Constraints a key path of the receiver element.
    ///   - constant: A value (in points) added to the relation between elements to offset or inset them.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.

    func greaterThanOrEqual<Anchor>(
        _ anchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutXAxisAnchor {
        greaterThanOrEqualTo(unwrappedSuperview, anchor, anchor, constant: constant, priority: priority)
    }

    /// Describes constraint that is greater than or equal to constraint from superview/owningView..
    ///
    /// - Parameters:
    ///   - anchor: Constraints a key path of the receiver element.
    ///   - multiplier: A value applied to the second attribute participating in the constraint.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.
    func greaterThanOrEqual<LayoutDimension>(
        _ anchor: KeyPath<UIView, LayoutDimension>,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        greaterThanOrEqualTo(unwrappedSuperview, anchor, anchor, multiplier: multiplier, priority: priority)
    }

    /// Describes constraint that is greater than or equal to constraint from other view.
    ///
    /// - Parameters:
    ///   - view: that constrain should relate to
    ///   - fromAnchor: constraints key path of current view
    ///   - toAnchor: constraints key path of related view
    ///   - constant: value
    /// - Returns: created constraint
    func greaterThanOrEqualTo<Anchor, Axis>(
        _ view: UIView,
        _ fromAnchor: KeyPath<UIView, Anchor>,
        _ toAnchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutAnchor<Axis> {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(greaterThanOrEqualTo: view[keyPath: toAnchor], constant: constant)
                .setting(priority: priority)
        }
    }

    /// Describes constraint that is greater than or equal to constraint from other view.
    ///
    /// - Parameters:
    ///   - view: that constrain should relate to
    ///   - fromAnchor: constraints key path of current view
    ///   - toAnchor: constraints key path of related view
    ///   - constant: value
    /// - Returns: created constraint
    func greaterThanOrEqualTo<Anchor>(
        _ view: UIView,
        _ fromAnchor: KeyPath<UIView, Anchor>,
        _ toAnchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutXAxisAnchor {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(greaterThanOrEqualTo: view[keyPath: toAnchor], constant: constant)
                .setting(priority: priority)
        }
    }

    /// Describes constraint that is greater than or equal to constraint from other view.
    ///
    /// - Parameters:
    ///   - view: that constrain should relate to
    ///   - fromAnchor: constraints key path of current view
    ///   - toAnchor: constraints key path of related view
    ///   - constant: value
    /// - Returns: created constraint
    func greaterThanOrEqualTo<LayoutDimension>(
        _ view: UIView,
        _ fromAnchor: KeyPath<UIView, LayoutDimension>,
        _ toAnchor: KeyPath<UIView, LayoutDimension>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(greaterThanOrEqualTo: view[keyPath: toAnchor], constant: constant)
                .setting(priority: priority)
        }
    }

    /// Describes constraint that is greater than or equal to constraint from other view.
    ///
    /// - Parameters:
    ///   - view: that constrain should relate to
    ///   - fromAnchor: constraints key path of current view
    ///   - toAnchor: constraints key path of related view
    ///   - multiplier: value
    /// - Returns: created constraint
    func greaterThanOrEqualTo<LayoutDimension>(
        _ view: UIView,
        _ fromAnchor: KeyPath<UIView, LayoutDimension>,
        _ toAnchor: KeyPath<UIView, LayoutDimension>,
        multiplier: CGFloat,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(greaterThanOrEqualTo: view[keyPath: toAnchor], multiplier: multiplier)
                .setting(priority: priority)
        }
    }

    // MARK: - lessThanOrEqual

    /// Describes constraint that is less than or equal to constraint from superview/owningView.
    ///
    /// - Parameters:
    ///   - anchor: Constraints a key path of the receiver element.
    ///   - constant: A value (in points) added to the relation between elements to offset or inset them.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.
    func lessThanOrEqual<Anchor, Axis>(
        _ anchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutAnchor<Axis> {
        lessThanOrEqualTo(unwrappedSuperview, anchor, anchor, constant: constant, priority: priority)
    }

    /// Describes constraint that is less than or equal to constraint from superview/owningView.
    ///
    /// - Parameters:
    ///   - anchor: Constraints a key path of the receiver element.
    ///   - constant: A value (in points) added to the relation between elements to offset or inset them.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.
    func lessThanOrEqual<Anchor>(
        _ anchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutXAxisAnchor {
        lessThanOrEqualTo(unwrappedSuperview, anchor, anchor, constant: constant, priority: priority)
    }

    /// Describes constraint that is less than or equal to constraint from superview/owningView.
    ///
    /// - Parameters:
    ///   - anchor: Constraints a key path of the receiver element.
    ///   - multiplier: A value applied to the second attribute participating in the constraint.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.
    func lessThanOrEqual<LayoutDimension>(
        _ anchor: KeyPath<UIView, LayoutDimension>,
        multiplier: CGFloat = 1,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        lessThanOrEqualTo(unwrappedSuperview, anchor, anchor, multiplier: multiplier, priority: priority)
    }

    /// Describes constraint that is less than or equal to constraint from other element.
    ///
    /// - Parameters:
    ///   - element: An element to which the receiver should be related to.
    ///   - fromAnchor: Constraints a key path of the receiver element.
    ///   - toAnchor: Constraints a key path of a given element to which the receiver should be related to.
    ///   - constant: A value (in points) added to the relation between elements to offset or inset them.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.
    func lessThanOrEqualTo<Anchor, Axis>(
        _ element: UIView,
        _ fromAnchor: KeyPath<UIView, Anchor>,
        _ toAnchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutAnchor<Axis> {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(lessThanOrEqualTo: element[keyPath: toAnchor], constant: constant)
                .setting(priority: priority)
        }
    }

    /// Describes constraint that is less than or equal to constraint from other element.
    ///
    /// - Parameters:
    ///   - element: An element to which the receiver should be related to.
    ///   - fromAnchor: Constraints a key path of the receiver element.
    ///   - toAnchor: Constraints a key path of a given element to which the receiver should be related to.
    ///   - constant: A value (in points) added to the relation between elements to offset or inset them.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.
    func lessThanOrEqualTo<Anchor>(
        _ element: UIView,
        _ fromAnchor: KeyPath<UIView, Anchor>,
        _ toAnchor: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where Anchor: NSLayoutXAxisAnchor {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(lessThanOrEqualTo: element[keyPath: toAnchor], constant: constant)
                .setting(priority: priority)
        }
    }

    /// Describes constraint that is less than or equal to constraint from other element.
    ///
    /// - Parameters:
    ///   - element: An element to which the receiver should be related to.
    ///   - fromAnchor: Constraints a key path of the receiver element.
    ///   - toAnchor: Constraints a key path of a given element to which the receiver should be related to.
    ///   - constant: A value (in points) added to the relation between elements to offset or inset them.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.
    func lessThanOrEqualTo<LayoutDimension>(
        _ element: UIView,
        _ fromAnchor: KeyPath<UIView, LayoutDimension>,
        _ toAnchor: KeyPath<UIView, LayoutDimension>,
        constant: CGFloat = 0,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(lessThanOrEqualTo: element[keyPath: toAnchor], constant: constant)
                .setting(priority: priority)
        }
    }

    /// Describes constraint that is less than or equal to constraint from other element.
    ///
    /// - Parameters:
    ///   - element: An element to which the receiver should be related to.
    ///   - fromAnchor: Constraints a key path of the receiver element.
    ///   - toAnchor: Constraints a key path of a given element to which the receiver should be related to.
    ///   - multiplier: A value applied to the second attribute participating in the constraint.
    ///   - priority: A layout priority used to indicate the relative importance of constraints.
    /// - Returns: Created constraint.
    func lessThanOrEqualTo<LayoutDimension>(
        _ element: UIView,
        _ fromAnchor: KeyPath<UIView, LayoutDimension>,
        _ toAnchor: KeyPath<UIView, LayoutDimension>,
        multiplier: CGFloat,
        priority: UILayoutPriority? = nil
    ) -> ConstraintConstructor where LayoutDimension: NSLayoutDimension {
        { layoutView in
            layoutView[keyPath: fromAnchor]
                .constraint(lessThanOrEqualTo: element[keyPath: toAnchor], multiplier: multiplier)
                .setting(priority: priority)
        }
    }
}

// MARK: - KeyPaths

public extension KeyPath where Root == UIView, Value == NSLayoutYAxisAnchor {
    static var top: KeyPath<UIView, NSLayoutYAxisAnchor> {
        \.topAnchor
    }

    static var bottom: KeyPath<UIView, NSLayoutYAxisAnchor> {
        \.bottomAnchor
    }

    static var safeAreaTop: KeyPath<UIView, NSLayoutYAxisAnchor> {
        \.safeAreaLayoutGuide.topAnchor
    }

    static var safeAreaBottom: KeyPath<UIView, NSLayoutYAxisAnchor> {
        \.safeAreaLayoutGuide.bottomAnchor
    }

    static var centerY: KeyPath<UIView, NSLayoutYAxisAnchor> {
        \.centerYAnchor
    }
}

public extension KeyPath where Root == UIView, Value == NSLayoutXAxisAnchor {
    static var leading: KeyPath<UIView, NSLayoutXAxisAnchor> {
        \.leadingAnchor
    }

    static var trailing: KeyPath<UIView, NSLayoutXAxisAnchor> {
        \.trailingAnchor
    }

    static var centerX: KeyPath<UIView, NSLayoutXAxisAnchor> {
        \.centerXAnchor
    }
}

public extension KeyPath where Root == UIView, Value == NSLayoutDimension {
    static var width: KeyPath<UIView, NSLayoutDimension> {
        \.widthAnchor
    }

    static var height: KeyPath<UIView, NSLayoutDimension> {
        \.heightAnchor
    }
}

// MARK: - Private

private extension UIView {
    var unwrappedSuperview: UIView {
        precondition(superview != nil, "View not added to views hierarchy.")
        return superview!
    }
}

private extension NSLayoutConstraint {
    func setting(priority: UILayoutPriority?) -> Self {
        priority.flatMap { self.priority = $0 }
        return self
    }
}
