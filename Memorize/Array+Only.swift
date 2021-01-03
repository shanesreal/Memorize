// Array+Only.swift extends all Arrays. Not: (Array+Identifiable)

// Foundation framework is required here we need basic types: String, Int, Double, Array, etc.
import Foundation

extension Array {
    var only: Element? {
        // return the first item in the array otherwise, nil
        count == 1 ? first : nil
    }
}
