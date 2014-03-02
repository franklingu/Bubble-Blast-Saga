//
//  GameGraph.m
//  ps04
//
//  Created by Gu Junchao on 2/12/14.
//
//

#import "GameEngine.h"

@interface GameEngine ()
@property (strong, nonatomic) PhysicsSpace *physicsSpace;
@property (strong, nonatomic) BubbleModelsManager *bubbleModelsManager;
@end

@implementation GameEngine

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.physicsSpace = [[PhysicsSpace alloc] initWithFrame:frame];
        self.physicsSpace.delegate = self;
        self.physicsSpace.timeInterval = kTimerInterval;
        self.isReadyToFire = YES;
        self.stopSimulating = NO;
        self.bubbleModelsManager = [[BubbleModelsManager alloc] init];
    }
    
    return self;
}

- (BOOL)collisionDetectedBetweenCircleShape:(CircleShape *)shapeA andCircleShape:(CircleShape *)shapeB
{
    [self addCellAndRemoveShape:shapeA];
    
    return NO;
}

- (BOOL)collisionDetectedBetweeenCircleShape:(CircleShape *)shape andWall:(NSInteger)wallNumber
{
    if (wallNumber == kUpperWallNumber) {
        [self addCellAndRemoveShape:shape];
        return NO;
    }
    
    return YES;
}

- (void)addCellAndRemoveShape:(CircleShape *)shape
{
    [self.delegate removeGameBubbleViewWithIdentifier:shape.identifier];
    NSInteger item = [self.delegate indexPathItemForLocation:shape.objectBody.position];
    if (!self.stopSimulating) {
        [self.delegate addCellAtItem:item withColorType:self.currentFiringColorType];
        [self setColorType:self.currentFiringColorType forBubbleModelAndAddToSpaceAtItem:item];
        [self checkGraphFromItem:item];
        [self checkForDroping];
        [self.physicsSpace destroyCircleShape:shape];
        if ([self.bubbleModelsManager numberOfVisibleBubbles] == 0) {
            [self.delegate noMoreBubblesVisible];
        }
    }
}

- (void)checkGraphFromItem:(NSInteger)item
{
    NSArray *toBeRemovedBubbles = [self.bubbleModelsManager toBeRemovedBubblesStartingFromItem:item];
    
    for (BubbleModel *model in toBeRemovedBubbles) {
        [self.delegate removeCellAtItem:model.item withColorType:model.colorType];
        model.colorType = kNoDisplayColorType;
        [self.physicsSpace destroyCircleShapeWithIdentifier:[NSString stringWithFormat:@"%d",(int)model.item]];
    }
}

- (void)checkForDroping
{
    NSArray *bubblesToDrop = [self.bubbleModelsManager bubblesToDrop];
    for (BubbleModel *bubble in bubblesToDrop) {
        [self removeShapeAndDropBubble:bubble];
    }
}

- (void)removeShapeAndDropBubble:(BubbleModel *)bubble
{
    CircleShape *circle = [self.physicsSpace circleShapeWithIdentifier:[NSString stringWithFormat:@"%d",(int)bubble.item]];
    [self.physicsSpace destroyCircleShape:circle];
    [self.delegate dropCellAtItem:bubble.item withColorType:bubble.colorType];
    bubble.colorType = kNoDisplayColorType;
}

- (void)update
{
    [self.physicsSpace update];
    if (!self.physicsSpace.positionUpdating) {
        [self.delegate fireBubble];
    }
}

- (void)loadFromFilePath:(NSString *)filePath
{
    [self.bubbleModelsManager loadFromFilePath:filePath];
    NSArray *bubblesToBeDisplayed = [self.bubbleModelsManager bubblesShouldBeDisplayed];
    
    for (BubbleModel *bubble in bubblesToBeDisplayed) {
        [self addShapeByBubble:bubble];
    }
}

- (void)fireGameBubbleInDirection:(CGPoint)direction withColorType:(NSInteger)colorType
{
    self.currentFiringColorType = colorType;
    [self fireGameBubbleAtDirection:direction identifier:kBubbleToFireIdentifier];
}

- (void)fireGameBubbleAtDirection:(CGPoint)direction identifier:(id)identifier
{
    MovableObjectBody *body = [[MovableObjectBody alloc] initWithPosition:CGPointMake(kOriginXOfFiringBubble+kRadiusOfFiringBubble,
                                                                                      kOriginYOfFiringBubble+kRadiusOfFiringBubble)
                                                                     mass:1];
    CGFloat directionLength = pow(pow(direction.x, 2)+pow(direction.y, 2), 0.5);
    CGFloat xVelocity = kFiringSpeed*direction.x/directionLength;
    CGFloat yVelocity = kFiringSpeed*direction.y/directionLength;
    Velocity *velocity = [[Velocity alloc] initWithXVelocity:xVelocity YVelocity:yVelocity];
    body.velocity = velocity;
    CircleShape *circle = [[CircleShape alloc] initWithObjectBody:body radius:kRadiusOfFiringBubble
                                                 uniqueIdentifier:identifier];
    [self.physicsSpace addCircleShape:circle];
}

- (void)circleShape:(CircleShape *)shape positionUpdated:(BOOL)updated
{
    [self.delegate updateGameBubbleViewWithIdentifier:shape.identifier toPosition:shape.objectBody.position];
}

- (void)setColorType:(NSInteger)colorType forBubbleModelAndAddToSpaceAtItem:(NSInteger)item
{
    [self.bubbleModelsManager setColorType:colorType forBubbleModelAtItem:item];
    BubbleModel *bubble = [self.bubbleModelsManager bubbleAtItem:item];
    if (colorType != kNoDisplayColorType) {
        [self addShapeByBubble:bubble];
    }
}

- (void)addShapeByBubble:(BubbleModel *)bubble
{
    MovableObjectBody *body = [[MovableObjectBody alloc] initWithPosition:bubble.center mass:1];
    CircleShape *circle = [[CircleShape alloc] initWithObjectBody:body radius:kRadiusOfFiringBubble
                                                 uniqueIdentifier:[NSString stringWithFormat:@"%d", (int)bubble.item]];
    [self.physicsSpace addCircleShape:circle];
}

- (NSInteger)colorTypeForBubbleModelAtItem:(NSInteger)item
{
    return [self.bubbleModelsManager colorTypeForBubbleAtItem:item];
}

@end
