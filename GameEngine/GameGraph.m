//
//  GameGraph.m
//  ps04
//
//  Created by Gu Junchao on 2/12/14.
//
//

#import "GameGraph.h"
#import "Queue.h"

@interface GameGraph ()
@property (strong, nonatomic) PhysicsSpace *physicsSpace;
@property (strong, nonatomic) NSMutableArray *gameBubbles;
@end

@implementation GameGraph

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.physicsSpace = [[PhysicsSpace alloc] initWithFrame:frame];
        self.physicsSpace.delegate = self;
        self.physicsSpace.timeInterval = kTimerInterval;
        self.gameBubbles = [NSMutableArray new];
        self.isReadyToFire = YES;
        self.stopSimulating = NO;
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
    }
}

- (void)checkGraphFromItem:(NSInteger)item
{
    BOOL shouldDestroy = NO;
    NSMutableArray *visited = [NSMutableArray new];
    BubbleModel *startingModel = [self bubbleModelAtItem:item];
    [visited addObject:startingModel];
    Queue *queue = [Queue queue];
    [queue enqueue:startingModel];
    
    while (queue.count > 0) {
        BubbleModel *model = [queue dequeue];
        NSArray *neighbors = [self neighborsWithModelAtItem:model.item];
        for (BubbleModel *neighbor in neighbors) {
            if (neighbor.colorType == model.colorType && ![visited containsObject:neighbor]) {
                [queue enqueue:neighbor];
                [visited addObject:neighbor];
            }
        }
    }
    
    if (visited.count>=kMaximumNumberOfConnectedBubbles) {
        shouldDestroy = YES;
    }
    if (shouldDestroy) {
        for (BubbleModel *model in visited) {
            model.colorType = 0;
            [self.delegate removeCellAtItem:model.item];
            [self.physicsSpace destroyCircleShapeWithIdentifier:[NSString stringWithFormat:@"%d",(int)model.item]];
        }
    }
}

- (void)checkForDroping
{
    BubbleModel *startingModel;
    NSMutableArray *bubblesVisited = [NSMutableArray new];
    Queue *queue = [Queue queue];
    
    for (int i=0; i<kNumberOfItemsInOddRow; i++) {
        BubbleModel *ceilingModel = [self bubbleModelAtItem:i];
        if (ceilingModel.colorType!=0) {
            startingModel = ceilingModel;
            [bubblesVisited addObject:startingModel];
            [queue enqueue:startingModel];
        }
    }
    if (!startingModel) {
        [self dropOthersAndKeepBubbles:bubblesVisited];
        return ;
    }
    
    while (queue.count > 0) {
        BubbleModel *model = [queue dequeue];
        NSArray *neighbors = [self neighborsWithModelAtItem:model.item];
        for (BubbleModel *neighbor in neighbors) {
            if (neighbor.colorType != 0 && ![bubblesVisited containsObject:neighbor]) {
                [queue enqueue:neighbor];
                [bubblesVisited addObject:neighbor];
            }
        }
    }
    [self dropOthersAndKeepBubbles:bubblesVisited];
}

- (void)dropOthersAndKeepBubbles:(NSArray *)bubblesToKeep
{
    for (BubbleModel *bubble in self.gameBubbles) {
        if (bubble.colorType != 0 && ![bubblesToKeep containsObject:bubble]) {
            [self removeShapeAndDropBubble:bubble];
        }
    }
}

- (void)removeShapeAndDropBubble:(BubbleModel *)bubble
{
    CircleShape *circle = [self.physicsSpace circleShapeWithIdentifier:[NSString stringWithFormat:@"%d",(int)bubble.item]];
    [self.physicsSpace destroyCircleShape:circle];
    bubble.colorType = 0;
    [self.delegate dropCellAtItem:bubble.item];
}

