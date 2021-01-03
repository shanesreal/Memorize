// Array+Identifiable.swift extends Arrays that are Identifiable

// Foundation framework is required here we need basic types: String, Int, Double, Array, etc.
import Foundation

// Here is an example of constrains and gains, we constrain the don't care type "Element" in "Array" so that they are identifiable. This allows us to gain the firstIndex function.
extension Array where Element: Identifiable {
    // The return type for firstIndex function "Int?" is called an "optional"
    // This means that the function firstIndex may return an Int, again it is completely "optional"
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        // Since the function is returning an "optional" value we can simply call "return nil"
        // Example: https://stackoverflow.com/questions/45229524/return-nil-in-swift-function
        return nil
    }
}
