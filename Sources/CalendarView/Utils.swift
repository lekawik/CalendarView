//
//  Utils.swift
//  CalendarView
//
//  Created by Soren SAMAMA on 15/07/2022.
//

import SwiftUI

extension Set {
	func inserting(_ element: Element) -> Self {
		var set = self
		set.insert(element)
		return set
	}
}

extension Font.Design {
	var uiKit: UIFontDescriptor.SystemDesign {
		switch self {
		case .serif:
			return .serif
		case .rounded:
			return .rounded
		case .monospaced:
			return .monospaced
		default:
			return .default
		}
	}
}
