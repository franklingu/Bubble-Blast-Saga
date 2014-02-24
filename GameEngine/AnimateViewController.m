//
//  AnimateViewController.m
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import "AnimateViewController.h"
#import "GameBubbleCell.h"

@interface AnimateViewController ()
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) GameGraph *gameGraph;
@property (nonatomic) UIView *bubbleToFire;
@property (nonatomic) UIView *nextBubble;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSMutableArray *itemsToRemove;
@property (nonatomic) NSMutableArray *itemsToDrop;
@property (nonatomic) BOOL isGameOver;
@property (nonatomic) BOOL isReadyForFiring;
@property (nonatomic) CGPoint firingDirection;
@property (nonatomic) NSInteger currentFiringType;
@property (nonatomic) NSInteger nextFiringType;
@property (nonatomic) NSString *filePath;
@end

@implementation AnimateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self initializeAttributes];
    [self setUpMainViews];
}

- (void)initializeAttributes
{
    CGRect frame = self.gameArea.frame;
    frame.origin.y=25;
    self.gameGraph = [[GameGraph alloc] initWithFrame:frame];
    self.gameGraph.delegate = self;
    [self.gameGraph loadFromFilePath:self.filePath];
    self.numberOfRows = 13;
    self.itemsToRemove = [NSMutableArray new];
    self.itemsToDrop = [NSMutableArray new];
    self.isGameOver = NO;
    self.isReadyForFiring = NO;
    self.currentFiringType = 1;
    [self produceNextFiringType];
}

- (void)produceNextFiringType
{
    int num = rand()%kNumberOfBubbleModelKinds;
    if (num == 0) {
        num++;
    }
    self.nextFiringType = num;
}

- (void)setUpMainViews
{
    UIImage* backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView* background = [[UIImageView alloc] initWithImage:backgroundImage];
    CGFloat gameViewWidth = self.gameArea.frame.size.width;
    CGFloat gameViewHeight = self.gameArea.frame.size.height;
    background.frame = CGRectMake(0, 0, gameViewWidth, gameViewHeight);
    [self.gameArea addSubview:background];
    
    [self.bubbleGridArea registerClass:[GameBubbleCell class] forCellWithReuseIdentifier:@"gameBubbleCell"];
    self.bubbleGridArea.layer.zPosition = 1;
    [self.bubbleGridArea setDataSource:self];
    [self.bubbleGridArea setDelegate:self];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    [self.bubbleGridArea addGestureRecognizer:recognizer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                                  target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    [self drawBubbleToFireAndNextBubble];
}

- (void)drawBubbleToFireAndNextBubble
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithColorType:self.currentFiringType]];
    imageView.frame = CGRectMake(kOriginXOfFiringBubble, kOriginYOfFiringBubble,
                                 kRadiusOfFiringBubble*2, kRadiusOfFiringBubble*2);
    imageView.layer.zPosition = 2;
    self.bubbleToFire = imageView;
    self.bubbleToFire.alpha = 1;
    [self.view addSubview:self.bubbleToFire];
    UIImageView *nextBubble = [[UIImageView alloc] initWithImage:[self imageWithColorType:self.nextFiringType]];
    nextBubble.frame = CGRectMake(kOriginXOfNextFiringBubble, kOriginYOfFiringBubble,
                                  kRadiusOfFiringBubble*2, kRadiusOfFiringBubble*2);
    self.nextBubble = nextBubble;
    self.nextBubble.alpha = 0.7;
    [self.view addSubview:self.nextBubble];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        if (!self.isGameOver) {
            CGPoint tapPoint = [tap locationInView:self.bubbleGridArea];
            CGPoint direction = CGPointMake(tapPoint.x-kOriginXOfFiringBubble-kRadiusOfFiringBubble,
                                            tapPoint.y-kOriginYOfFiringBubble-kRadiusOfFiringBubble);

            if (direction.y < kMaximumYReplacement) {   // if only smaller than maximum replacement
                self.firingDirection = direction;
                self.isReadyForFiring = YES;
            }
        }
    }
}

- (void)configureLoadingFilePathByFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePathToLoad = [documentsPath stringByAppendingPathComponent:fileName];
    self.filePath = filePathToLoad;
}

- (void)setColorType:(NSInteger)colorType forCell:(GameBubbleCell *)aCell
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithColorType:colorType]];
    [aCell setBubbleImage:imageView];
}

- (UIImage *)imageWithColorType:(NSInteger)colorType
{
    UIImage *image;
    switch ((int)colorType) {
        case 0:
            image = nil;
            break;
        case 1:
            image = [UIImage imageNamed:kBlueImageName];
            break;
        case 2:
            image = [UIImage imageNamed:kRedImageName];
            break;
        case 3:
            image = [UIImage imageNamed:kOrangeImageName];
            break;
        case 4:
            image = [UIImage imageNamed:kGreenImageName];
            break;
        default:
            image = nil;
            break;
    }
    
    return image;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfDoubleRows = self.numberOfRows/2;
    NSInteger numberOfRowLeft = self.numberOfRows%2;
    return (kNumberOfItemsInEvenRow+kNumberOfItemsInOddRow)*(int)numberOfDoubleRows+kNumberOfItemsInOddRow*(int)numberOfRowLeft;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameBubbleCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"gameBubbleCell" forIndexPath:indexPath];
    
    NSInteger colorType = [self.gameGraph colorTypeForBubbleModelAtItem:indexPath.item];
    [self setColorType:colorType forCell:cell];
    
    return cell;
}

