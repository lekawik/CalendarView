//
//  CalendarView.swift
//  CalendarView
//
//  Created by Soren SAMAMA on 14/07/2022.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {

	// Properties set through init
	var dateRange: DateInterval? = nil
	@Binding var selectedDates: Set<DateComponents?>
	var calendar: Calendar
	var locale: Locale
	var timeZone: TimeZone?

	// Properties set through modifiers
	private var fontDesign: Font.Design = .default
	private var foregroundColor: UIColor? = nil
	private var decorationForDateComponents: ((DateComponents) -> any Decoration)? = nil
	private var allowMultiDateSelection: Bool = false
	private var allowSelectionForDateComponents: ((DateComponents) -> Bool)? = nil
	private var allowDeselectionForDateComponents: ((DateComponents) -> Bool)? = nil

	private let calendarView = UICalendarView()

	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}

	func makeUIView(context: Context) -> UICalendarView {
		calendarView.delegate = context.coordinator
		calendarView.fontDesign = fontDesign.uiKit
		calendarView.wantsDateDecorations = decorationForDateComponents != nil

		calendarView.translatesAutoresizingMaskIntoConstraints = false
		calendarView.widthAnchor.constraint(equalToConstant: 1).isActive = true

		if let foregroundColor {
			calendarView.tintColor = foregroundColor
		}

		if let dateRange {
			calendarView.availableDateRange = dateRange
		}

		let singleDateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
		singleDateSelection.selectedDate = selectedDates.first ?? nil
		let multiDateSelection = UICalendarSelectionMultiDate(delegate: context.coordinator)
		multiDateSelection.selectedDates = selectedDates.compactMap({ $0 })
		calendarView.selectionBehavior = allowMultiDateSelection ? multiDateSelection : singleDateSelection

		return calendarView
	}

	func updateUIView(_ uiView: UICalendarView, context: Context) {
		calendarView.reloadDecorations(forDateComponents: selectedDates.compactMap({ $0 }), animated: false)
	}
}

// MARK: - UICalendarViewDelegate
extension CalendarView {
	class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate, UICalendarSelectionMultiDateDelegate {
		var parent: CalendarView

		init(_ parent: CalendarView) {
			self.parent = parent
		}

		func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
			if let decorationForDateComponents = parent.decorationForDateComponents {
				return decorationForDateComponents(dateComponents)._toUIKitDecoration()
			}
			return nil
		}

		func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
			let previousDate = parent.selectedDates.first ?? nil
			parent.selectedDates = [dateComponents]
			parent.calendarView.reloadDecorations(forDateComponents: parent.selectedDates.inserting(previousDate).compactMap { $0 }, animated: true)
		}

		func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
			if let allowSelectionForDateComponents = parent.allowSelectionForDateComponents, let dateComponents {
				return allowSelectionForDateComponents(dateComponents)
			}
			return true
		}

		func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
			parent.selectedDates.insert(dateComponents)
			parent.calendarView.reloadDecorations(forDateComponents: parent.selectedDates.inserting(dateComponents).compactMap { $0 }, animated: true)
		}

		func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
			parent.selectedDates.remove(dateComponents)
			parent.calendarView.reloadDecorations(forDateComponents: parent.selectedDates.inserting(dateComponents).compactMap { $0 }, animated: true)
		}

		func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
			return parent.allowSelectionForDateComponents?(dateComponents) ?? true
		}

		func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canDeselectDate dateComponents: DateComponents) -> Bool {
			return parent.allowDeselectionForDateComponents?(dateComponents) ?? true
		}
	}
}

// MARK: - Initializers
extension CalendarView {
	init(selection: Binding<Set<DateComponents?>>,
		 in range: DateInterval,
		 calendar: Calendar = .current,
		 locale: Locale = .current,
		 timezone: TimeZone? = nil
	) {
		self._selectedDates = selection
		self.dateRange = range
		self.calendar = calendar
		self.locale = locale
		self.timeZone = timezone
	}

	init(selection: Binding<Set<DateComponents?>>,
		 calendar: Calendar = .current,
		 locale: Locale = .current,
		 timezone: TimeZone? = nil
	) {
		self._selectedDates = selection
		self.calendar = calendar
		self.locale = locale
		self.timeZone = timezone
	}
}

// MARK: - View modifiers
extension CalendarView {
	///	Sets the font design the the calendar view uses for displaying calendar text.
	///
	/// The following example sets the font design of the calendar:
	///
	///		CalendarView(selection: $dates)
	///			.fontDesign(.rounded)
	///
	///	- Parameter design: The design of the text displayed.
	func fontDesign(_ design: Font.Design) -> Self {
		var calendarView = self
		calendarView.fontDesign = design
		return calendarView
	}

	///	Sets the color of the foreground elements displayed by this view.
	///
	/// The following example sets the foreground color of the calendar:
	///
	///		CalendarView(selection: $dates)
	///			.foregroundColor(.systemMint)
	///
	///	- Parameter color: The foreground color to use when displaying the calendar.
	func foregroundColor(_ color: UIColor) -> Self {
		var calendarView = self
		calendarView.foregroundColor = color
		return calendarView
	}

	///	Sets whether the user can select multiple dates at once.
	///
	/// The following example enables multi date selection for the calendar:
	///
	///		CalendarView(selection: $dates)
	///			.allowMultiDateSelection(true)
	///
	///	- Parameter allow: A Boolean value that indicates whether multi date selection is enabled.
	func allowMultiDateSelection(_ allow: Bool) -> Self {
		var calendarView = self
		calendarView.allowMultiDateSelection = allow
		return calendarView
	}

	///	Sets wether the user is allowed to select specied dates.
	///
	/// The following example sets the allowed dates of the calendar:
	///
	///		CalendarView(selection: $dates)
	///			.allowSelection { dateComponents in
	///				return allowedDates.contains(datesComponents)
	///			}
	///
	///	- Parameter selectionFor: A closure passing a date and returning a boolean value.
	func allowSelection(for selectionFor: @escaping (DateComponents) -> Bool) -> Self {
		var calendarView = self
		calendarView.allowSelectionForDateComponents = selectionFor
		return calendarView
	}

	///	Sets wether the user is allowed to deselect specied dates.
	///
	/// The following example sets the allowed dates of the calendar:
	///
	///		CalendarView(selection: $dates)
	///			.allowDeselection { dateComponents in
	///				return allowedDates.contains(datesComponents)
	///			}
	///
	///	- Parameter selectionFor: A closure passing a date and returning a boolean value.
	func allowDeselection(for selectionFor: @escaping (DateComponents) -> Bool) -> Self {
		var calendarView = self
		calendarView.allowDeselectionForDateComponents = selectionFor
		return calendarView
	}

	///	Sets the decoration for a date.
	///
	/// The following example sets the decorations of the calendar:
	///
	///		CalendarView(selection: $dates)
	///			.decoration { dateComponents in
	///				CalendarDecoration()
	///					.foregroundColor(.red)
	///			}
	///
	///	- Parameter decoration: A closure passing a date and returning a decoration.
	func decoration(@CalendarDecorationBuilder _ decorationFor: @escaping (DateComponents) -> (any Decoration)) -> Self {
		var calendarView = self
		calendarView.decorationForDateComponents = decorationFor
		return calendarView
	}
}
