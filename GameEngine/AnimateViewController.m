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
@property (nonatomic) UIAlertView *gameLostAlert;
@property (nonatomic) UIAlertView *gameWonAlert;
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
    [self.gameArea addSubview:background];
    [self.gameArea sendSubviewToBack:background];
    
    [self.bubbleGridArea registerClass:[GameBubbleCell class] forCellWithReuseIdentifier:@"gameBubbleCell"];
    self.bubbleGridArea.layer.zPosition = 1;
    [self.bubbleGridArea setDataSource:self];
    [self.bubbleGridArea setDelegate:self];
    
    UIAlertView *gameLost = [[UIAlertView alloc] initWithTitle:@"Game Lost"
                                                       message:@"Sorry, you lost the game" delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
    gameLost.delegate = self;
    gameLost.tag = 1;
    self.gameLostAlert = gameLost;
    
    UIAlertView *gameWon = [[UIAlertView alloc] initWithTitle:@"Game Won"
                                                       message:@"Haha, you won the game" delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
    gameWon.delegate = self;
    gameWon.tag = 2;
    self.gameWonAlert = gameWon;
    
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
    self.cannonBase.layer.zPosition = 2;
    [self.view addSubview:self.cannonBase];
    UIImage *cannonWholeImage = [UIImage imageNamed:@"cannon.png"];
    CGRect frame = CGRectMake(kOriginXOfFiringBubble, kOriginYOfFiringBubble - kRadiusOfFiringBubble * 1,
                              kRadiusOfFiringBubble * 2, kRadiusOfFiringBubble * 4);
    NSMutableArray *images = [NSMutableArray new];
    
    for (int i = 0; i < 12; i++) {
        CGRect rect = CGRectMake(400 * (i%6), 800 * (i/6), 400, 800);
        CGImageRef imgRef = CGImageCreateWithImageInRect(cannonWholeImage.CGImage,  rect);
        UIImage *cannonPartImage = [UIImage imageWithCGImage:imgRef];
        if (i == 0) {
            self.cannonPart = [[UIImageView alloc] initWithImage:cannonPartImage];
            self.cannonPart.frame = frame;
            self.cannonPart.layer.zPosition = 2;
            self.cannonPart.layer.anchorPoint = CGPointMake(0.5, 1.25);
            [self.view addSubview:self.cannonPart];
        }
        [images addObject:cannonPartImage];
    }
    self.cannonPart.animationImages = images;
    self.cannonPart.animationDuration = kTimerInterval;
}

- (void)produceNextFiringType
{
    int num = (rand() % kNumberOfBubbleModelKindsCanBeFired) + 1;
    
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

- (void)configureLoadingFilePath:(NSString *)filePath
{
    self.filePath = filePath;
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
    if (!self.isGameOver && self.isReadyForFiring) {
        self.isReadyForFiring = NO;
        [self.cannonPart startAnimating];
        [UIView animateWithDuration:(kAnimationDuration / 2)
                         animations:^{
                             CGFloat radians = atan(-self.firingDirection.y / self.firingDirection.x);
                             if (radians > 0) {
                                 radians = M_PI_2 - radians;
                             } else if (radians < 0){
                                 radians = - M_PI_2 - radians;
                             }
                             self.cannonPart.transform = CGAffineTransformMakeRotation(radians);
                         } completion:^(BOOL finished){
                             [self stopCannonAndFireUpBubble];
                         }];
    }
}

- (void)stopCannonAndFireUpBubble
{
    [self.cannonPart stopAnimating];
    [self.gameEngine fireGameBubbleInDirection:self.firingDirection withColorType:self.currentFiringType];
}

- (void)gameOver
{
    self.isGameOver = YES;
    [self.timer invalidate];
    self.gameEngine.stopSimulating = YES;
    [self.gameLostAlert show];
}

- (void)gameWon
{
    [self.gameWonAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (alertView.tag == 2 && buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)removeCellAtItem:(NSInteger)item withColorType:(NSInteger)colorType
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    GameBubbleCell *cell= (GameBubbleCell *)[self.bubbleGridArea cellForItemAtIndexPath:indexPath];
    CGRect newFrame = CGRectMake(cell.backgroundView.frame.origin.x - kExpandingRate,
                                 cell.backgroundView.frame.origin.y - kExpandingRate,
                                 cell.backgroundView.frame.size.width + kExpandingRate * 2,
                                 cell.backgroundView.frame.size.height + kExpandingRate * 2);
    SoundPlayer *player = [[SoundPlayer alloc] initWithFileName:@"bubble-popping"];
    [player play];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        cell.backgroundView.alpha = 0;
        cell.backgroundView.frame = newFrame;
    } completion:^(BOOL finished){
            if (finished) {
                cell.backgroundView = nil;
                [player stopPlaying];
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
    [self animateShake:cell.backgroundView];
}

- (void)animateShake:(UIView*)itemView
{
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, kShakingConstant, -kShakingConstant);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -kShakingConstant, kShakingConstant);
    
    itemView.transform = leftQuake;  // starting point
    [UIView beginAnimations:@"animateShake" context:(__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:(kAnimationDuration / 16)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animateShakeEnded:finished:context:)];
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)animateShakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue])
    {
    	UIView* item = (__bridge UIView *)context;
    	item.transform = CGAffineTransformIdentity;
    }
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

- (void)noMoreBubblesVisible
{
    [self gameWon];
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
    NSInteger numberOfDoubleRows = self.numberOfRows / 2;
    NSInteger numberOfRowLeft = self.numberOfRows % 2;
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
