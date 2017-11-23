//
//  SmileyBilliardScene.swift
//  Swift Alps Game Jam
//
//  Created by David Hart on 23.11.17.
//

import SpriteKit

struct SmileyBilliardCategories {
    static let objects: UInt32 = 1
    static let holes: UInt32 = 1 << 1
}

let borderWidth: CGFloat = 20
let holeRadius: CGFloat = 20
let holeOffset: CGFloat = 35

class SmileyBilliardScene: SKScene {
    var yellowBalls: [SKNode] = []
    var redBalls: [SKNode] = []
    var eightBall: SKNode!
    var whiteBall: SKNode!
    var touchBeganLocation: CGPoint?
    var touchShape: SKShapeNode?

    override func sceneDidLoad() {
        super.sceneDidLoad()

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero

        let background = SKSpriteNode(imageNamed: "BilliardBackground.jpg")
        background.position.x = frame.midX
        background.position.y = frame.midY
        background.scale(to: frame.size)
        addChild(background)

        // TOP WALL
        makeWall(rect: .init(
            x: 0,
            y: frame.size.height - borderWidth,
            width: frame.size.width,
            height: borderWidth))
        // BOTTOM WALL
        makeWall(rect: .init(
            x: 0,
            y: 0,
            width: frame.size.width,
            height: borderWidth))
        // LEFT WALL
        makeWall(rect: .init(
            x: 0,
            y: 0,
            width: borderWidth,
            height: frame.size.height))
        // RIGHT WALL
        makeWall(rect: .init(
            x: frame.size.width - borderWidth,
            y: 0,
            width: borderWidth,
            height: frame.size.height))

        // BOTTOM LEFT
        makeHole(position: CGPoint(x: holeOffset, y: holeOffset))
        // BOTTOM RIGHT
        makeHole(position: CGPoint(x: frame.size.width - holeOffset, y: 25))
        // MIDDLE LEFT
        makeHole(position: CGPoint(x: holeOffset, y: frame.size.height / 2))
        // MIDDLE RIGHT
        makeHole(position: CGPoint(x: frame.size.width - holeOffset, y: frame.size.height / 2))
        // TOP LEFT
        makeHole(position: CGPoint(x: holeOffset, y: frame.size.height - holeOffset))
        // TOP RIGHT
        makeHole(position: CGPoint(x: frame.size.width - holeOffset, y: frame.size.height - holeOffset))

        yellowBalls = [
            makeBall(label: "😚", position: CGPoint(x: 40, y: 200)),
            makeBall(label: "🤓", position: CGPoint(x: 80, y: 200)),
            makeBall(label: "😠", position: CGPoint(x: 120, y: 200)),
            makeBall(label: "😞", position: CGPoint(x: 160, y: 200)),
            makeBall(label: "🙄", position: CGPoint(x: 200, y: 200)),
            makeBall(label: "😖", position: CGPoint(x: 240, y: 200)),
            makeBall(label: "🤨", position: CGPoint(x: 280, y: 200)),
        ]

        redBalls = [
            makeBall(label: "😚", position: CGPoint(x: 40, y: 100), hueFactor: -0.3),
            makeBall(label: "🤓", position: CGPoint(x: 80, y: 100), hueFactor: -0.3),
            makeBall(label: "😠", position: CGPoint(x: 120, y: 100), hueFactor: -0.3),
            makeBall(label: "😞", position: CGPoint(x: 160, y: 100), hueFactor: -0.3),
            makeBall(label: "🙄", position: CGPoint(x: 200, y: 100), hueFactor: -0.3),
            makeBall(label: "😖", position: CGPoint(x: 240, y: 100), hueFactor: -0.3),
            makeBall(label: "🤨", position: CGPoint(x: 280, y: 100), hueFactor: -0.3),
        ]

        eightBall = makeBall(label: "🎱", position: .init(x: 300, y: 300))
        whiteBall = makeBall(label: "🏐", position: .init(x: 250, y: 250), physicsOffset: CGPoint(x: 0.2, y: 11.2))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchBeganLocation = touches.first!.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let touchShape = touchShape {
            touchShape.removeFromParent()
        }

        let currentLocation = touches.first!.location(in: self)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: touchBeganLocation!)
        bezierPath.addLine(to: currentLocation)
        touchShape = SKShapeNode(path: bezierPath.cgPath)
        addChild(touchShape!)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if let touchShape = touchShape {
            touchShape.removeFromParent()
        }

        whiteBall.physicsBody!.applyImpulse(impulseVector(with: touches.first!))
    }

    private func impulseVector(with touch: UITouch) -> CGVector {
        guard let touchBeganLocation = touchBeganLocation else { fatalError() }
        return touchBeganLocation - touch.location(in: self)
    }

    @discardableResult
    private func makeBall(
        label: String,
        position: CGPoint,
        hueFactor: CGFloat = 0,
        physicsOffset: CGPoint = CGPoint(x: 0.2, y: 12)) -> SKNode
    {
        let effect = SKEffectNode()
        addChild(effect)
        effect.position = position
        effect.filter = CIFilter(name: "CIHueAdjust", withInputParameters: [
            "inputAngle": CGFloat.pi * hueFactor
            ])

        let physicsBody = SKPhysicsBody(circleOfRadius: 15, center: physicsOffset)
        physicsBody.mass = 0.25
        physicsBody.linearDamping = 0.5
        physicsBody.angularDamping = 0.5
        physicsBody.friction = 0.25
        physicsBody.categoryBitMask = SmileyBilliardCategories.objects
        physicsBody.collisionBitMask = SmileyBilliardCategories.objects
        physicsBody.contactTestBitMask = SmileyBilliardCategories.holes
        effect.physicsBody = physicsBody

        let ball = SKLabelNode(text: label)
        effect.addChild(ball)

        return effect
    }

    @discardableResult
    private func makeWall(rect: CGRect) -> SKNode {
        let wall = SKShapeNode(rect: CGRect(origin: .zero, size: rect.size))
        wall.position = rect.origin
        wall.fillColor = .clear
        wall.strokeColor = .clear

        let physicsBody = SKPhysicsBody(
            rectangleOf: rect.size,
            center: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2))
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = SmileyBilliardCategories.objects
        wall.physicsBody = physicsBody

        addChild(wall)
        return wall
    }

    @discardableResult
    private func makeHole(position: CGPoint) -> SKNode {
        let hole = SKShapeNode(circleOfRadius: holeRadius)
        hole.position = position
        hole.strokeColor = .clear
        hole.fillColor = .black
        addChild(hole)

        let physicsBody = SKPhysicsBody(circleOfRadius: holeRadius)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = SmileyBilliardCategories.holes
        physicsBody.collisionBitMask = 0
        hole.physicsBody = physicsBody

        return hole
    }
}

extension SmileyBilliardScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let ballNode: SKNode
        let holeNode: SKNode
        if contact.bodyA.categoryBitMask == SmileyBilliardCategories.objects {
            ballNode = contact.bodyA.node!
            holeNode = contact.bodyB.node!
        } else {
            ballNode = contact.bodyB.node!
            holeNode = contact.bodyA.node!
        }

        ballNode.run(SKAction.group([
            SKAction.scale(to: 0, duration: 0.5),
            SKAction.move(to: holeNode.position, duration: 0.5)
            ])) {
                ballNode.removeFromParent()
        }
    }
}

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
}

extension CGVector {
    var length: CGFloat {
        return CGFloat(sqrtf(Float(dx * dx + dy * dy)))
    }
}
