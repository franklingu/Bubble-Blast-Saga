//
//  BubbleModels.m
//  Bubble Blast Saga
//
//  Created by Gu Junchao on 2/18/14.
//
//

#import "BubbleModelsManager.h"
#import "Queue.h"

@interface BubbleModelsManager ()
@property (nonatomic) NSMutableArray *bubbles;
@end

@implementation BubbleModelsManager

- (id)init
{
    self = [super init];
    if (self) {
        self.bubbles = [NSMutableArray new];
    }
    
    return self;
}

- (id)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        self.bubbles = [NSMutableArray new];
        [self loadFromFilePath:filePath];
    }
    
    return self;
}

- (void)saveToFilePath:(NSString *)filePath
{
    [[self allModelData] writeToFile:filePath atomically:YES];
}

- (void)loadFromFilePath:(NSString *)filePath
{
    NSArray *allModelData = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary *modelData in [allModelData objectEnumerator]) {
        BubbleModel *bubble = [BubbleModel bubbleModelFromDic:modelData];
        BubbleModel *bubbleToChange = [self bubbleAtItem:bubble.item];
        if (bubbleToChange) {
            bubbleToChange.colorType = bubble.colorType;
            bubbleToChange.center = bubble.center;
            bubbleToChange.radius = bubble.radius;
        } else {
            [self.bubbles addObject:bubble];
        }
    }
}

- (NSArray*)allModelData
{
    NSMutableArray* allModelData = [[NSMutableArray alloc] init];
    for (BubbleModel *bubbleModel in self.bubbles) {
        NSDictionary *dic = [bubbleModel modelData];
        [allModelData addObject:dic];
    }
    
    return  allModelData;
}

- (void)addBubbleAtItem:(NSInteger)item colorType:(NSInteger)colorType center:(CGPoint)center radius:(CGFloat)radius
{
    BubbleModel *bubble = [self bubbleAtItem:item];
    if (bubble) {
        bubble.colorType = colorType;
        bubble.center = center;
        bubble.radius = radius;
    } else {
        BubbleModel *bubbleToAdd = [[BubbleModel alloc] initWithIndexPathItem:item colorType:colorType center:center radius:radius];
       [self.bubbles addObject:bubbleToAdd];
    }
}

- (BubbleModel *)bubbleAtItem:(NSInteger)item
{
    for (BubbleModel *bubble in self.bubbles) {
        if (bubble.item == item) {
            return bubble;
        }
    }
    
    return nil;
}

- (NSArray *)bubblesShouldBeDisplayed
{
    NSMutableArray *bubblesToReturn = [NSMutableArray new];
    
    for (BubbleModel *bubble in self.bubbles) {
        if (bubble.colorType != kNoDisplayColorType) {
            [bubblesToReturn addObject:bubble];
        }
    }
    
    return bubblesToReturn;
}

- (NSInteger)colorTypeForBubbleAtItem:(NSInteger)item
{
    return [self bubbleAtItem:item].colorType;
}

- (void)setColorType:(NSInteger)colorType forBubbleModelAtItem:(NSInteger)item
{
    [self bubbleAtItem:item].colorType = colorType;
}

- (void)resetAllBubbles
{
    for (BubbleModel *bubble in self.bubbles) {
        bubble.colorType = kNoDisplayColorType;
    }
}

- (BOOL)isValidGraph
{
    if ([self bubblesToDrop].count > 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSArray *)sameColorConnectedBubblesFromItem:(NSInteger)item
{
    NSMutableArray *visited = [NSMutableArray new];
    BubbleModel *startingModel = [self bubbleAtItem:item];
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
    
    return visited;
}

- (NSArray *)bubblesToDrop
{
    BubbleModel *startingModel;
    NSMutableArray *bubblesVisited = [NSMutableArray new];
    Queue *queue = [Queue queue];
    
    for (int i=0; i<kNumberOfItemsInOddRow; i++) {
        BubbleModel *ceilingModel = [self bubbleAtItem:i];
        if (ceilingModel.colorType!=0) {
            startingModel = ceilingModel;
            [bubblesVisited addObject:startingModel];
            [queue enqueue:startingModel];
        }
    }
    if (!startingModel) {
        return [self dropOthersAndKeepBubbles:bubblesVisited];
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
    
    return [self dropOthersAndKeepBubbles:bubblesVisited];
}

- (NSArray *)dropOthersAndKeepBubbles:(NSArray *)bubblesToKeep
{
    NSMutableArray *others = [NSMutableArray new];
    
    for (BubbleModel *bubble in self.bubbles) {
        if (bubble.colorType != kNoDisplayColorType) {
            if (![bubblesToKeep containsObject:bubble]) {
                [others addObject:bubble];
            }
        }
    }
    
    return others;
}

- (NSArray *)neighborsWithModelAtItem:(NSInteger)item
{
    NSMutableArray *neighbors = [NSMutableArray new];
    BOOL isLeftNode = NO;
    BOOL isRightNode = NO;
    BOOL isOddRow = YES;
    int count = 0;
    
    // special cases
    for (int i=1; i<13; i++) {
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
    BubbleModel *model = [self bubbleAtItem:item];
    if (model) {
        [neighbors addObject:model];
    }
}

@end
