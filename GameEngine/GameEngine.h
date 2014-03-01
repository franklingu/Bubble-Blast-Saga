//
//  GameGraph.h
//  ps04
//
//  Created by Gu Junchao on 2/12/14.
//
//

#import <Foundation/Foundation.h>
#import "BubbleModelsManager.h"
#import "PhysicsSpace.h"
#import "GameEngineDelegate.h"

@interface GameEngine : NSObject <PhysicsSpaceDelegate>

@property (nonatomic) BOOL isReadyToFire;
@property (weak, nonatomic) id<GameEngineDelegate> delegate;
@property (nonatomic) BOOL stopSimulating;
@property (nonatomic) NSInteger currentFiringColorType;

- (id)initWithFrame:(CGRect)frame;

- (void)update;

- (void)loadFromFilePath:(NSString *)filePath;

- (void)fireGameBubbleInDirection:(CGPoint)direction withColorType:(NSInteger)colorType;

- (NSInteger)colorTypeForBubbleModelAtItem:(NSInteger)item;

@end
