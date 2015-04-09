//
//  GameScene.m
//  ChangingLevels
//
//  Created by Jul3ia on 4/8/15.
//  Copyright (c) 2015 Island Pixel Works. All rights reserved.
//

#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

// NODE CATEGORIES //
static const uint32_t playerCategory = 1;
static const uint32_t deathCategory = 2;
static const uint32_t proceedCategory = 4;

@implementation GameScene {
// TOUCHES //
    BOOL touchLeft;
    BOOL touchRight;
    BOOL touchCenter;
}

-(void)didMoveToView:(SKView *)view {
    //set contact delegate
     self.physicsWorld.contactDelegate = self;
    //set up contacts and collisions
    SKNode *hero = [self childNodeWithName:@"Hero"];
    hero.physicsBody.categoryBitMask = playerCategory;
    hero.physicsBody.contactTestBitMask = deathCategory | proceedCategory;
    SKNode *death = [self childNodeWithName:@"GameOver"];
    death.physicsBody.categoryBitMask = deathCategory;
    SKNode *proceed = [self childNodeWithName:@"ProceedToLevelTwo"];
    proceed.physicsBody.categoryBitMask = proceedCategory;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //default all directional touches to OFF, then determine touch and hero locations
    touchLeft = NO;
    touchRight = NO;
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self.scene];
        SKNode *hero = [self childNodeWithName:@"Hero"];
        if ((hero.position.x - 50) >= touchLocation.x) {
            touchLeft = YES;
        } else if ((hero.position.x + 50) <= touchLocation.x) {
            touchRight = YES;
        } else if ((hero.position.x - 50) < touchLocation.x && (hero.position.x + 50) > touchLocation.x) {
            touchCenter = YES;
        } else {
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //default all directional touches to OFF, then determine touch and hero locations
    touchLeft = NO;
    touchRight = NO;
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self.scene];
        SKNode *hero = [self childNodeWithName:@"Hero"];
        if ((hero.position.x - 50) >= touchLocation.x) {
            touchLeft = YES;
        } else if ((hero.position.x + 50) <= touchLocation.x) {
            touchRight = YES;
        } else if ((hero.position.x - 50) < touchLocation.x && (hero.position.x + 50) > touchLocation.x) {
            touchCenter = YES;
        } else {
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //stop hero motion
    touchCenter = NO;
    touchLeft = NO;
    touchRight = NO;
    SKNode *hero = [self childNodeWithName:@"Hero"];
    hero.physicsBody.velocity = CGVectorMake(0.0, 0.0);
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    uint32_t contactQuery = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    //if hero has contacted the death wall...
    if (contactQuery == (playerCategory | deathCategory)) {
        GameOver *gameOver = [GameOver unarchiveFromFile:@"GameOver"];
        [self.view presentScene:gameOver transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
    }
    //if hero has contacted the proceed wall...
    if (contactQuery == (playerCategory | proceedCategory)) {
        SKScene *levelTwo = [LevelTwo unarchiveFromFile:@"LevelTwo"];
        [self.view presentScene:levelTwo transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    SKNode *hero = [self childNodeWithName:@"Hero"];
    if (touchLeft) {
        [hero.physicsBody applyForce:CGVectorMake(-300, 0.0)];
    }
    if (touchRight) {
        [hero.physicsBody applyForce:CGVectorMake(300, 0.0)];
    }
    if (touchCenter) {
        [hero.physicsBody applyImpulse:CGVectorMake(0.0, 0.0)];
    }
}

@end
