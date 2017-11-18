import SpriteKit

extension SKNode {
    /// Get or set a custom `userData` value of a given type within the node
    subscript<V>(key: String) -> V? {
        get { return userData?[key] as? V }
        set {
            let data = userData ?? [:]
            data[key] = newValue
            userData = data
        }
    }
}
