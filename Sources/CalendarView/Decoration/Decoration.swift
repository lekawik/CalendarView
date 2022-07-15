//
//  Decoration.swift
//  CalendarView
//
//  Created by Soren SAMAMA on 15/07/2022.
//

import UIKit

protocol Decoration {
	associatedtype Body: Decoration
	@CalendarDecorationBuilder var body: Self.Body { get }
}

extension Decoration {
	internal func _toUIKitDecoration() -> UICalendarView.Decoration? {
		if let builtin = self as? BuiltInDecoration {
			return builtin.toUIKitDecoration()
		} else {
			return body._toUIKitDecoration()
		}
	}
}

protocol BuiltInDecoration {
	func toUIKitDecoration() -> UICalendarView.Decoration?
	typealias Body = Never
}

extension Decoration where Body == Never {
	var body: Never { fatalError("This should never be called.") }
}

extension Never: Decoration {
	typealias Body = Never
}
