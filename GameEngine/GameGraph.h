//
//  GameGraph.h
//  ps04
//
//  Created by Gu Junchao on 2/12/14.
//
//

#import <Foundation/Foundation.h>
#import "BubbleModel.h"
#import "PhysicsSpace.h"
#import "GraphDelegate.h"

static const CGFloat kTimerInterval = 1.0/60;
static const CGFloat kFiringSpeed = 900;
static const CGFloat kOriginXOfFiringBubble = 352;
static const CGFloat kOriginYOfFiringBubble = 941;
static const CGFloat kRadiusOfFiringBubble = 32;
static const NSInteger kMaximumNumberOfConnectedBubbles = 3;
static const NSInteger kNumberOfItemsInOddRow = 12;
static const NSInteger kNumberOfItemsInEvenRow = 11;
static const NSInteger kNumberOfRows = 13;
static const NSInteger kInvalidItem = -1;
static const NSString *kBubbleToFireIdentifier = @"bubbleToFire";

@interface GameGraph : NSObject <PhysicsSpaceDelegate>

@property (nonatomic) BOOL isReadyToFire;
@property (weak, nonatomic) id<GraphDelegate> delegate;
@property (nonatomic) BOOL stopSimulating;
@property (nonatomic) NSInteger currentFiringColorType;

- (id)initWithFrame:(CGRect)frame;

- (void)update;

- (void)fireGameBubbleInDirection:(CGPoint)direction withColorType:(NSInteger)colorType;

- (void)addGameBubbleAtItem:(NSInteger)item colorType:(NSInteger)colorType center:(CGPoint)center radius:(CGFloat)radius;

- (void)setColorType:(NSInteger)colorType forBubbleModelAndAddToSpaceAtItem:(NSInteger)item;

- (NSInteger)colorTypeForBubbleModelAtIndexPathItem:(NSInteger)item;

@end
