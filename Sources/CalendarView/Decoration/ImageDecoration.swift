//
//  File.swift
//  
//
//  Created by Soren SAMAMA on 16/07/2022.
//

import UIKit

/// A decoration that displays an image.
///
/// Use an ``ImageDecoration`` instance when you want to add images to your calendar.
public struct ImageDecoration: Decoration {
	private var image: UIImage?
	private var color: UIColor? = .systemFill
	private var size: Size = .medium
}

extension ImageDecoration {
	/// Creates an image that you can use as decoration for your calendar.
	///
	///		ImageDecoration("plane")
	///
	/// - Parameters:
	///   - name: The name of the image resource to lookup.
	///   - bundle: The bundle to seach for the image resource. If `nil`, the image uses the main `Bundle`. Defaults to `nil`.
	public init(_ name: String, bundle: Bundle? = nil) {
		self.image = UIImage(named: name, in: bundle, compatibleWith: nil)
	}

	/// Creates a system symbol image that you can use as decoration for your calendar.
	///
	/// 	ImageDecoration(systemName: "plane")
	///
	/// - Parameter systemName: The name of the system symbol image. Use the SF Symbols app to look up the names of system symbol images.
	public init(systemName: String) {
		self.image = UIImage(systemName: systemName)
	}
}

extension ImageDecoration: BuiltInDecoration {
	internal func UIKitDecoration() -> UICalendarView.Decoration? {
		return .image(image, color: color, size: size)
	}
}

extension ImageDecoration {
	/// A type that represent the size of the decoration.
	public typealias Size = UICalendarView.DecorationSize
}

extension ImageDecoration {
	/// Sets the color of the image displayed by this decoration.
	///
	///		ImageDecoration(systemName: "plane")
	///			.foregroundColor(.red)
	///
	/// - Parameter color: The color to use when displaying the image, defaults to `systemFill`.
	/// - Returns: An image decoration that uses the color value you supply.
	public func foregroundColor(_ color: UIColor) -> Self {
		var decoration = self
		decoration.color = color
		return decoration
	}

	/// Sets the size of the image displayed by this decoration.
	///
	///		ImageDecoration(systemName: "plane")
	///			.decorationSize(.small)
	///
	/// - Parameter size: One of the sizes specified in the ``Size`` enumeration, defaults to `medium`.
	/// - Returns: An image decoration that uses the size value you supply.
	public func decorationSize(_ size: Size) -> Self {
		var decoration = self
		decoration.size = size
		return decoration
	}
}

