//
//  File.swift
//  
//
//  Created by Soren SAMAMA on 16/07/2022.
//

import UIKit

/// A decoration that doesn't contain any content.
public struct EmptyDecoration: Decoration {
	public typealias DecorationBody = Never
}

extension EmptyDecoration: BuiltInDecoration {
	internal func UIKitDecoration() -> UICalendarView.Decoration? {
		return nil
	}
}

