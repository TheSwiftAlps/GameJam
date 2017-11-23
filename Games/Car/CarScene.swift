//
//  CarScene.swift
//  Swift Alps Game Jam
//
//  Created by Noé on 23.11.17.
//

import Foundation
import SpriteKit

final class CarScene: SKScene {
    let player = SKSpriteNode(imageNamed: "Car")
    let car = SKLabelNode(text: "🚘")
    let borderColor = UIColor.green

    lazy var leftBorder = makeLeftBorder()
    lazy var rightBorder = makeRightBorder()

    override func sceneDidLoad() {
        super.sceneDidLoad()

        addChild(leftBorder)

        addChild(rightBorder)

        car.setScale(1)
        car.verticalAlignmentMode = .center
        car.position.x = size.width / 2
        car.position.y = 40
        addChild(car)
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        if car.position.x - (car.frame.size.width / 2) < leftBorder.frame.maxX + 1 {
            car.position.x = car.position.x + 1
            car.removeAllActions()
        } else if car.position.x + (car.frame.size.width / 2) > rightBorder.frame.minX - 1 {
            car.position.x = car.position.x - 1
            car.removeAllActions()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let location = touches.first?.location(in: self) else { return }

        if location.x > car.position.x {
            car.run(.repeatForever(.move(by: CGVector(dx: +10, dy: 0) , duration: 0.1)))
        } else {
            car.run(.repeatForever(.move(by: CGVector(dx: -10, dy: 0) , duration: 0.1)))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        car.removeAllActions()
    }

    private func makeLeftBorder() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: 100, height: size.height)
        let border = SKShapeNode(rect: rect)

        border.fillColor = borderColor
        border.strokeColor = borderColor

        return border
    }

    private func makeRightBorder() -> SKShapeNode {
        let rect = CGRect(x: size.width - 100, y: 0, width: size.width, height: size.height)
        let border = SKShapeNode(rect: rect)

        border.fillColor = borderColor
        border.strokeColor = borderColor

        return border
    }
}

