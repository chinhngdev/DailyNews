//
//  RawRepresentable.swift
//  DailyNews
//
//  Created by ChinhNT on 5/12/24.
//

import Foundation

extension RawRepresentable {
    /// Returns the raw value of this instance.
    ///
    /// This method enables function-call syntax for accessing the raw value of a `RawRepresentable` instance.
    ///
    /// ```swift
    /// enum Direction: String {
    ///     case north = "N"
    ///     case south = "S"
    /// }
    ///
    /// let direction = Direction.north
    /// let value = direction() // Returns "N"
    /// ```
    ///
    /// - Returns: The raw value of this instance.
    ///
    /// - Note: This is equivalent to accessing the `rawValue` property directly.
    public func callAsFunction() -> RawValue {
        return self.rawValue
    }
}
