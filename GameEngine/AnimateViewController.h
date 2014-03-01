//
//  AnimateViewController.h
//  ps04
//
//  Created by Gu Junchao on 2/10/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameEngine.h"
#import "AVSoundPlayer.h"
#import "GameResourcesManager.h"

static const CGFloat kOriginXOfNextFiringBubble = 25;
static const CGFloat kMaximumYReplacement = -20;
static const CGFloat kExpandingRate = 8;
static const CGFloat kDropingDistance = 100;
static const CGFloat kAnimationDuration = 0.2;
static const CGFloat kYIndentForBubblesArea = 25;
static const CGFloat kShakingConstant = 3;

@interface AnimateViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, GameEngineDelegate>
@property (strong, nonatomic) IBOutlet UIView *gameArea;
@property (strong, nonatomic) IBOutlet UICollectionView *bubbleGridArea;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (void)configureLoadingFilePath:(NSString *)filePath;

@end
