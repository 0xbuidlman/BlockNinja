//
//  ShopScene.swift
//  BlockNinjaV2
//
//  Created by Jake on 1/7/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import Foundation
import SpriteKit

class ShopScene: SKScene {

    var throwingStar = SKSpriteNode(imageNamed: "shuriken")
    var arrowUp = SKSpriteNode(imageNamed: "arrowUp")
    var coins = NSUserDefaults.standardUserDefaults().integerForKey("coins")
    let coinImage = SKSpriteNode(imageNamed: "coin")
    let coinImage1 = SKSpriteNode(imageNamed: "coin")
    let coinImage2 = SKSpriteNode(imageNamed: "coin")
    let coinText = SKLabelNode(fontNamed: "CF Samurai Bob")
    let buyThrowingStar = SKSpriteNode(imageNamed: "otherButton")
    let buyRecharge = SKSpriteNode(imageNamed: "otherButton")
    let title = SKLabelNode(fontNamed: "CF Samurai Bob")
    var moving: SKNode!
    var highScoreText = SKLabelNode(fontNamed: "CF Samurai Bob")
    let buyRechargeText = SKLabelNode(fontNamed: "CF Samurai Bob")
    let buyThrowingStarText = SKLabelNode(fontNamed: "CF Samurai Bob")
    let buildings = SKSpriteNode(imageNamed: "buildings")
    var rechargeSpeed = NSUserDefaults.standardUserDefaults().floatForKey("rechargeSpeed")
    var inventory = NSUserDefaults.standardUserDefaults().integerForKey("inventory")
    let backButton = SKSpriteNode(imageNamed: "backArrow")
    var inventoryCostText = SKLabelNode(fontNamed: "CF Samurai Bob")
    var rechargeCostText = SKLabelNode(fontNamed: "CF Samurai Bob")
    var inventoryCost: Int!
    var rechargeCost: Int!
    var activeFade = false
    
    override func didMoveToView(view: SKView) {
        
        var skyColor = SKColor(red: 25.0/255.0, green: 25.0/255.0, blue: 129.0/255.0, alpha: 1.0)
        backgroundColor = skyColor
        buildings.setScale(0.5)
        buildings.position = CGPointMake(frame.size.width/2, buildings.size.height*0.5)
        buildings.zPosition = -10
        self.addChild(buildings)
        showCoins()
        createShop()

        title.alpha = 0.0
        title.fontSize = 56
        title.fontColor = UIColor.whiteColor()
        title.position = CGPoint(x: frame.width/2, y: frame.height/1.15)
        self.addChild(title)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if (CGRectContainsPoint(self.self.frame, touch.locationInNode(backButton))) {
                if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                    let skView = self.view as SKView!
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .AspectFill
                    skView.presentScene(scene)
                }
            }
            
            if (self.nodeAtPoint(location) == self.buyThrowingStar || self.nodeAtPoint(location) == self.buyThrowingStarText || self.nodeAtPoint(location) == self.throwingStar) {
                if (coins > inventoryCost) {
                    coins -= inventoryCost
                    self.coinText.text = String(coins)
                    inventory += 1
                    NSUserDefaults.standardUserDefaults().setInteger(coins, forKey: "coins")
                    NSUserDefaults.standardUserDefaults().setInteger(inventory, forKey: "inventory")
                    pricing()
                } else if (inventory == 3){
                    title.text = "MAX LEVEL"
                    title.alpha = 1.0
                    titleFade()
                } else {
                    title.text = "NOT ENOUGH COINS"
                    title.alpha = 1.0
                    titleFade()
                }
            }
            
