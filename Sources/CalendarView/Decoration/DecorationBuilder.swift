//
//  DecorationBuilder.swift
//  SwiftUITests
//
//  Created by Soren SAMAMA on 15/07/2022.
//

import UIKit

@resultBuilder
public struct DecorationBuilder {
	public static func buildBlock() -> EmptyDecoration {
		EmptyDecoration()
	}

	public static func buildBlock<Content: Decoration>(_ content: Content) -> Content {
		content
	}

	public static func buildOptional<Content: Decoration>(_ content: Content?) -> _OptionalContent<Content> {
		_OptionalContent(content: content)
	}

	public static func buildEither<TrueContent: Decoration, FalseContent: Decoration>(first: TrueContent) -> _ConditionalDecoration<TrueContent, FalseContent> {
		_ConditionalDecoration(storage: .trueContent(first))
	}

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
