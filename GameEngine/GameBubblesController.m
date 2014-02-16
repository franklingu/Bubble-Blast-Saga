//
//  GameBubblesController.m
//  ps03
//
//  Created by Gu Junchao on 2/3/14.
//
//

#import "GameBubblesController.h"
#import "Queue.h"
#import "BubbleModel.h"

@interface GameBubblesController ()
@property(strong, nonatomic) NSMutableArray *gameBubbles;
@end

@implementation GameBubblesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bubbleGridArea:(UICollectionView*)aGameGrid
{
    // EFFECTS: return initialized controller with a reference to bubbleGridArea
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.bubbleGridArea = aGameGrid;
        self.gameBubbles = [[NSMutableArray alloc] init];
        self.currentSelectedFillingType = 1;
        self.allModelDataFromFile = nil;
        //[self createGesturesRecognizers];
    }
    return self;
}

- (void)saveCurrentDesignToFile:(NSString *)filePathToSave
{
    [self checkForRemoving];
    [[self allModelData] writeToFile:filePathToSave atomically:YES];
}

- (NSArray*)allModelData
{
    NSMutableArray* allModelData = [[NSMutableArray alloc] init];
    for (BubbleModel *bubbleModel in self.gameBubbles) {
        NSDictionary *dic = [bubbleModel modelData];
        [allModelData addObject:dic];
    }
    
    return  allModelData;
}

- (void)checkForRemoving
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
        [self removeOthersAndKeepBubbles:bubblesVisited];
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
    [self removeOthersAndKeepBubbles:bubblesVisited];
}

- (void)removeOthersAndKeepBubbles:(NSArray *)bubblesToKeep
{
    for (BubbleModel *bubble in self.gameBubbles) {
        if (bubble.colorType != 0 && ![bubblesToKeep containsObject:bubble]) {
            bubble.colorType = 0;
        }
    }
}

