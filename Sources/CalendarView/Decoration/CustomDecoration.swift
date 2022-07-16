//
//  File.swift
//  
//
//  Created by Soren SAMAMA on 16/07/2022.
//

import SwiftUI

/// A decoration that displayes a SwiftUI view.
///
/// Use a ``CustomDecoration`` instance when yout want to add custom views to your calendar.
/// If you plan on using this decoration  to show an image or a circle, prefer using
/// ``ImageDecoration`` and ``CircleDecoration`` respectivly.
public struct CustomDecoration<CustomView: View>: Decoration {
	private var color: UIColor? = .systemFill
	private var size: Size = .medium
	private var customView: CustomView
}

extension CustomDecoration {
	/// Creates a SwiftUI view that you can use as a decoration for your calendar.
	///
	///		CustomDecoration {
	///			Text("✈️")
	///		}
	///
	/// - Parameter customView: The view to use when displaying the decoration.
	public init(@ViewBuilder _ customView: () -> CustomView) {
		self.customView = customView()
	}
}

extension CustomDecoration: BuiltInDecoration {
	internal func UIKitDecoration() -> UICalendarView.Decoration? {
		.customView {
			let hostingController = UIHostingController(rootView: self.customView)
			return hostingController.view
		}
	}
}

extension CustomDecoration {
	/// A type that represent the size of the decoration.
	public typealias Size = UICalendarView.DecorationSize
}

extension CustomDecoration {
	/// Sets the color of the image displayed by this decoration.
	///
	///		CircleDecoration()
	///			.foregroundColor(.red)
	///
	/// - Parameter color: The color to use when displaying the view, defaults to `systemFill`.
	/// - Returns: A custom view decoration that uses the color value you supply.
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
	/// - Returns: A custom view decoration that uses the size value you supply.
	public func decorationSize(_ size: Size) -> Self {
		var decoration = self
		decoration.size = size
		return decoration
	}
}