- (NSArray *)neighborsWithModelAtItem:(NSInteger)item
{
    NSMutableArray *neighbors = [NSMutableArray new];
    BOOL isLeftNode = NO;
    BOOL isRightNode = NO;
    BOOL isOddRow = YES;
    int count = 0;
    
    // special cases
    for (int i=1; i<kNumberOfRows; i++) {
        if (i%2==0) {
            isOddRow = NO;
            if (item==count) {
                isLeftNode=YES;
                break;
            }
            count+=kNumberOfItemsInEvenRow;
            if (item==count-1) {
                isRightNode=YES;
                break;
            }
        } else {
            isOddRow = YES;
            if (item==count) {
                isLeftNode=YES;
                break;
            }
            count+=kNumberOfItemsInOddRow;
            if (item==count-1) {
                isRightNode=YES;
                break;
            }
        }
    }

    // all the adding--neighbor behaviours are wrapped in addModelToNeighbor method for safety
    if (isLeftNode) {
        if (isOddRow) {    // leftNode at oddRow, three possible neighbors
            [self addModelToNeighbors:neighbors atItem:item-11];
            [self addModelToNeighbors:neighbors atItem:item+1];
            [self addModelToNeighbors:neighbors atItem:item+12];
        } else {    // leftNode at evenRow, five possible neighbors
            [self addModelToNeighbors:neighbors atItem:item-12];
            [self addModelToNeighbors:neighbors atItem:item-11];
            [self addModelToNeighbors:neighbors atItem:item+1];
            [self addModelToNeighbors:neighbors atItem:item+11];
            [self addModelToNeighbors:neighbors atItem:item+12];
        }
    } else if (isRightNode) {
        if (isOddRow) {    // rightNode at oddRow, three possible neighbors
            [self addModelToNeighbors:neighbors atItem:item-12];
            [self addModelToNeighbors:neighbors atItem:item-1];
            [self addModelToNeighbors:neighbors atItem:item+11];
        } else {    // rightNode at oddRow, five possible neighbors
            [self addModelToNeighbors:neighbors atItem:item-12];
            [self addModelToNeighbors:neighbors atItem:item-11];
            [self addModelToNeighbors:neighbors atItem:item-1];
            [self addModelToNeighbors:neighbors atItem:item+11];
            [self addModelToNeighbors:neighbors atItem:item+12];
        }
    } else {    // node in central area, 6 possible neighbors
        [self addModelToNeighbors:neighbors atItem:item-12];
        [self addModelToNeighbors:neighbors atItem:item-11];
        [self addModelToNeighbors:neighbors atItem:item-1];
        [self addModelToNeighbors:neighbors atItem:item+1];
        [self addModelToNeighbors:neighbors atItem:item+11];
        [self addModelToNeighbors:neighbors atItem:item+12];
    }
    
    return neighbors;
}

- (void)addModelToNeighbors:(NSMutableArray *)neighbors atItem:(NSInteger)item
{
    BubbleModel *model = [self bubbleModelAtItem:item];
    if (model) {
        [neighbors addObject:model];
    }
}

- (void)update
{
    [self.physicsSpace update];
    if (!self.physicsSpace.positionUpdating) {
        [self.delegate fireBubble];
    }
}

- (void)fireGameBubbleInDirection:(CGPoint)direction withColorType:(NSInteger)colorType
{
    self.currentFiringColorType = colorType;
    [self fireGameBubbleAtDirection:direction identifier:kBubbleToFireIdentifier];
}

- (void)fireGameBubbleAtDirection:(CGPoint)direction identifier:(id)identifier
{
    MovableObjectBody *body = [[MovableObjectBody alloc] initWithPosition:CGPointMake(352+32, 941+32)
                                                                     mass:1];
    CGFloat directionLength = pow(pow(direction.x, 2)+pow(direction.y, 2), 0.5);
    CGFloat xVelocity = kFiringSpeed*direction.x/directionLength;
    CGFloat yVelocity = kFiringSpeed*direction.y/directionLength;
    Velocity *velocity = [[Velocity alloc] initWithXVelocity:xVelocity YVelocity:yVelocity];
    body.velocity = velocity;
    CircleShape *circle = [[CircleShape alloc] initWithObjectBody:body radius:32
                                                 uniqueIdentifier:identifier];
    [self.physicsSpace addCircleShape:circle];
}

- (void)circleShape:(CircleShape *)shape positionUpdated:(BOOL)updated
{
    [self.delegate updateGameBubbleViewWithIdentifier:shape.identifier toPosition:shape.objectBody.position];
}

- (void)addGameBubbleAtItem:(NSInteger)item colorType:(NSInteger)colorType center:(CGPoint)center radius:(CGFloat)radius
{
    BubbleModel *bubbleModel = [[BubbleModel alloc] initWithIndexPathItem:item colorType:colorType center:center radius:radius];
    [self.gameBubbles addObject:bubbleModel];
    if (bubbleModel.colorType != 0) {
        MovableObjectBody *body = [[MovableObjectBody alloc] initWithPosition:center mass:1];
        CircleShape *circle = [[CircleShape alloc] initWithObjectBody:body radius:32
                                                     uniqueIdentifier:[NSString stringWithFormat:@"%d", (int)item]];
        [self.physicsSpace addCircleShape:circle];
    }
}

- (void)setColorType:(NSInteger)colorType forBubbleModelAndAddToSpaceAtItem:(NSInteger)item
{
    BubbleModel *bubbleModel = [self bubbleModelAtItem:item];
    bubbleModel.colorType = colorType;
    if (colorType != 0) {
        MovableObjectBody *body = [[MovableObjectBody alloc] initWithPosition:bubbleModel.center mass:1];
        CircleShape *circle = [[CircleShape alloc] initWithObjectBody:body radius:32
                                                     uniqueIdentifier:[NSString stringWithFormat:@"%d", (int)item]];
        [self.physicsSpace addCircleShape:circle];
    }
}

- (NSInteger)colorTypeForBubbleModelAtIndexPathItem:(NSInteger)item
{
    return [self bubbleModelAtItem:item].colorType;
}

- (BubbleModel *)bubbleModelAtItem:(NSInteger)item
{
    if (item<0 || item>self.gameBubbles.count) {
        return nil;
    }
    for (id  model in self.gameBubbles) {
        BubbleModel *bubbleModel = (BubbleModel *)model;
        if (bubbleModel.item == item) {
            return bubbleModel;
        }
    }
    
    return nil;
}

@end
