//
//  CalendarDecoration.swift
//  CalendarView
//
//  Created by Soren SAMAMA on 14/07/2022.
//

import SwiftUI

public struct CalendarDecoration<CustomView: View>: Decoration {
	private var size: Size = .medium
	private var color: UIColor?
	private var image: UIImage?
	private var customView: CustomView?

	public init(@ViewBuilder customView: () -> CustomView) {
		self.customView = customView()
	}
}

extension CalendarDecoration where CustomView == EmptyView {
	public init() {
		self.color = .systemFill
	}

	public init(image: UIImage?) {
		self.image = image
		self.customView = nil
	}
}

extension CalendarDecoration {
	///	Sets the size of the decoration.
	///
	/// The following example sets the size of the decoration:
	///
	///		CalendarView(selection: $dates)
	///			.decoration { dateComponents in
	///				CalendarDecoration()
	///					.decorationSize(.large)
	///			}
	///
	///	- Parameter size: The size to use when displaying the decoration.
	public func decorationSize(_ size: Size) -> Self {
		var calendarDecoration = self
		calendarDecoration.size = size
		return calendarDecoration
	}

	///	Sets the color of the foreground elements displayed by this view.
	///
	/// The following example sets the foreground color of the decoration:
	///
	///		CalendarView(selection: $dates)
	///			.decoration { dateComponents in
	///				CalendarDecoration()
	///					.foregroundColor(.red)
	///			}
	///
	///	- Parameter color: The foreground color to use when displaying the decoration.
	public func foregroundColor(_ color: UIColor) -> Self {
		var calendarDecoration = self
		calendarDecoration.color = color
		return calendarDecoration
	}
}

extension CalendarDecoration: BuiltInDecoration {
	internal func toUIKitDecoration() -> UICalendarView.Decoration? {
		if let image {
			return .image(image, color: color, size: size)
		}
		if let color {
			return .default(color: color, size: size)
		}
		if let customView {
			return .customView {
				return UIHostingController(rootView: customView).view
			}
		}
		return nil
	}
}

extension CalendarDecoration {
	public typealias Size = UICalendarView.DecorationSize
}