- (void)animation
{
    NSMutableArray *itemsRemoved = [NSMutableArray new];
    NSMutableArray *itemsDroped = [NSMutableArray new];
    for (NSNumber *number in self.itemsToRemove) {
        NSInteger item = [number integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        GameBubbleCell *cell= (GameBubbleCell *)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
        cell.backgroundView.alpha -= kAlphaChangeForRemoving;
        CGRect frame = cell.backgroundView.frame;
        cell.backgroundView.frame = CGRectMake(frame.origin.x-kExpandingRateForRemoving,
                                               frame.origin.y-kExpandingRateForRemoving,
                                               frame.size.width+kExpandingRateForRemoving*2,
                                               frame.size.width+kExpandingRateForRemoving*2);
        if (cell.backgroundView.alpha <= 0) {
            [itemsRemoved addObject:number];
        }
    }
    for (NSNumber *number in self.itemsToDrop) {
        NSInteger item = [number integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        GameBubbleCell *cell= (GameBubbleCell *)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
        cell.backgroundView.alpha -= kAlphaChangeForDroping;
        CGPoint center = cell.backgroundView.center;
        cell.backgroundView.center = CGPointMake(center.x, center.y+kDropingRateForDroping);
        if (cell.backgroundView.alpha <= 0) {
            [itemsDroped addObject:number];
        }
    }
    for (NSNumber *number in itemsRemoved) {
        [self.itemsToRemove removeObject:number];
    }
    for (NSNumber *number in itemsDroped) {
        [self.itemsToDrop removeObject:number];
    }
}

- (void)update
{
    [self animation];
    [self.gameGraph update];
}

- (void)removeCellAtItem:(NSInteger)item
{
    NSNumber *number = [NSNumber numberWithInteger:item];
    [self.itemsToRemove addObject:number];
}

- (void)dropCellAtItem:(NSInteger)item
{
    NSNumber *number = [NSNumber numberWithInteger:item];
    [self.itemsToDrop addObject:number];
}

- (void)addCellAtItem:(NSInteger)item withColorType:(NSInteger)colorType
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    GameBubbleCell *cell= (GameBubbleCell *)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
    [self setColorType:colorType forCell:cell];
}

- (void)removeGameBubbleViewWithIdentifier:(id)identifier
{
    if ([identifier isEqual:kBubbleToFireIdentifier]) {
        self.bubbleToFire.alpha = 0;
        [self.bubbleToFire removeFromSuperview];
        self.nextBubble.alpha = 0;
        [self.nextBubble removeFromSuperview];
        [self switchingNextTypeToCurrent];
    }
}

- (void)switchingNextTypeToCurrent
{
    self.currentFiringType = self.nextFiringType;
    [self produceNextFiringType];
    [self drawBubbleToFireAndNextBubble];
}

- (void)updateGameBubbleViewWithIdentifier:(id)identifier toPosition:(CGPoint)position
{
    if ([identifier isEqual:kBubbleToFireIdentifier]) {
        self.bubbleToFire.center = position;
    }
}

- (NSInteger)indexPathItemForLocation:(CGPoint)location
{
    CGRect frame = self.bubbleGridArea.frame;
    if (!CGRectContainsPoint(frame, location)) {
        [self gameOver];
        return kInvalidItem;
    }
    NSIndexPath *indexPath = [self.bubbleGridArea indexPathForItemAtPoint:CGPointMake(location.x, location.y-25)];
    if (!indexPath) {    // indexPath is nil, three possibilities
                         //   1.invalid location--out of bounds, somehow this case will pass the above checking
                         //   2. even row, left cornor
                         //   3. even row, right cornor
        indexPath = [self.bubbleGridArea indexPathForItemAtPoint:CGPointMake(location.x-kRadiusOfFiringBubble,
                                                                             location.y-25)];
        if (!indexPath) {
            indexPath = [self.bubbleGridArea indexPathForItemAtPoint:CGPointMake(location.x+kRadiusOfFiringBubble,
                                                                                 location.y-25)];
        }
        if (!indexPath) {    // case 1
            [self gameOver];
            return kInvalidItem;
        }
    }
    
    return indexPath.item;
}

- (void)fireBubble
{
    [self getFiringDirectionAndFire];
}

- (void)getFiringDirectionAndFire
{
    BOOL animationFinished = (self.itemsToDrop.count==0 && self.itemsToRemove.count==0);
    if (!self.isGameOver && self.isReadyForFiring && animationFinished) {
        self.isReadyForFiring = NO;
        [self.gameGraph fireGameBubbleInDirection:self.firingDirection withColorType:self.currentFiringType];
    }
}

- (void)gameOver
{
    self.isGameOver = YES;
    [self.timer invalidate];
    self.gameGraph.stopSimulating = YES;
    UIAlertView *gameLost = [[UIAlertView alloc] initWithTitle:@"Game Lost"
                                                       message:@"Sorry, you lost the game" delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [gameLost show];
}

@end
