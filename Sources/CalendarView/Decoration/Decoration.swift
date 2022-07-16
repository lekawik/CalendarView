//
//  Decoration.swift
//  CalendarView
//
//  Created by Soren SAMAMA on 15/07/2022.
//

import UIKit

/// A type that represents part of your calendar's decorations and provides modifier that you can use to configure decorations.
public protocol Decoration {

	/// The type of decoration representing the body of this decoration
	associatedtype DecorationBody: Decoration

	/// The content of the decoration.
	@DecorationBuilder var body: Self.DecorationBody { get }
}

extension Decoration where DecorationBody == Never {
	public var body: Never { fatalError("This should never be called.") }
}

internal protocol BuiltInDecoration {
	func UIKitDecoration() -> UICalendarView.Decoration?
}

extension BuiltInDecoration {
	public typealias DecorationBody = Never
}

extension Never: Decoration {
	public typealias DecorationBody = Never
}

extension Decoration {
	internal func _UIKitDecoration() -> UICalendarView.Decoration? {
		if let builtIn = self as? BuiltInDecoration {
			return builtIn.UIKitDecoration()
		} else {
			return body._UIKitDecoration()
		}
	}
}
