//
//  File.swift
//  
//
//  Created by Soren SAMAMA on 16/07/2022.
//

import UIKit

/// A decoration that displayes a circle.
///
/// Use a ``CircleDecoration`` instance when yout want to add circles to your calendar.
public struct CircleDecoration: Decoration {
	private var color: UIColor? = .systemFill
	private var size: Size = .medium
}

extension CircleDecoration: BuiltInDecoration {
	internal func UIKitDecoration() -> UICalendarView.Decoration? {
		return .default(color: color, size: size)
	}
}

extension CircleDecoration {
	/// A type that represent the size of the decoration.
	public typealias Size = UICalendarView.DecorationSize
}

extension CircleDecoration {
	/// Sets the color of the image displayed by this decoration.
	///
	///		CircleDecoration()
	///			.foregroundColor(.red)
	///
	/// - Parameter color: The color to use when displaying the image, defaults to `systemFill`.
	/// - Returns: A circle decoration that uses the color value you supply.
	public func foregroundColor(_ color: UIColor) -> Self {
		var decoration = self
		decoration.color = color
		return decoration
	}

	/// Sets the size of the image displayed by this decoration.
	///
	///		CircleDecoration()
	///			.decorationSize(.small)
	///
	/// - Parameter size: One of the sizes specified in the ``Size`` enumeration, defaults to `medium`.
	/// - Returns: A circle decoration that uses the size value you supply.
	public func decorationSize(_ size: Size) -> Self {
		var decoration = self
		decoration.size = size
		return decoration
	}
}

