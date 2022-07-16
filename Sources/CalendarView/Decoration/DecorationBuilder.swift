//
//  DecorationBuilder.swift
//  SwiftUITests
//
//  Created by Soren SAMAMA on 15/07/2022.
//

import UIKit

/// A custom parameter attribute that constructs decorations from closures.
@resultBuilder public struct DecorationBuilder {

	/// Builds an empty decoration from a block containing no statements.
	public static func buildBlock() -> EmptyDecoration {
		EmptyDecoration()
	}

	/// Passes a single decoration as a child decoration through unmodified.
	///
	/// An example of a single view written as a child view is
	///  `{ CircleDecoration() }`
	public static func buildBlock<Content: Decoration>(_ content: Content) -> Content {
		content
	}

	/// Provides support for “if” statements in multi-statement closures,
	/// producing an optional view that is visible only when the condition
	/// evaluates to `true`.
	public static func buildOptional<Content: Decoration>(_ content: Content?) -> _OptionalContent<Content> {
		_OptionalContent(content: content)
	}

	/// Provides support for "if" statements in multi-statement closures,
	/// producing conditional content for the "then" branch.
	public static func buildEither<TrueContent: Decoration, FalseContent: Decoration>(first: TrueContent) -> _ConditionalDecoration<TrueContent, FalseContent> {
		_ConditionalDecoration(storage: .trueContent(first))
	}

	/// Provides support for "if-else" statements in multi-statement closures,
	/// producing conditional content for the "else" branch.
	public static func buildEither<TrueContent: Decoration, FalseContent: Decoration>(second: FalseContent) -> _ConditionalDecoration<TrueContent, FalseContent> {
		_ConditionalDecoration(storage: .falseContent(second))
	}
}

public struct _ConditionalDecoration<TrueContent: Decoration, FalseContent: Decoration>: Decoration, BuiltInDecoration {
	internal enum Content {
		case trueContent(TrueContent)
		case falseContent(FalseContent)
	}

	internal var storage: Content

	internal func UIKitDecoration() -> UICalendarView.Decoration? {
		switch storage {
		case .trueContent(let content):
			return content._UIKitDecoration()
		case .falseContent(let content):
			return content._UIKitDecoration()
		}
	}
}

public struct _OptionalContent<Content: Decoration>: Decoration, BuiltInDecoration {
	internal var content: Content?

	internal func UIKitDecoration() -> UICalendarView.Decoration? {
		if let content {
			return content._UIKitDecoration()
		} else {
			return nil
		}
	}
}
