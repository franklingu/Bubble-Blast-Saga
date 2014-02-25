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
@property (nonatomic) GameEngine *gameEngine;
@property (nonatomic) UIView *bubbleToFire;
@property (nonatomic) UIView *nextBubble;
@property (nonatomic) UIImageView *cannonBase;
@property (nonatomic) UIImageView *cannonPart;
@property (nonatomic) NSTimer *timer;
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
    
    [self initializeAttributes];
    [self setUpMainViews];
}

- (void)initializeAttributes
{
    CGRect frame = self.gameArea.frame;
    frame.origin.y=25;
    self.gameEngine = [[GameEngine alloc] initWithFrame:frame];
    self.gameEngine.delegate = self;
    [self.gameEngine loadFromFilePath:self.filePath];
    self.numberOfRows = 13;
    self.isGameOver = NO;
    self.isReadyForFiring = NO;
    self.currentFiringType = 1;
    [self produceNextFiringType];
}

- (void)setUpMainViews
{
    UIImage* backgroundImage = [UIImage imageNamed:@"sky.png"];
    UIImageView* background = [[UIImageView alloc] initWithImage:backgroundImage];
    CGFloat gameViewWidth = self.gameArea.frame.size.width;
    CGFloat gameViewHeight = self.gameArea.frame.size.height;
    background.frame = CGRectMake(0, 0, gameViewWidth, gameViewHeight);
    //[self.gameArea addSubview:background];
    
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
    [self drawCannon];
}

- (void)drawBubbleToFireAndNextBubble
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithColorType:self.currentFiringType]];
    imageView.frame = CGRectMake(kOriginXOfFiringBubble, kOriginYOfFiringBubble,
                                 kRadiusOfFiringBubble * 2, kRadiusOfFiringBubble * 2);
    //imageView.layer.zPosition = 2;
    self.bubbleToFire = imageView;
    self.bubbleToFire.alpha = 1;
    [self.view addSubview:self.bubbleToFire];
    UIImageView *nextBubble = [[UIImageView alloc] initWithImage:[self imageWithColorType:self.nextFiringType]];
    nextBubble.frame = CGRectMake(kOriginXOfNextFiringBubble, kOriginYOfFiringBubble,
                                  kRadiusOfFiringBubble * 2, kRadiusOfFiringBubble * 2);
    self.nextBubble = nextBubble;
    self.nextBubble.alpha = 0.7;
    [self.view addSubview:self.nextBubble];
}

- (void)drawCannon
{
    UIImageView *cannonBaseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cannon-base.png"]];
    // magic numbers
    cannonBaseImageView.frame = CGRectMake(kOriginXOfFiringBubble-2, kOriginYOfFiringBubble-4,
                                           kRadiusOfFiringBubble * 2+4, kRadiusOfFiringBubble+6);
    self.cannonBase = cannonBaseImageView;
    [self.view addSubview:self.cannonBase];
    UIImage *cannonWholeImage = [UIImage imageNamed:@"cannon.png"];
    CGRect frame = CGRectMake(kOriginXOfFiringBubble, kOriginYOfFiringBubble - kRadiusOfFiringBubble * 4,
                              kRadiusOfFiringBubble * 2, kRadiusOfFiringBubble * 4);
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i < 12; i++) {
        CGRect rect = CGRectMake(400 * (i%6), 800 * (i/6), 400, 800);
        CGImageRef imgRef = CGImageCreateWithImageInRect(cannonWholeImage.CGImage,  rect);
        UIImage *cannonPartImage = [UIImage imageWithCGImage:imgRef];
        if (i == 0) {
            self.cannonPart = [[UIImageView alloc] initWithImage:cannonPartImage];
            self.cannonPart.frame = frame;
            //self.cannonPart.layer.anchorPoint = CGPointMake(kOriginXOfFiringBubble + kRadiusOfFiringBubble,
            //                                                kOriginYOfFiringBubble + kRadiusOfFiringBubble);
            //self.cannonPart.center = CGPointMake(kOriginYOfFiringBubble + kRadiusOfFiringBubble,
            //                                     kOriginYOfFiringBubble - kRadiusOfFiringBubble * 2);
            [self.view addSubview:self.cannonPart];
        }
        [images addObject:cannonPartImage];
    }
    self.cannonPart.animationImages = images;
    self.cannonPart.animationDuration = kTimerInterval;
}

