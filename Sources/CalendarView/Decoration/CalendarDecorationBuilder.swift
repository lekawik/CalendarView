//
//  CalendarDecorationBuilder.swift
//  CalendarView
//
//  Created by Soren SAMAMA on 14/07/2022.
//

import SwiftUI

@resultBuilder
struct CalendarDecorationBuilder {
	static func buildBlock() -> EmptyDecoration {
		return EmptyDecoration()
	}

	static func buildBlock(_ components: any Decoration...) -> any Decoration {
		return components.first ?? EmptyDecoration()
	}

	static func buildOptional(_ component: (any Decoration)?) -> any Decoration {
		return component == nil ? EmptyDecoration() : component!
	}

	static func buildEither(first component: any Decoration) -> any Decoration {
		return component
	}

	static func buildEither(second component: any Decoration) -> any Decoration {
		return component
	}
}

struct EmptyDecoration: Decoration, BuiltInDecoration {
	var body: some Decoration {
		CalendarDecoration {
			Text("")
		}
	}

	func toUIKitDecoration() -> UICalendarView.Decoration? {
		return nil
	}
}
