import SpriteKit

extension SKScene {
    /// Return the center point of the scene within its own coordinate system
    var center: CGPoint {
        return CGPoint(x: frame.midX, y: frame.midY)
    }

    /// Return a random X position within the scene
    func randomXPosition() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(size.width)))
    }

    /// Return a random Y position iwthin the scene
    func randomYPosition() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(size.height)))
    }
}