- (void)produceNextFiringType
{
    int num = (rand()%kNumberOfBubbleModelKindsCanBeFired) + 1;
    
    self.nextFiringType = num;
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

- (void)fireBubble
{
    [self getFiringDirectionAndAnimate];
}

- (void)getFiringDirectionAndAnimate
{
    if (!self.isGameOver && self.isReadyForFiring) {
        [self animateCannon];
    }
}

- (void)animateCannon
{
    [self.cannonPart startAnimating];
    [UIView animateWithDuration:(kAnimationDuration / 2)
                     animations:^{
                         CGFloat radians = atan(-self.firingDirection.y / self.firingDirection.x);
                         NSLog(@"radians : %f", radians);
                         self.cannonPart.transform = CGAffineTransformMakeRotation(radians);
                     } completion:^(BOOL finished){
                         [self stopCannon];
                     }];
}

- (void)stopCannon
{
    [self.cannonPart stopAnimating];
    [self fireUpTheBubble];
}

- (void)fireUpTheBubble
{
    if (!self.isGameOver && self.isReadyForFiring){
        self.isReadyForFiring = NO;
        [self.gameEngine fireGameBubbleInDirection:self.firingDirection withColorType:self.currentFiringType];
    }
}

- (void)gameOver
{
    self.isGameOver = YES;
    [self.timer invalidate];
    self.gameEngine.stopSimulating = YES;
    UIAlertView *gameLost = [[UIAlertView alloc] initWithTitle:@"Game Lost"
                                                       message:@"Sorry, you lost the game" delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [gameLost show];
}

- (void)removeCellAtItem:(NSInteger)item
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    GameBubbleCell *cell= (GameBubbleCell *)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
    CGRect newFrame = CGRectMake(cell.backgroundView.frame.origin.x - kExpandingRate,
                                 cell.backgroundView.frame.origin.y - kExpandingRate,
                                 cell.backgroundView.frame.size.width + kExpandingRate * 2,
                                 cell.backgroundView.frame.size.height + kExpandingRate * 2);
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        cell.backgroundView.alpha = 0;
        cell.backgroundView.frame = newFrame;
    } completion:^(BOOL finished){
            if (finished) {
                cell.backgroundView = nil;;
            }
        }];
}

- (void)dropCellAtItem:(NSInteger)item
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    GameBubbleCell *cell= (GameBubbleCell *)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
    CGPoint dropCenter = CGPointMake(cell.backgroundView.center.x, cell.backgroundView.center.y + kDropingDistance);
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        cell.backgroundView.alpha = 0;
        cell.backgroundView.center = dropCenter;
    } completion:^(BOOL finished){
        if (finished) {
            cell.backgroundView = nil;
        }
    }];
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
    NSIndexPath *indexPath = [self.bubbleGridArea indexPathForItemAtPoint:CGPointMake(location.x,
                                                                                      location.y - kYIndentForBubblesArea)];
    if (!indexPath) { // try corner case
        indexPath = [self.bubbleGridArea indexPathForItemAtPoint:CGPointMake(location.x - kRadiusOfFiringBubble,
                                                                             location.y - kYIndentForBubblesArea)];
        if (!indexPath) { // try corner case
            indexPath = [self.bubbleGridArea indexPathForItemAtPoint:CGPointMake(location.x + kRadiusOfFiringBubble,
                                                                                 location.y - kYIndentForBubblesArea)];
        }
        if (!indexPath) {
            [self gameOver];
            return kInvalidItem;
        }
    }
    
    return indexPath.item;
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
        case 5:
            image = [UIImage imageNamed:kStarImageName];
            break;
        case 6:
            image = [UIImage imageNamed:kBombImageName];
            break;
        case 7:
            image = [UIImage imageNamed:kLightningImageName];
            break;
        case 8:
            image = [UIImage imageNamed:kIndestructibleImageName];
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
    
    NSInteger colorType = [self.gameEngine colorTypeForBubbleModelAtItem:indexPath.item];
    [self setColorType:colorType forCell:cell];
    
    return cell;
}

- (void)update
{
    [self.gameEngine update];
}

@end