- (NSArray *)neighborsWithModelAtItem:(NSInteger)item
{
    NSMutableArray *neighbors = [NSMutableArray new];
    BOOL leftNode = NO;
    BOOL rightNode = NO;
    BOOL oddRow = YES;
    int count = 0;
    
    for (int i=1; i<kNumberOfRows; i++) {
        if (i%2==0) {
            oddRow = NO;
            if (item==count) {
                leftNode=YES;
                break;
            }
            count+=kNumberOfItemsInEvenRow;
            if (item==count-1) {
                rightNode=YES;
                break;
            }
        } else {
            oddRow = YES;
            if (item==count) {
                leftNode=YES;
                break;
            }
            count+=kNumberOfItemsInOddRow;
            if (item==count-1) {
                rightNode=YES;
                break;
            }
        }
    }
    if (leftNode) {
        if (oddRow) {
            [self addModelToNeighbors:neighbors atItem:item-11];
            [self addModelToNeighbors:neighbors atItem:item+1];
            [self addModelToNeighbors:neighbors atItem:item+12];
        } else {
            [self addModelToNeighbors:neighbors atItem:item-12];
            [self addModelToNeighbors:neighbors atItem:item-11];
            [self addModelToNeighbors:neighbors atItem:item+1];
            [self addModelToNeighbors:neighbors atItem:item+11];
            [self addModelToNeighbors:neighbors atItem:item+12];
        }
    } else if (rightNode) {
        if (oddRow) {
            [self addModelToNeighbors:neighbors atItem:item-12];
            [self addModelToNeighbors:neighbors atItem:item-1];
            [self addModelToNeighbors:neighbors atItem:item+11];
        } else {
            [self addModelToNeighbors:neighbors atItem:item-12];
            [self addModelToNeighbors:neighbors atItem:item-11];
            [self addModelToNeighbors:neighbors atItem:item-1];
            [self addModelToNeighbors:neighbors atItem:item+11];
            [self addModelToNeighbors:neighbors atItem:item+12];
        }
    } else {
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

- (void)loadFromFile:(NSString *)filePathToLoad
{
    NSArray *allModelData = [NSArray arrayWithContentsOfFile:filePathToLoad];
    self.allModelDataFromFile = allModelData;
    
    for (id modelData in [allModelData objectEnumerator]) {
        NSDictionary *dic = (NSDictionary*)modelData;
        NSInteger item = [(NSString*)[dic objectForKey:kKeyItem] integerValue];
        NSInteger colorType = [(NSString*)[dic objectForKey:kKeyColorType] integerValue];
        BubbleModel *bubbleModel = [self bubbleModelAtItem:item];
        bubbleModel.colorType = colorType;
    }
    [self.bubbleGridArea reloadData];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint pointerLocation = [sender locationInView:self.bubbleGridArea];
        NSIndexPath* indexPath = [self.bubbleGridArea indexPathForItemAtPoint:pointerLocation];
        BubbleCell* cell= (BubbleCell*)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
        [self alertBubbleAtIndexPathItem:indexPath.item withTap:sender atCell:cell];
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint pointerLocation = [sender locationInView:self.bubbleGridArea];
        NSIndexPath* indexPath = [self.bubbleGridArea indexPathForItemAtPoint:pointerLocation];
        BubbleCell* cell= (BubbleCell*)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
        [self alertBubbleAtIndexPathItem:indexPath.item withLongpress:sender atCell:cell];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded) {
        CGPoint pointerLocation = [sender locationInView:self.bubbleGridArea];
        NSIndexPath *indexPath = [self.bubbleGridArea indexPathForItemAtPoint:pointerLocation];
        BubbleCell *cell= (BubbleCell *)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
        [self alertBubbleArIndexPathItem:indexPath.item withPan:sender atCell:cell];
    }
}

- (void)addGameBubbleAtIndexPathItem:(NSIndexPath *)indexPath andColorType:(NSInteger)aColorType
{
    // EFFECTS: add gameBubble controller to the current gameBubbles
    UICollectionViewLayoutAttributes *attr = [self.bubbleGridArea.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    BubbleModel *bubbleModel = [[BubbleModel alloc] initWithIndexPathItem:indexPath.item colorType:aColorType center:attr.center radius:attr.size.height/2];
    [self.gameBubbles addObject:bubbleModel];
}

- (void)alertBubbleAtIndexPathItem:(NSInteger)aIndexPathItem withTap:(UIGestureRecognizer*)gesture atCell:(BubbleCell*)aCell
{
    // EFFECTS: alert the gameBubble at indexPath with tap gesture. and change the view of cell
    
    BubbleModel *bubbleModel = [self bubbleModelAtItem:aIndexPathItem];
    [self tapOnBubbleModel:bubbleModel];
    [self setColorType:bubbleModel.colorType forCell:aCell];
}

- (void)alertBubbleAtIndexPathItem:(NSInteger)aIndexPathItem withLongpress:(UIGestureRecognizer*)gesture atCell:(BubbleCell*)aCell
{
    // EFFECTS: alert the gameBubble at indexPath with longpress gesture. and change the view of cell
    
    BubbleModel *bubbleModel = [self bubbleModelAtItem:aIndexPathItem];
    [self longPressOnBubbleModel:bubbleModel];
    [self setColorType:bubbleModel.colorType forCell:aCell];
}

- (void)alertBubbleArIndexPathItem:(NSInteger)aIndexPathItem withPan:(UIGestureRecognizer*)gesture atCell:(BubbleCell*)aCell
{
    // EFFECTS: set the color of the gameBubble at the given index path item to be the currentSelectedColor. and change the view of cell
    
    BubbleModel *bubbleModel = [self bubbleModelAtItem:aIndexPathItem];
    [self panOnBubbleModel:bubbleModel];
    [self setColorType:bubbleModel.colorType forCell:aCell];
}

- (BubbleModel *)bubbleModelAtItem:(NSInteger)aIndexPathItem
{
    // EFFECTS: return the game bubble at given index path
    
    for (id  model in self.gameBubbles) {
        BubbleModel *bubbleModel = (BubbleModel *)model;
        if (bubbleModel.item == aIndexPathItem) {
            return bubbleModel;
        }
    }
    
    return nil;
}

- (void)tapOnBubbleModel:(BubbleModel *)bubbleModel
{
    NSInteger color = bubbleModel.colorType;
    if (color==0) {
        return;
    }
    color = (color+1)%5;
    if (color==0) {
        color++;
    }
    bubbleModel.colorType = color;
}

- (void)longPressOnBubbleModel:(BubbleModel *)bubbleModel
{
    bubbleModel.colorType = 0;
}

- (void)panOnBubbleModel:(BubbleModel *)bubbleModel
{
    bubbleModel.colorType = self.currentSelectedFillingType;
}

- (void)setColorType:(NSInteger)aColorType forCell:(BubbleCell*)aCell
{
    // EFFECTS: set the image for the cell based on given colorType
    
    static NSString *blueImageName = @"bubble-blue.png";
    static NSString *redImageName = @"bubble-red.png";
    static NSString *orangeImageName = @"bubble-orange.png";
    static NSString *greenImageName = @"bubble-green.png";
    UIImage *image;
    switch ((int)aColorType) {
        case 0:
            [self clearColorForCell:aCell];
            return;
            break;
        case 1:
            image = [UIImage imageNamed:blueImageName];
            break;
        case 2:
            image = [UIImage imageNamed:redImageName];
            break;
        case 3:
            image = [UIImage imageNamed:orangeImageName];
            break;
        case 4:
            image = [UIImage imageNamed:greenImageName];
            break;
        default:
            [self clearColorForCell:aCell];
            return;
            break;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [aCell setBubbleImage:imageView];
}

- (void)clearColorForCell:(BubbleCell*)aCell
{
    [aCell setBubbleImage:nil];
}

- (void)resetAllBubbles
{
    // EFFECTS: reset all the bubbles in the grid
    
    for (BubbleModel *bubbleModel in self.gameBubbles) {
        bubbleModel.colorType = 0;
    }
    for (BubbleCell* cell in self.bubbleGridArea.visibleCells) {
        [self clearColorForCell:cell];
    }
}

- (void)setColorTypeForCell:(BubbleCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger color = [self bubbleModelAtItem:indexPath.item].colorType;
    [self setColorType:color forCell:cell];
}

@end
