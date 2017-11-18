import Foundation

extension Array {
    /// Pick a random element from the array
    func random() -> Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}
