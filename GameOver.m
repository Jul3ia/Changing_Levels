//
//  GameOver.m
//  ChangingLevels
//
//  Created by Jul3ia on 4/8/15.
//  Copyright (c) 2015 Island Pixel Works. All rights reserved.
//

#import "GameOver.h"

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

@implementation GameOver

-(void)didMoveToView:(SKView *)view {
    //play sound effect
    SKAction *play = [SKAction playSoundFileNamed:@"gameover.caf" waitForCompletion:NO];
    [self runAction:play];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];
    
}

@end