            if (self.nodeAtPoint(location) == self.buyRecharge || self.nodeAtPoint(location) == self.buyRechargeText || self.nodeAtPoint(location) == self.arrowUp) {
                if (coins > rechargeCost && rechargeSpeed > 1.5) {
                    coins -= rechargeCost
                    self.coinText.text = String(coins)
                    rechargeSpeed -= 0.5
                    NSUserDefaults.standardUserDefaults().setInteger(coins, forKey: "coins")
                    NSUserDefaults.standardUserDefaults().setFloat(rechargeSpeed, forKey: "rechargeSpeed")
                    pricing()
                } else if (rechargeSpeed == 1.5) {
                    title.text = "MAX LEVEL"
                    title.alpha = 1.0
                    titleFade()
                } else {
                    title.text = "NOT ENOUGH COINS"
                    title.alpha = 1.0
                    titleFade()
                }
            }
        }
    }
    
    func showCoins() {
        coinText.fontSize = 50
        coinText.fontColor = UIColor.whiteColor()
        coinText.text = String(coins)
        coinText.position = CGPointMake(CGRectGetMinX(frame) + (coinImage.size.width * 1.34), CGRectGetMaxY(frame) - (coinImage.size.height/1.5))
        self.addChild(coinText)
        coinImage.setScale(0.5)
        coinImage.position = CGPointMake(CGRectGetMinX(frame) + (coinImage.size.width * 0.7), (CGRectGetMaxY(frame) - (coinImage.size.height * 0.74)))
        self.addChild(coinImage)
        
        coinImage1.setScale(0.5)
        coinImage2.setScale(0.5)
        coinImage1.position = CGPointMake(CGRectGetMinX(frame) + buyThrowingStar.size.width * 2.2, CGRectGetMidY(self.frame) - buyThrowingStar.size.height * 1.4)
        coinImage2.position = CGPointMake(CGRectGetMinX(frame) + buyRecharge.size.width * 2.2, CGRectGetMidY(self.frame) + buyRecharge.size.height * 1.35)
        self.addChild(coinImage1)
        self.addChild(coinImage2)
    }
    
    func createShop() {
        self.buyThrowingStar.setScale(1.4)
        self.buyThrowingStar.position = CGPointMake(CGRectGetMinX(frame) + buyThrowingStar.size.width * 0.7, CGRectGetMidY(self.frame) - buyThrowingStar.size.height)
        self.buyRecharge.setScale(1.4)
        self.buyRecharge.position = CGPointMake(CGRectGetMinX(frame) + buyRecharge.size.width * 0.7, CGRectGetMidY(self.frame) + buyRecharge.size.height)
        self.addChild(self.buyRecharge)
        self.addChild(self.buyThrowingStar)
        self.buyRechargeText.text = ("RECHARGE SPEED")
        buyRechargeText.fontColor = UIColor.blackColor()
        buyRechargeText.fontSize = 30
        buyThrowingStarText.text = ("THROWING STAR")
        buyThrowingStarText.fontColor = UIColor.blackColor()
        buyThrowingStarText.fontSize = 30
        buyRechargeText.position = CGPointMake(0, -self.buyThrowingStar.size.height / 8)
        buyThrowingStarText.position = CGPointMake(0, -self.buyRecharge.size.height / 8)
        self.buyThrowingStar.addChild(buyThrowingStarText)
        self.buyRecharge.addChild(buyRechargeText)
        buyThrowingStar.addChild(throwingStar)
        arrowUp.setScale(0.17)
        buyRecharge.addChild(arrowUp)
        rechargeCostText.fontColor = UIColor.whiteColor()
        inventoryCostText.fontColor = UIColor.whiteColor()
        rechargeCostText.fontSize = 65
        inventoryCostText.fontSize = 65
        pricing()
        inventoryCostText.position = CGPointMake(CGRectGetMinX(frame) + buyThrowingStar.size.width * 1.7, CGRectGetMidY(self.frame) - (buyThrowingStar.size.height * 1.25))
        rechargeCostText.position = CGPointMake(CGRectGetMinX(frame) + buyRecharge.size.width * 1.7, CGRectGetMidY(self.frame) + buyRecharge.size.height * 0.75)
        self.addChild(rechargeCostText)
        self.addChild(inventoryCostText)
        
        backButton.setScale(0.4)
        backButton.position = CGPointMake(CGRectGetMaxX(frame) - backButton.size.width * 0.7, CGRectGetMaxY(frame) - backButton.size.height * 0.7)
        self.addChild(backButton)
    }
    
    func pricing() {
        if (rechargeSpeed == 2.5) {
            rechargeCost = 1000
        } else if (rechargeSpeed == 2.0) {
            rechargeCost = 2000
        } else if (rechargeSpeed == 1.5) {
            rechargeCost = 3000
        }
        rechargeCostText.text = "X    " + String(rechargeCost)

        if (inventory == 1) {
            inventoryCost = 500
        } else if (inventory == 2) {
            inventoryCost = 1500
        }
        inventoryCostText.text = "X    " + String(inventoryCost)
    }
    //Super bootleg fadeout....
    func titleFade() {
        if (!activeFade) {
            activeFade = true
            let fadeOut = SKAction.sequence([SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.9}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.9}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.8}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.7}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.6}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.5}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.4}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.3}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.2}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.1}), SKAction.waitForDuration(0.1), SKAction.runBlock({self.title.alpha = 0.0
                self.activeFade = false})])
            self.runAction(fadeOut)
        }
    }
}

